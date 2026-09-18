import SwiftUI

#if os(macOS)
/// Blocks app termination just long enough to flush any pending debounced
/// save. Without this, quitting right after typing can race the 400ms save
/// debounce and drop the last edit burst -- SwiftUI's `scenePhase` alone only
/// fires on backgrounding, not on quit.
@MainActor
final class CheatSheetAppDelegate: NSObject, NSApplicationDelegate {
    var store: NoteStore?

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        guard let store else { return .terminateNow }
        Task {
            await store.flushPendingChanges()
            NSApplication.shared.reply(toApplicationShouldTerminate: true)
        }
        return .terminateLater
    }
}
#endif

@main
struct CheatSheetApp: App {
    @AppStorage("showMenuBarQuickAccess") private var showMenuBarQuickAccess = true
    @State private var store: NoteStore
    #if os(macOS)
    @NSApplicationDelegateAdaptor(CheatSheetAppDelegate.self) private var appDelegate
    #endif

    init() {
        CheatSheetLaunchEnvironment.applyLaunchOverrides()
        let store = NoteStore(repository: CheatSheetLaunchEnvironment.makeRepository())
        _store = State(wrappedValue: store)
        #if os(macOS)
        appDelegate.store = store
        #endif
    }

    var body: some Scene {
        #if os(macOS)
        Window("CheatSheet", id: "main") {
            ContentView(store: store)
                .frame(minWidth: AppDesign.windowMinimumWidth, minHeight: AppDesign.windowMinimumHeight)
        }
        .defaultSize(width: 980, height: 680)
        .defaultPosition(.center)
        .windowResizability(.contentMinSize)
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unifiedCompact)
        .commands {
            SidebarCommands()
        }

        Settings {
            SettingsView()
        }

        MenuBarExtra("CheatSheet", systemImage: "note.text", isInserted: $showMenuBarQuickAccess) {
            MenuBarQuickAccessScene(store: store)
        }
        .menuBarExtraStyle(.window)
        #else
        WindowGroup {
            ContentView(store: store)
        }
        #endif
    }
}
