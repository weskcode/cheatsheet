# CheatSheet 1.2: App Store Release Kit

Everything needed to fill out App Store Connect (or a submission checklist
tool like Kickstart Premium) for version **1.2, build 14**. Every text field
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
no network access, no accounts, and no way for one user to see another
user's content. Nothing in the app scores above 4+ on any axis. If Apple's
expanded age-rating questionnaire (13+/16+/18+ categories, required since
Jan 31 2026) asks about data-linked advertising or profiling, answer **No**
to all. `PrivacyInfo.xcprivacy` declares zero data collection.

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

## 6. Description (1,346/4,000 characters)

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

CheatSheet stores everything only on your device using SwiftData and a shared app group between the app and its widget. There's no account, no internet connection required, and no analytics, ads, or third-party services of any kind. Nothing you write ever leaves your device.

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
| Support URL | `https://github.com/weskcode/cheatsheet/issues` |
| Marketing URL | `https://cheatsheet.apphq.online/` (branded landing page) |
| Privacy Policy URL | `https://cheatsheet.apphq.online/privacy` (live; full text, verified accurate) |
| Contact email | `weskcode@duck.com` |

Both pages are the branded AppHQ site, verified 2026-09-08: the landing page
lists all three platforms (Mac, iPhone, iPad) and the privacy page carries the
full policy (effective date, contact, local-only storage, no
accounts/analytics/third-parties/network) matching the App Privacy answers.
The GitHub Pages copy (`weskcode.github.io/cheatsheet/`) remains as a mirror/
fallback.

## 10. App Privacy ("Nutrition Label") questionnaire

Answer **"Data Not Collected"** for every category. This matches
`CheatSheetApp/Resources/PrivacyInfo.xcprivacy` /
`CheatSheetWidgets/Resources/PrivacyInfo.xcprivacy`
(`NSPrivacyTracking = false`, no collected data types declared) and
`PRIVACY.md`. Verified in the earlier appstore-review audit this session:
no Required Reason API is used beyond `UserDefaults`, correctly declared.

## 11. Screenshots

Ready in [`AppStoreScreenshots/final/`](../AppStoreScreenshots/final/README.md):
6 iPhone (1320×2868, 6.9" slot) + 3 iPad (2064×2752, 13" slot) + 3 Mac
(2880×1800, 16:10 slot). Upload in filename order.

## 12. Review Notes (paste into the "App Review Information" notes field)

```
CheatSheet has no login, no account system, and no server component of any kind. Every screen is reachable immediately after install. There is nothing to configure before reviewing.

To see note formatting: open any starter note, or create one and type a line starting with "#" (heading), "- " (bullet/checklist), or "- [ ]" / "- [x]" (open/done task).

To see the widget: long-press the Home Screen (iOS/iPadOS) or open the Notification Center widget gallery (macOS), add the CheatSheet widget, then pin a note in-app via the pin icon in the editor toolbar.

The app makes zero network calls and stores all data locally via SwiftData in an App Group container shared with the widget extension.
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

- ✅ **Privacy Policy URL**: RESOLVED. Live at
  `https://cheatsheet.apphq.online/privacy`, verified accurate. The GitHub
  Pages copy remains as a mirror.
- ❔ **EU Digital Services Act trader status**: required for EU distribution since Feb 2025; verified only inside App Store Connect, not from this repo.
- ✅ **Mac App Store screenshots**: RESOLVED. Three 2880×1800 (16:10)
  screenshots exist in `AppStoreScreenshots/final/mac-0{1,2,3}.png`, captured
  from a seeded Debug build with the same demo content the iPhone/iPad shots
  use (see `AppStoreScreenshots/raw/mac-raw-*.png`).
- ❔ **First-ever submission vs. update**: if App Store Connect doesn't already have this app's record, category/age-rating/URLs above are first-time setup, not just an edit.
