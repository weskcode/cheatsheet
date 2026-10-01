import SwiftUI

/// A short caption row for onboarding: a colored dot (one of the app's own
/// note colors) plus title/description. Deliberately not an icon-in-a-circle
/// -- the hero above already shows a real note, so these are captions
/// explaining it, not a second set of illustrations.
struct OnboardingStepRow: View {
    let dotColor: Color
    let title: LocalizedStringKey
    let description: LocalizedStringKey

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Circle()
                .fill(dotColor)
                .frame(width: 8, height: 8)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))

                Text(description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
