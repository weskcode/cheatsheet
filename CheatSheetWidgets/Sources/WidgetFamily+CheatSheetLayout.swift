import SwiftUI
import WidgetKit

extension WidgetFamily {
    var contentPadding: CGFloat {
        switch self {
        case .systemSmall: 16
        case .systemMedium: 18
        default: 20
        }
    }

    /// Base line count per family, scaled down at larger note text sizes so a
    /// bigger font doesn't overflow the widget's fixed content box.
    func lineLimit(for fontSize: CheatSheetFontSize) -> Int {
        let base: Int
        switch self {
        case .systemSmall: base = 4
        case .systemMedium: base = 5
        default: base = 9
        }

        switch fontSize {
        case .small: return base + 1
        case .medium: return base
        case .large: return max(2, base - 2)
        }
    }

    var lineSpacing: CGFloat {
        switch self {
        case .systemSmall: 6
        default: 8
        }
    }

    var verticalSpacing: CGFloat {
        switch self {
        case .systemSmall: 10
        default: 14
        }
    }

    func titleFont(for fontStyle: CheatSheetFontStyle) -> Font {
        switch self {
        case .systemSmall: .system(.headline, design: fontStyle.design).weight(.semibold)
        default: .system(.title3, design: fontStyle.design).weight(.semibold)
        }
    }
}
