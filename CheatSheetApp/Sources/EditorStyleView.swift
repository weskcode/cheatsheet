import SwiftUI

struct EditorStyleView: View {
    @Binding var note: CheatSheetNote
    @Binding var fontSize: CheatSheetFontSize
    @Environment(\.dismiss) private var dismiss
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
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
                    .frame(
                        minWidth: presentationWidth,
                        idealWidth: presentationWidth,
                        idealHeight: AppDesign.stylePopoverHeight
                    )
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
        #if os(macOS)
        .frame(width: presentationWidth)
        .frame(minHeight: AppDesign.stylePopoverHeight)
        #endif
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
        (horizontalSizeClass == .compact || verticalSizeClass == .compact) ? nil : AppDesign.stylePopoverWidth
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
