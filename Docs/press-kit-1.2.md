# CheatSheet: Press Kit & Launch Materials (1.2)

Copy-paste materials for a press kit page, journalist outreach, Product Hunt,
Apple's editorial nomination, and social launch posts. Every claim below is
verified against the current codebase.

## Fact sheet

| | |
| --- | --- |
| Name | CheatSheet |
| Tagline | Notes & commands, at hand |
| One-liner | An open-source notes app for macOS, iOS, and iPadOS that keeps your everyday commands and checklists one glance away. |
| Developer | Wesley Keetch |
| Platforms | macOS, iOS, iPadOS (+ WidgetKit widgets on all three) |
| Price | Free (adjust if you've set a price in App Store Connect) |
| Category | Productivity |
| Version | 1.2 |
| License | MIT, open source |
| Website / source | https://github.com/weskcode/cheatsheet |
| Support | https://github.com/weskcode/cheatsheet/issues |
| Email | weskcode@duck.com |
| Icon | `CheatSheetApp/Resources/Assets.xcassets/AppIcon.appiconset/icon_1024.png` |
| Screenshots | `AppStoreScreenshots/final/` (9 images) and `Docs/Images/` (5 marketing photos) |

## Boilerplate (for a press kit "About" section or article footer)

```
CheatSheet is a free, open-source notes app for macOS, iOS, and iPadOS built
around one idea: the commands and checklists you use every day should be one
glance away, not buried in a search history. It auto-formats plain-text
headings, bullets, and checkboxes as you type, pins a note to a Home Screen
or menu bar widget, and stores everything locally with no account, no ads,
and no network calls of any kind. CheatSheet is free and open source under
the MIT license.
```

## Elevator pitch (one sentence)

```
CheatSheet is the notes app for people who keep forgetting the same git
command: type it once, pin it to a widget, never look it up again.
```

## Journalist / newsletter pitch email

```
Subject: CheatSheet, an open-source cheat-sheet app that never phones home

Hi [name],

I'm launching CheatSheet 1.2, a free, open-source notes app for macOS, iOS,
and iPadOS built for one specific habit: looking up the same git command,
keyboard shortcut, or checklist over and over.

What makes it different from a generic notes app:
- Plain text auto-formats into headings, bullets, and checkboxes as you type
- Pin one note to a Home Screen or menu bar widget so it's visible without
  opening the app
- Zero network calls, no account, no analytics, no ads (verified in the
  source, since the whole app is MIT-licensed and open source)
- Native on Mac, iPhone, and iPad, with an adaptive layout on each

I'd love for you to try it. I'm happy to send a TestFlight link, or it's
already live on the App Store: [App Store link].

Thanks for your time,
Wesley
```

## Product Hunt

**Tagline (60 char max):**
```
The cheat sheet app for commands you keep forgetting
```

**Maker's first comment:**
```
Hey Product Hunt 👋

I built CheatSheet because I was tired of re-Googling the same `git
rebase` incantation every few weeks. It's a small, native notes app for
Mac, iPhone, and iPad that auto-formats plain text into checklists and
headings, and lets you pin one note to a widget so the thing you always
forget is just... visible.

It's free, open source (MIT), and makes zero network calls. Everything
stays on your device. Would love your feedback, especially on what other
"I keep forgetting this" use cases it should cover.
```

## Apple editorial nomination (App Store Connect → "Nominate for Editorial Consideration")

```
CheatSheet is a native, open-source notes app for Mac, iPhone, and iPad
built around a narrow, well-solved problem: the commands and checklists a
developer or power user looks up again and again. Plain text auto-formats
into headings, bullets, and checkboxes with no markdown syntax to learn, one
note can be pinned to a Home Screen or menu bar widget, and the app makes
zero network calls: no account, no ads, no analytics, ever. It's fully
native SwiftUI, built for iOS 26 and macOS 26, with adaptive layouts for
each device and full Spanish localization.
```

## Social launch posts

**Short (X / Mastodon, ~280 chars):**
```
Shipped CheatSheet 1.2 today: a free, open-source notes app for Mac,
iPhone, and iPad. Type plain text, get real checklists. Pin one note to a
widget. Zero network calls, ever. Now with Spanish localization and iPad
fixes. 🔗 [App Store link]
```

**Longer (LinkedIn / blog-style):**
```
I just shipped CheatSheet 1.2.

CheatSheet is a small, native notes app for Mac, iPhone, and iPad built
around one habit: looking up the same command or checklist over and over.
Write plain text, it auto-formats into headings and checkboxes as you go.
Pin one note to a widget so it's visible without opening the app.

It's free, open source under the MIT license, and makes zero network
calls: no account, no ads, no analytics, nothing leaves your device.

1.2 adds Spanish localization, fixes a handful of iPad-specific bugs, and
is now built for iOS 26 and macOS 26.

[App Store link] · [GitHub link]
```

## What NOT to claim

Keep every public claim inside what's actually true of this build: no
review counts, ratings, "#1", or award language until they're real. The
zero-network-calls and open-source claims above are directly verifiable in
the source, so lead with them.
