import SwiftUI

struct EditorStyleView: View {
    @Binding var note: CheatSheetNote
    @Binding var fontSize: CheatSheetFontSize
    @Environment(\.dismiss) private var dismiss
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif

    var body: some View {
        Group {
            #if os(macOS)
            VStack(spacing: 0) {
                HStack {
                    Text("Style").font(.headline)
                    Spacer()
                    doneButton
                }
                .padding(AppDesign.panelPadding)
                styleForm
            }
            #else
            NavigationStack {
                styleForm
                    .navigationTitle("Style")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            doneButton
                        }
                    }
            }
            #endif
        }
        .frame(width: presentationWidth)
        .frame(minHeight: AppDesign.stylePopoverMinimumHeight)
    }

    private var styleForm: some View {
        Form {
            Section("Note color") {
                GlassPalettePicker(selection: $note.tintHex)
            }
            Section {
                FontStylePicker(selection: $note.fontStyle)
            } header: {
                Text("Note font")
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityHidden(true)
            }
            Section {
                FontSizePicker(selection: $fontSize)
            } header: {
                Text("Note text size")
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityHidden(true)
            }
        }
        .formStyle(.grouped)
    }

    private var doneButton: some View {
        Button("Done") { dismiss() }
            .accessibilityIdentifier("note-style-done-button")
            #if os(macOS)
            .keyboardShortcut(.defaultAction)
            #endif
    }

    private var presentationWidth: CGFloat? {
        #if os(iOS)
        horizontalSizeClass == .compact ? nil : AppDesign.stylePopoverWidth
        #else
        AppDesign.stylePopoverWidth
        #endif
    }
}

#Preview("Style") {
    @Previewable @State var note = CheatSheetNote(title: "Git Rescue", body: "git status")
    @Previewable @State var fontSize: CheatSheetFontSize = .medium
    EditorStyleView(note: $note, fontSize: $fontSize)
}
