# CheatSheet 1.2: App Store Release Kit

Draft metadata for version **1.2**. ASC currently references macOS build **39**
and iOS build **42**, which predate the focused-editor changes. No final
replacement build has been approved or uploaded. Check this copy against the
final candidate before staging it. Physical-device QA and the recording remain
pending. Character counts below are measured from these draft text blocks.

Spanish listing copy is drafted in
[`Docs/app-store-localization-es.md`](app-store-localization-es.md).
Live app-info and iOS/Mac 1.2 version queries returned only en-US on
2026-11-04. Runtime Spanish support and staged Spanish store metadata are
separate checks. Reconcile the Spanish draft's app name before staging it.

---

## 1. App Information (one-time, or confirm unchanged)

| Field | Value |
| --- | --- |
| App Name | `Liquid Glass Notes: CheatSheet` |
| Bundle ID | `com.wesleykeetch.wesleycheatsheet` |
| SKU | `com.wesleykeetch.wesleycheatsheet` (existing, immutable) |
| Primary Language | English (U.S.) |
| Primary Category | **Productivity** |
| Secondary Category | **Developer Tools** (verified in ASC on 2026-11-04) |
| Content Rights | **No**: the app contains no third-party content (all content is the user's own local notes) |

## 2. Age Rating: 4+

The existing ASC age rating is **FOUR_PLUS**. The live declaration reports
content-frequency answers **NONE** and the listed feature booleans false.
Preserve the existing answers unless a product change requires reassessment.
A 4+ rating is separate from the Made for Kids designation.

The current source disables TelemetryDeck initialization and signals.
CheatSheet's own privacy manifest declares no collected data. The retained
SDK has its own potential-data declarations; see section 10.

## 3. App Name (30/30 characters)

```
Liquid Glass Notes: CheatSheet
```

This is the observed ASC name. The installed display name is CheatSheet.
Changing the store name requires an owner decision.

## 4. Subtitle (25/30 characters)

```
Notes & Commands, At Hand
```

Mirrors the Spanish subtitle's "a mano" (at hand) framing and adds two
keywords not present in the App Name.

## 5. Promotional Text (147/170 characters)

Editable any time without a new build or review. Update seasonally if useful.

```
Short notes, commands, and checklists always at hand, with widgets for macOS, iOS, and iPadOS. No account, no ads, no internet connection required.
```

## 6. Description (1,337/4,000 characters)

This draft corrects the live description's widget wording and note-transmission
claim. It has not been saved to App Store Connect.

```
CheatSheet is an open-source app for macOS, iOS, and iPadOS that keeps the short notes, checklists, and commands you use every day close at hand.

With CheatSheet you can:
- Write short, plain-text notes: no special syntax to learn.
- Search titles and note content instantly.
- See headings, bullets, and checklist items (open or done) rendered automatically in previews and widgets.
- Choose from ten note colors and four font styles to organize by project at a glance.
- Pin one note to a small, medium, or large Home Screen widget on iPhone and iPad, or a desktop/Notification Center widget on Mac.
- Move notes to Trash, restore them, delete them immediately, or let them expire automatically after 30 days.
- Capture a note or jump to a recent one straight from the macOS menu bar.
- Use adaptive layouts built for each device: compact on iPhone, split-view on iPad and Mac.

CheatSheet stores everything only on your device using SwiftData and a shared app group between the app and its widget. There's no account and no internet connection required to use the app. CheatSheet does not transmit your notes to an app-operated server.

Fully localized in English and Spanish, including onboarding, starter notes, and accessibility labels.

Lightweight, native, and built so jotting something down or looking something up is instant.
```

## 7. Keywords (66/100 characters)

```
checklist,reminder,git,widget,productivity,code,snippets,todo,ipad
```

This is the staged iOS keyword list. Mac has a separate 94-character list;
preserve the platform-specific metadata.

## 8. What's New in This Version (314/4,000 characters)

Both live 1.2 versions currently have an empty What's New field. The first
iOS release has no editable What's New field; leave it blank as documented in
[`physical-device-qa.md`](physical-device-qa.md). Keep the text below as a draft
for a release where the field is available. It must match the eventual uploaded
candidate. Do not change the waiting Mac version's metadata.

```
What's new in 1.2:
- Spanish localization throughout the app and widget.
- A redesigned note editor with color, font, and text-size controls in Style.
- Improved note navigation and editor layouts on iPhone, iPad, and Mac.
- Fixed headings such as C# and F# losing their trailing character in previews and widgets.
```

Physical QA and final-candidate checks remain pending. No iOS 26 floor test
was run in this session; local policy forbids restoring that runtime.

## 9. URLs and contact email

| Field | Value |
| --- | --- |
| Support URL | `https://cheatsheet.apphq.online/` |
| Marketing URL | `https://cheatsheet.apphq.online/` (branded landing page) |
| Privacy Policy URL | `https://cheatsheet.apphq.online/privacy` (corrected policy published) |
| Contact email | `weskcode@duck.com` |

The URL table describes iOS and app-level privacy fields. Mac support remains
`https://github.com/weskcode/cheatsheet/issues` and its marketing URL is empty.
No Mac field was changed.

The corrected AppHQ privacy policy was published and read back on 2026-11-04.
It discloses that TelemetryDeck is included but disabled in version 1.2.
The existing name, contact, download URL, and description fields were preserved.
The separate GitHub Pages policy previously described active analytics signals;
its deployment remains unverified. App Store Connect uses the corrected AppHQ URL.

## 10. App Privacy ("Nutrition Label") questionnaire

The owner's selected answer for version 1.2 is **Data Not Collected**.
`AnalyticsService` uses a placeholder App ID, so both SDK initialization and
signal sending return without calling TelemetryDeck. The dependency remains
included in the app.

A restored web-session check on 2026-11-04 confirmed Data Not Collected is
published. The program license (version 5033) and Developer Agreement are active.
After the owner's acceptance, a fresh agreement readback returned `pending=false`
and no contract messages. The earlier Schedule 2 alert is cleared. No agreement
was accepted by the agent. The public API alone does not establish privacy
publication.

The approved app-manifest correction sets `NSPrivacyCollectedDataTypes` to an
empty array, matching the disabled runtime behavior. The widget manifest also
declares no collected data types. Tracking is false in both owned manifests.
TelemetryDeck's bundled manifest remains unchanged: it declares Product
Interaction and Device ID for Analytics. Account for those declarations when
inspecting the final archive's aggregate privacy report. This does not mean
the disabled SDK is collecting data; recheck runtime behavior before answering
App Privacy for the final build. Enabling analytics or changing the dependency
requires separate approval. Submitted build 42 does not contain this correction.

## 11. Screenshots

Available in [`AppStoreScreenshots/final/`](../AppStoreScreenshots/final/README.md):
10 iPhone (1320×2868), 3 earlier iPad (2064×2752), and 10 Mac
(2880×1800) images are available locally. App Store Connect currently has
10 iPhone, 3 iPad, and 3 Mac screenshots. The uploaded Mac set differs
from the current local Mac set. Uploading replacements is a separate action.

## 12. Review notes draft (2,991/4,000 characters)

This answers Apple's six requests. Replace the recording placeholders with
verified physical-device evidence and bind the analytics statement to the final
candidate before staging it. Do not submit this block with placeholders.
The Mac version is waiting for review and has platform-specific notes; do not
replace those notes while preparing the iOS response.

```
CheatSheet 1.2 - Additional review information

1. Physical-device demonstration
Recording: [INSERT FINAL-CANDIDATE PHYSICAL-DEVICE VIDEO URL]
Device, OS version, and build: [INSERT VERIFIED RECORDING DETAILS]

2. Purpose and audience
CheatSheet is a personal notes and checklist app for the general public, including developers keeping coding notes and command reminders. It helps people capture and find short reference information and display a selected note in a widget. It is not restricted to a business or organization.

3. Setup and main features
No account, login credentials, sample files, or external hardware are required. Complete onboarding if shown. Open a starter note or choose New Note, then enter a title and text.

Try these lines to see formatting in previews and widgets:
# Heading
- Item
- [ ] Incomplete task
- [x] Completed task

Open Style above the editor to change color, font style, and text size. Search finds notes by title and text. Move a disposable note to Trash, open Show Trash, and restore it. Trash retains notes for up to 30 days; permanent deletion is also available.

Open a note and select the pin control labeled Use in Widget. Add CheatSheet through the system Home Screen widget picker on iPhone or iPad, or the desktop widget gallery on Mac. Small, medium, and large widgets display the selected note. Pin another note to change the selection. On Mac, the menu bar icon provides quick access to the pinned note, recent notes, and New Note.

Settings includes Show widget setup hint, Show onboarding next launch, and the privacy policy link.

Users write private local notes. There are no accounts, public posting, social feeds, subscriptions, or in-app purchases. Registration, login, account deletion, public-content reporting and blocking, and paid-content flows do not apply.

4. External services and tools
Core features use Apple's SwiftUI, SwiftData, and WidgetKit frameworks and an App Group container shared with the widget. Notes are stored locally and core features work offline. There is no external authentication, payment, AI, or content-provider service.

The current source includes the TelemetryDeck SDK, with analytics initialization and usage signals disabled. No analytics data is sent by this configuration. The SDK retains its own potential-data privacy declarations. The privacy policy is https://cheatsheet.apphq.online/privacy . Opening support or privacy links uses the browser.

5. Regional behavior
Features are the same in every region where the app is distributed. The app and widget support English and Spanish, with locale-aware dates and times. Store availability can differ by territory.

6. Regulated services and third-party material
CheatSheet is a personal productivity tool. It does not provide regulated professional services or distribute a catalog of protected third-party content. Users enter their own notes. No industry credentials or third-party content authorization are required for these features.
```

App Store Connect also asks for App Review Contact Information: a separate
first name, last name, phone number, and email, kept for Apple's internal
use during review. Use `weskcode@duck.com` for the email field there.

---

## Release state

Both 1.2 versions use **MANUAL** release. iOS is **REJECTED**; Mac is
**WAITING_FOR_REVIEW**. No release setting was changed. Build 42's conditional
approval remains unmet; it does not approve a replacement candidate, upload,
metadata publication, or submission.

## Open items: need you or App Store Connect access

- **Physical QA and final candidate**: all 23 unique UI cases have passing SE
  evidence across two test binaries. The 21 unchanged cases passed at `c5cf88e`
  with diff `8ba18be2`. The corrected sweep and marketing cases passed after a
  signed rebuild at `e8d61de` with reviewed diff `e4ac9581`. That exact five-file
  correction is committed as `489cd91`. The rebuild took 10.04 seconds; both
  affected cases passed with no failures, skips, or runtime warnings. This is
  combined evidence, not a single 23-case run on one binary. Earlier capacity
  stops, automation timeouts, and the failed diagnostic are historical evidence.
  The owner reports normal-disk cold-relaunch persistence, with limited installed
  binary identification. Actual widgets, VoiceOver, Mac Quick Capture, physical
  iPad checks, and final-candidate recording and screenshot parity remain pending.
  Mac minimum-window editing and Style opening and dismissal passed separately.
- **Privacy policies and App Privacy**: the corrected AppHQ policy is published,
  and a restored web-session check on 2026-11-04 confirmed Data Not Collected
  is published in ASC. The approved owned-manifest correction is applied.
  The Settings link opened Safari in a passing physical SE test at source
  `0a55950`; final-candidate runtime and archive privacy
  aggregation checks remain pending as described in section 10.
- **Mac App Store screenshots**: the uploaded set contains three images.
  Ten 2880×1800 images exist locally, from `mac-01.png` through `mac-10.png`.
  The uploaded set was inspected separately and has not been replaced.
- **Compatibility and declarations**: the restored web session confirmed
  iOS-on-Mac and iOS-on-Vision-Pro are enabled; neither setting was changed.
  This readback does not prove runtime compatibility. The returned medical-device
  declaration is pending but optional (`required=false`); no required pending
  declaration was returned. Trader self-assessment remains open as described
  below. Do not change declarations or compatibility settings without named
  approval.
- **Trader self-assessment**: the owner reports business or professional activity
  and an existing non-trader declaration. Owner self-assessment and confirmation
  of the account and app declarations remain pending. No DSA declaration change
  or publication of contact information is authorized or made.
  Current agreement readback has no pending alert; do not treat the former
  Schedule 2 alert or expired web session as current blockers.
