import SwiftUI
import WidgetKit

struct CheatSheetWidgetView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.widgetFamily) private var family
    @Environment(\.widgetRenderingMode) private var renderingMode
    @AppStorage(CheatSheetFontSize.storageKey, store: CheatSheetFontSize.sharedDefaults)
    private var fontSize: CheatSheetFontSize = .medium
    let entry: CheatSheetEntry

    var body: some View {
        Group {
            if let note = entry.note {
                noteView(note)
            } else {
                emptyState
            }
        }
        .padding(family.contentPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .containerBackground(for: .widget) {
            widgetBackground
        }
        .accessibilityElement(children: .combine)
    }

    private func noteView(_ note: CheatSheetNote) -> some View {
        let limit = family.lineLimit(for: fontSize)
        let allLines = note.displayLines
        let shownLines = Array(allLines.prefix(limit))
        let remainingCount = allLines.count - shownLines.count

        return VStack(alignment: .leading, spacing: family.verticalSpacing) {
            header(title: note.displayTitle, systemImage: "text.page.fill", tint: note.tint, fontStyle: note.fontStyle)

            VStack(alignment: .leading, spacing: family.lineSpacing) {
                ForEach(shownLines) { line in
                    WidgetLineView(line: line, fontStyle: note.fontStyle, fontSize: fontSize)
                }

                if remainingCount > 0 {
                    Text(String(
                        localized: "widget.moreLines.count",
                        defaultValue: "+\(remainingCount) more"
                    ))
                    .font(.system(.caption2, design: note.fontStyle.design))
                    .foregroundStyle(primaryTextStyle.opacity(0.7))
                }
            }

            Spacer(minLength: 0)
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: family.verticalSpacing) {
            header(
                title: String(localized: "widget.emptyState.title", defaultValue: "No Widget Note"),
                systemImage: "note.text.badge.plus",
                tint: CheatSheetPalette.blue.color,
                fontStyle: .rounded
            )

            Text("Pin or create a note in CheatSheet to show it here.")
                .font(.system(.caption, design: .rounded).weight(.medium))
                .foregroundStyle(primaryTextStyle)
                .lineLimit(family == .systemSmall ? 3 : 5)

            Spacer(minLength: 0)
        }
    }

    private func header(
        title: String,
        systemImage: String,
        tint: Color,
        fontStyle: CheatSheetFontStyle
    ) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.headline)
                .foregroundStyle(renderingMode == .fullColor ? tint : .white)
                .widgetAccentable()
                .accessibilityHidden(true)

            Text(title)
                .font(family.titleFont(for: fontStyle))
                .foregroundStyle(primaryTextStyle)
                .lineLimit(family == .systemSmall ? 1 : 2)
                .minimumScaleFactor(0.8)

            Spacer(minLength: 0)
        }
    }

    @ViewBuilder
    private var widgetBackground: some View {
        if renderingMode == .fullColor {
            // Onboarding tells the user the widget "follows" their note's
            // color; the base gradient supplies contrast/structure, and this
            // tint wash is what actually carries the note's own color into it.
            ZStack {
                baseGradient
                (entry.note?.tint ?? CheatSheetPalette.blue.color)
                    .opacity(colorScheme == .dark ? 0.24 : 0.16)
            }
        } else {
            Color.clear
        }
    }

    private var baseGradient: LinearGradient {
        switch colorScheme {
        case .dark:
            LinearGradient(
                colors: [
                    Color(red: 0.12, green: 0.14, blue: 0.18),
                    Color(red: 0.05, green: 0.06, blue: 0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            LinearGradient(
                colors: [
                    Color(red: 0.94, green: 0.97, blue: 1.0),
                    Color(red: 0.82, green: 0.89, blue: 0.98)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private var primaryTextStyle: Color {
        renderingMode == .fullColor ? .primary : .white
    }
}
