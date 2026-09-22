import SwiftUI

struct FontSizePicker: View {
    @Binding var selection: CheatSheetFontSize

    var body: some View {
        Menu {
            ForEach(CheatSheetFontSize.allCases) { size in
                Button {
                    selection = size
                } label: {
                    Label {
                        Text(size.displayName)
                    } icon: {
                        Image(systemName: selection == size ? "checkmark" : "textformat.size")
                    }
                }
            }
        } label: {
            Label(selection.displayName, systemImage: "textformat.size")
        }
        .menuStyle(.button)
        .controlSize(.small)
        .help("Choose note text size")
        .accessibilityLabel("Note text size")
        .accessibilityValue(selection.displayName)
        .accessibilityIdentifier("font-size-picker")
    }
}
