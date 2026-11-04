import SwiftUI
import WidgetKit

struct EditorTextPanel: View {
    @Binding var note: CheatSheetNote
    let pinAction: () -> Void

    @AppStorage(CheatSheetFontSize.storageKey, store: CheatSheetFontSize.sharedDefaults)
    private var fontSize: CheatSheetFontSize = .medium

    var body: some View {
        VStack(spacing: AppDesign.editorSectionSpacing) {
            EditorHeader(note: $note, fontSize: $fontSize, pinAction: pinAction)

            TextEditor(text: $note.body)
                .accessibilityIdentifier("note-body-editor")
                .font(.system(fontSize.bodyTextStyle, design: note.fontStyle.design))
                .lineSpacing(5)
                .scrollContentBackground(.hidden)
                .padding(AppDesign.editorTextPadding)
                .background(.background, in: RoundedRectangle(cornerRadius: AppDesign.editorCornerRadius, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: AppDesign.editorCornerRadius, style: .continuous)
                        .strokeBorder(Color(hex: note.tintHex), lineWidth: 1)
                }
                #if os(iOS)
                .scrollDismissesKeyboard(.interactively)
                #endif
        }
        .onChange(of: fontSize) { _, _ in
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

#Preview("Editor") {
    @Previewable @State var note = CheatSheetNote(
        title: "Git Rescue",
        body: "git status\ngit log --oneline\ngit restore --staged ."
    )
    EditorTextPanel(note: $note, pinAction: {})
        .padding()
}
