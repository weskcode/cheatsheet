import SwiftUI

struct EditorHeader: View {
    @Binding var note: CheatSheetNote
    @Binding var fontSize: CheatSheetFontSize
    let pinAction: () -> Void
    @State private var showsStyle = false
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("Title", text: $note.title)
                .font(.title)
                .textFieldStyle(.plain)
                .foregroundStyle(.primary)
                .accessibilityIdentifier("note-title-field")

            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: 10) {
                    statusLabel
                    HStack {
                        styleButton
                        Spacer(minLength: 8)
                        pinButton
                    }
                }
            } else {
                HStack(spacing: 12) {
                    statusLabel
                        .frame(maxWidth: .infinity, alignment: .leading)
                    styleButton
                    pinButton
                }
            }
        }
    }

    private var statusLabel: some View {
        Label(note.isPinned ? "Shown in widget" : "Editable note", systemImage: note.isPinned ? "pin.fill" : "text.alignleft")
            .font(.caption)
            .foregroundStyle(.secondary)
    }

    private var styleButton: some View {
        Button {
            showsStyle = true
        } label: {
            Label("Style", systemImage: "textformat")
                #if os(iOS)
                .frame(minHeight: AppDesign.minimumHitSize)
                #endif
        }
        .glassCompatibleButtonStyle()
        .fixedSize(horizontal: true, vertical: false)
        .accessibilityIdentifier("note-style-button")
        .popover(isPresented: $showsStyle) {
            EditorStyleView(note: $note, fontSize: $fontSize)
                #if os(iOS)
                .presentationCompactAdaptation(.sheet)
                #endif
        }
    }

    private var pinButton: some View {
        Button(action: pinAction) {
            Label(note.isPinned ? "Pinned to Widget" : "Use in Widget", systemImage: note.isPinned ? "pin.fill" : "pin")
                #if os(iOS)
                .frame(minWidth: AppDesign.minimumHitSize, minHeight: AppDesign.minimumHitSize)
                #endif
        }
        .labelStyle(.iconOnly)
        .controlSize(.small)
        .glassCompatibleButtonStyle(prominent: note.isPinned)
        .help(note.isPinned ? "This note appears in the widget" : "Show this note in the widget")
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(note.isPinned ? "Pinned to Widget" : "Use in Widget")
        .accessibilityAddTraits(note.isPinned ? [.isSelected] : [])
        .accessibilityIdentifier("widget-pin-button")
    }
}
