import SwiftUI

struct GlassPaletteSwatchButton: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let swatch: CheatSheetPalette
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Circle()
                .fill(swatch.color)
                .frame(width: 16, height: 16)
                .scaleEffect(isSelected ? 1.12 : 1)
                .overlay {
                    selectedIndicator
                }
                .overlay {
                    Circle()
                        .stroke(borderStyle, lineWidth: isSelected ? 2 : 1)
                }
        }
        .buttonStyle(.plain)
        .frame(width: Self.hitTargetSize, height: Self.hitTargetSize)
        .contentShape(Rectangle())
        // Declares this as one opaque accessible element rather than letting
        // the circle/checkmark overlay expose themselves as separate children,
        // which otherwise interferes with the explicit label/value below.
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("\(swatch.displayName) note color"))
        .accessibilityIdentifier("palette-\(swatch.rawValue.lowercased())")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
        .help("Set \(swatch.displayName.lowercased()) note color")
        .animation(reduceMotion ? nil : .snappy(duration: 0.22), value: isSelected)
    }

    @ViewBuilder
    private var selectedIndicator: some View {
        if isSelected {
            Image(systemName: differentiateWithoutColor ? "checkmark.circle.fill" : "checkmark")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 10)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(2)
                .background(.black.opacity(0.35), in: Circle())
        }
    }

    private var borderStyle: AnyShapeStyle {
        isSelected ? AnyShapeStyle(.primary) : AnyShapeStyle(.secondary.opacity(0.35))
    }

    static var hitTargetSize: CGFloat {
        #if os(iOS)
        AppDesign.minimumHitSize
        #else
        26
        #endif
    }
}
