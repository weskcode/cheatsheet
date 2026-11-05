import SwiftUI

struct FontStylePicker: View {
    @Binding var selection: CheatSheetFontStyle

    var body: some View {
        Menu {
            ForEach(CheatSheetFontStyle.allCases) { style in
                Button {
                    selection = style
                } label: {
                    Label {
                        Text(style.displayName)
                            .font(.system(.body, design: style.design))
                    } icon: {
                        Image(systemName: selection == style ? "checkmark" : "textformat")
                    }
                }
            }
        } label: {
            Text(selection.displayName)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                #if os(iOS)
                .frame(minHeight: AppDesign.minimumHitSize)
                #endif
                .contentShape(Rectangle())
        }
        .menuStyle(.button)
        .controlSize(.small)
        .help("Choose note font")
        .accessibilityLabel("Note font")
        .accessibilityValue(selection.displayName)
        .accessibilityIdentifier("font-style-picker")
    }
}
