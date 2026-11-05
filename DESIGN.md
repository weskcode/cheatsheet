# CheatSheet editor design

Wes selected a blend of Native Notebook and Reference Sheet on 2026-11-03.
The note gets the main area of the editor. A single solid document surface has a
thin border in the note's selected color. Title, widget status and pinning stay
visible above it. Style opens the existing color, font and text-size controls in
a system presentation: a sheet on compact iPhone layouts, full screen in
landscape when height is compact, and a popover where space allows.

Use semantic system fonts and foreground colors. Keep the four existing font
choices, three shared text sizes and ten note colors. The editor uses the
existing `AppDesign` spacing and corner tokens. Popover dimensions also live in
`AppDesign`; text rows grow with Dynamic Type and the form scrolls.

Keep navigation, search, Trash, onboarding, Settings and widget behavior in their
existing flows. Note editing stays plain text. Changes to appearance apply
immediately, and Done closes Style without a separate save step. Reduce Motion
disables the palette selection animation.

Every control keeps its existing accessibility identifier. Style and its Done
button have identifiers for UI automation. New labels have English and Spanish
translations in the app's String Catalog.
