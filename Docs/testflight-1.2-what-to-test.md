# TestFlight "What to Test" (1.2, build 14)

Paste into App Store Connect → TestFlight → (build) → **Test Information →
What to Test**. Validated at 1,659 / 4,000 characters.

```
Hi! Thanks for testing CheatSheet 1.2. Here's what changed and what to check:

WHAT'S NEW
- Spanish localization: switch your device language to Spanish and confirm the app, onboarding, and widget read correctly.
- iPad fixes: search, Trash, and note navigation had layout bugs on iPad's split-view that are now fixed. Please try: searching from the sidebar, moving a note to Trash and restoring it, and permanently deleting a note from Trash.
- Heading fix: a note titled, say, "Swift Basics" with a body starting "# Swift Basics" used to show the title twice in the note list. Also, headings ending in # (like "# C#" or "# F#") used to lose the trailing #. Both are fixed. Check your existing notes look right, especially any with a heading ending in #.
- Now built for iOS 26 / macOS 26.

PLEASE TEST
1. Create a note, add a heading (#), a bullet (-), and a checklist item (- [ ] and - [x]). Confirm they render correctly in the list preview and the widget.
2. Pin a note and add the CheatSheet widget to your Home Screen (iOS/iPadOS) or widget gallery (macOS). Confirm it shows the pinned note and updates when you edit it.
3. Move a note to Trash, restore it, then permanently delete a different one. Confirm both work and the note list updates immediately.
4. Try search on whichever device you have: iPhone, iPad, and Mac all have different layouts.
5. Switch color and font style on a note and confirm the widget picks up the change.
6. If you can, briefly test in Spanish (Settings > General > Language & Region).

Found a bug or something confusing? Please include your device model and iOS/macOS version when you report it. Thanks for helping test!
```

## Shorter version (if you want a lighter-weight message)

```
CheatSheet 1.2: added Spanish localization, fixed iPad search/Trash/navigation bugs, and fixed a heading bug that dropped a trailing # (e.g. "C#"). Please test: creating a note with headings/checklists, pinning a note to the widget, Trash restore/delete, and search on your device. Report bugs with your device model + OS version. Thanks!
```
