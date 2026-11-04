# CheatSheet 1.2: App Store Release Kit

Everything needed to fill out App Store Connect (or a submission checklist
tool like Kickstart Premium) for version **1.2**: macOS build **39** and
iOS build **42**, both built from
`4bef828b3238d4c3e268227109960823afccda78`. Every text field
below is validated against Apple's character limits with
`app-store-aso/scripts/validate_metadata.py`. The count appears next to each
heading. Copy each block as-is; nothing needs editing unless you want to
change the wording.

Spanish (Mexico) localization metadata is a separate, already-complete file:
[`Docs/app-store-localization-es.md`](app-store-localization-es.md).

---

## 1. App Information (one-time, or confirm unchanged)

| Field | Value |
| --- | --- |
| App Name | `CheatSheet` |
| Bundle ID | `com.wesleykeetch.wesleycheatsheet` |
| SKU | any stable internal ID, e.g. `cheatsheet-macios` (cannot be changed later) |
| Primary Language | English (U.S.) |
| Primary Category | **Productivity** |
| Secondary Category | **Developer Tools** (recommended; not verified against Apple's live category list, so confirm at submission time) |
| Content Rights | **No**: the app contains no third-party content (all content is the user's own local notes) |

## 2. Age Rating: 4+

Every questionnaire descriptor should be answered **None** / **No**:
violence, mature themes, gambling, horror, alcohol/drugs, unrestricted web
access, user-generated content shared with others, contests. CheatSheet has
no accounts and no way for one user to see another user's content. Nothing
in the app scores above 4+ on any axis. If Apple's expanded age-rating
questionnaire (13+/16+/18+ categories, required since Jan 31 2026) asks
about data-linked advertising or profiling, answer **No** to all. The
app does not send analytics data in version 1.2. The included TelemetryDeck
SDK is disabled. CheatSheet's own privacy manifest declares no collected data.
The bundled SDK retains its own potential collection declarations; see section 10.

## 3. App Name (10/30 characters)

```
CheatSheet
```

Keep the existing live name. This is a resubmission (v1.1.0 shipped
2026-06-10), and renaming a published app's Name field loses search-ranking
history for no benefit here.

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

## 6. Description (1,304/4,000 characters)

```
CheatSheet is an open-source app for macOS, iOS, and iPadOS that keeps the short notes, checklists, and commands you use every day close at hand.

With CheatSheet you can:
- Write short, plain-text notes: no special syntax to learn.
- Search titles and note content instantly.
- See headings, bullets, and checklist items (open or done) rendered automatically in previews and widgets.
- Choose from ten note colors and four font styles to organize by project at a glance.
- Pin one note to a Home Screen, menu bar, or desktop widget on macOS, iOS, and iPadOS, in small, medium, or large sizes.
- Move notes to Trash, restore them, delete them immediately, or let them expire automatically after 30 days.
- Capture a note or jump to a recent one straight from the macOS menu bar.
- Use adaptive layouts built for each device: compact on iPhone, split-view on iPad and Mac.

CheatSheet stores everything only on your device using SwiftData and a shared app group between the app and its widget. There's no account and no internet connection required to use the app. Nothing you write ever leaves your device.

Fully localized in English and Spanish, including onboarding, starter notes, and accessibility labels.

Lightweight, native, and built so jotting something down or looking something up is instant.
```

## 7. Keywords (77/100 characters, comma-separated)

```
cheatsheet,checklist,reminder,git,widget,productivity,code,snippets,todo,ipad
```

Deliberately excludes "notes" and "commands": both already appear in the
App Name/Subtitle, which Apple indexes separately, so repeating them here
would waste characters per standard ASO practice.

## 8. What's New in This Version (310/4,000 characters)

```
What's new in 1.2:
- Added Spanish localization throughout the app and widget
- Fixed a bug where headings ending in # (like C# or F#) lost the trailing character in the editor and widget
- Fixed several iPad layout issues affecting search, Trash, and note navigation
- Built and tested for iOS 26 and macOS 26
```

Note: iPad has been a supported device family since before 1.2
(`TARGETED_DEVICE_FAMILY = "1,2"`). This release fixes iPad-specific bugs
that testing newly caught; it doesn't add iPad as a new platform.

## 9. URLs and contact email

| Field | Value |
| --- | --- |
| Support URL | `https://cheatsheet.apphq.online/` |
| Marketing URL | `https://cheatsheet.apphq.online/` (branded landing page) |
| Privacy Policy URL | `https://cheatsheet.apphq.online/privacy` (corrected policy published) |
| Contact email | `weskcode@duck.com` |

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

Read-only web-session checks on 2026-11-03 confirmed that Data Not Collected is
published and required agreements are active. Recheck the final candidate;
the public API alone does not establish privacy publication.

The approved app-manifest correction sets `NSPrivacyCollectedDataTypes` to an
empty array, matching the disabled runtime behavior. The widget manifest also
declares no collected data types. Tracking is false in both owned manifests.
TelemetryDeck's bundled manifest remains unchanged: it declares Product
Interaction and Device ID for Analytics. Xcode's aggregate archive privacy
report therefore still includes the SDK's declared types. This does not mean
the disabled SDK is collecting data; recheck runtime behavior before answering
App Privacy for the final build. Enabling analytics or changing the dependency
requires separate approval. Submitted build 42 does not contain this correction.

## 11. Screenshots

Available in [`AppStoreScreenshots/final/`](../AppStoreScreenshots/final/README.md):
10 iPhone (1320×2868), 3 earlier iPad (2064×2752), and 10 Mac
(2880×1800) images are available locally. App Store Connect currently has
10 iPhone, 3 iPad, and 3 Mac screenshots. The uploaded Mac set differs
from the current local Mac set. Uploading replacements is a separate action.

## 12. Review Notes (paste into the "App Review Information" notes field)

```
CheatSheet has no login, no account system, and no server component of any kind. Every screen is reachable immediately after install. There is nothing to configure before reviewing.

To see note formatting: open any starter note, or create one and type a line starting with "#" (heading), "- " (bullet/checklist), or "- [ ]" / "- [x]" (open/done task).

To see the widget: long-press the Home Screen (iOS/iPadOS) or open the Notification Center widget gallery (macOS), add the CheatSheet widget, then pin a note in-app via the pin icon in the editor toolbar.

The app has no login, no server component, and stores all data locally via SwiftData in an App Group container shared with the widget extension. Version 1.2 includes the TelemetryDeck SDK with analytics initialization and usage signals disabled. No analytics data is sent.
```

App Store Connect also asks for App Review Contact Information: a separate
first name, last name, phone number, and email, kept for Apple's internal
use during review. Use `weskcode@duck.com` for the email field there.

---

## Nice-to-haves (not required, cheap if you want them)

- **Enable App Store review status notifications**: App Store Connect →
  Users and Access → notification settings. Free, one toggle, tells you the
  moment a review outcome lands instead of you polling.
- **Apple's "App of the Day" / featuring nomination**: App Store Connect →
  your app version → "Nominate for Editorial Consideration." Costs nothing
  and takes two minutes, with no downside to submitting it.
- **Release type**: decide **Automatically release** vs **Manually release**
  this version before submitting. Manual release lets you pick the exact
  moment it goes live after approval (useful if you want to coordinate an
  announcement); automatic ships the moment Apple approves it.

## Open items: need you or App Store Connect access

- **Privacy policies and App Privacy**: the corrected AppHQ policy is published,
  and Data Not Collected is published in ASC. The approved owned-manifest
  correction is applied. The Settings link opened Safari in a passing physical
  SE test at source `0a55950`; final-candidate runtime and archive privacy
  aggregation checks remain pending as described in section 10.
- ❔ **EU Digital Services Act trader status**: required for EU distribution since Feb 2025; verified only inside App Store Connect, not from this repo.
- **Mac App Store screenshots**: the uploaded set contains three images.
  Ten 2880×1800 images exist locally, from `mac-01.png` through `mac-10.png`.
  The uploaded set was inspected separately and has not been replaced.
- ❔ **First-ever submission vs. update**: if App Store Connect doesn't already have this app's record, category/age-rating/URLs above are first-time setup, not just an edit.
