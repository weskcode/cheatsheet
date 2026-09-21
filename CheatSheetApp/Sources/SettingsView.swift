import SwiftUI

struct SettingsView: View {
    @AppStorage("showWidgetHints") private var showWidgetHints = true
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    #if os(macOS)
    @AppStorage("showMenuBarQuickAccess") private var showMenuBarQuickAccess = true
    #endif

    var body: some View {
        Form {
            #if os(macOS)
            Section {
                Toggle("Show menu bar quick access", isOn: $showMenuBarQuickAccess)
            } footer: {
                Text("Adds a CheatSheet icon to the menu bar for quick capture and recent notes.")
            }
            #endif

            Section {
                Toggle("Show widget setup hint", isOn: $showWidgetHints)
            } footer: {
                Text("Pin a note, then add the CheatSheet widget on a supported platform.")
            }

            Section {
                Button("Show onboarding next launch") {
                    hasCompletedOnboarding = false
                }
            }
        }
        .formStyle(.grouped)
        #if os(macOS)
        .scenePadding()
        .frame(minWidth: 320, idealWidth: 360, maxWidth: 440)
        #endif
    }
}
