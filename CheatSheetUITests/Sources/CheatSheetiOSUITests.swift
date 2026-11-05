import XCTest

@MainActor
final class CheatSheetiOSUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Launches with an in-memory store so the suite never touches the real
    /// App Group data, and with a deterministic onboarding state.
    private func launchApp(showOnboarding: Bool = false, extraArguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = [
            "-cheatsheet-ui-testing",
            showOnboarding ? "-cheatsheet-reset-onboarding" : "-cheatsheet-skip-onboarding",
            // This suite asserts rendered English text throughout, so pin the
            // locale rather than depending on the simulator's default.
            "-AppleLanguages", "(en)",
            "-AppleLocale", "en_US"
        ] + extraArguments
        app.launch()
        return app
    }

    func testOnboardingCanBeDismissedIntoTheNotesList() throws {
        let app = launchApp(showOnboarding: true)

        let doneButton = app.buttons["onboarding-done-button"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 10), "Expected onboarding to appear on first launch.")

        doneButton.tap()

        XCTAssertTrue(
            app.buttons["new-note-button"].waitForExistence(timeout: 10),
            "Expected the notes surface after dismissing onboarding."
        )
    }

    func testLaunchShowsSeededNotesWhenOnboardingIsComplete() throws {
        let app = launchApp()

        XCTAssertTrue(
            app.buttons["new-note-button"].waitForExistence(timeout: 10),
            "Expected the notes surface to load."
        )
        XCTAssertTrue(
            app.staticTexts["Widget Formatting Demo"].waitForExistence(timeout: 10),
            "Expected the seeded starter note in the isolated store."
        )
    }

    func testPrivacyPolicyIsAccessibleFromSettings() throws {
        let app = launchApp()
        XCTAssertTrue(app.buttons["new-note-button"].waitForExistence(timeout: 10))
        openSecondaryAction("Settings", in: app)
        let policy = app.descendants(matching: .any)["privacy-policy-link"]
        XCTAssertTrue(policy.waitForExistence(timeout: 10))
        XCTAssertEqual(policy.label, "Privacy Policy")
        XCTAssertTrue(policy.isHittable)
        capture(app, "settings-privacy-policy")
        policy.tap()
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        XCTAssertTrue(safari.wait(for: .runningForeground, timeout: 10))
        app.activate()
        XCTAssertTrue(policy.waitForExistence(timeout: 10))
        XCTAssertTrue(app.buttons["Done"].isHittable)
    }

    func testWidgetHintSettingSurvivesRelaunch() throws {
        let app = launchApp()
        XCTAssertTrue(app.buttons["new-note-button"].waitForExistence(timeout: 10))
        openSecondaryAction("Settings", in: app)
        let initialValue = try XCTUnwrap(widgetHintSwitch(in: app).value as? String)
        XCTAssertTrue(["0", "1"].contains(initialValue))

        for expectedValue in [initialValue == "1" ? "0" : "1", initialValue] {
            let toggle = widgetHintSwitch(in: app)
            toggle.tap()
            let changed = XCTNSPredicateExpectation(predicate: NSPredicate(format: "value == %@", expectedValue), object: toggle)
            XCTAssertEqual(XCTWaiter.wait(for: [changed], timeout: 5), .completed)

            app.terminate()
            app.launch()
            openSecondaryAction("Settings", in: app)
            XCTAssertEqual(widgetHintSwitch(in: app).value as? String, expectedValue)
        }
    }

    func testSettingsCanShowOnboardingOnNextLaunch() throws {
        let app = launchApp()
        XCTAssertTrue(app.buttons["new-note-button"].waitForExistence(timeout: 10))
        openSecondaryAction("Settings", in: app)
        let resetButton = app.buttons["Show onboarding next launch"]
        XCTAssertTrue(resetButton.waitForExistence(timeout: 10))
        resetButton.tap()

        app.terminate()
        app.launchArguments.removeAll { $0 == "-cheatsheet-skip-onboarding" }
        app.launch()
        let doneButton = app.buttons["onboarding-done-button"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["Add notes"].waitForExistence(timeout: 10))
        doneButton.tap()
        XCTAssertTrue(app.buttons["new-note-button"].waitForExistence(timeout: 10))

        app.terminate()
        app.launch()
        XCTAssertTrue(app.buttons["new-note-button"].waitForExistence(timeout: 10))
        XCTAssertFalse(app.buttons["onboarding-done-button"].exists)
    }

    private func widgetHintSwitch(in app: XCUIApplication) -> XCUIElement {
        let labeledToggle = app.switches["Show widget setup hint"]
        XCTAssertTrue(labeledToggle.waitForExistence(timeout: 10))
        let control = labeledToggle.switches.firstMatch
        return control.exists ? control : labeledToggle
    }

    func testCreatingANoteAddsItToTheList() throws {
        let app = launchApp()

        let newNoteButton = app.buttons["new-note-button"]
        XCTAssertTrue(newNoteButton.waitForExistence(timeout: 10))
        newNoteButton.tap()

        // Creating a note pushes straight into its editor.
        let titleField = app.textFields["New Cheat Sheet"]
        XCTAssertTrue(
            titleField.waitForExistence(timeout: 10),
            "Expected the new note's editor to open with its default title."
        )
    }

    func testStorageBannerIsAbsentOnAHealthyLaunch() throws {
        let app = launchApp()

        XCTAssertTrue(app.buttons["new-note-button"].waitForExistence(timeout: 10))
        XCTAssertFalse(
            app.otherElements["persistence-status-banner"].exists,
            "The storage failure banner must not appear when persistence is healthy."
        )
    }

    func testEditAndSearchFlow() throws {
        let app = launchApp()
        createNote(in: app)

        let titleField = app.textFields["note-title-field"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 10))
        selectAllText(in: titleField, app: app)
        titleField.typeText("Release Commands")

        // Return ends title editing. On iPhone Duo the keyboard and its
        // suggestion bar cover the whole note editor, so it has to go first.
        titleField.typeText("\n")
        let bodyEditor = app.textViews["note-body-editor"]
        XCTAssertTrue(bodyEditor.waitForExistence(timeout: 10))
        bodyEditor.tap()
        bodyEditor.typeText("\n- [ ] Upload build")

        returnToList(in: app)
        XCTAssertTrue(app.staticTexts["Release Commands"].waitForExistence(timeout: 10))

        let searchField = revealSearchField(in: app)
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))
        searchField.tap()
        searchField.typeText("release")
        XCTAssertTrue(app.staticTexts["Release Commands"].waitForExistence(timeout: 10))
        XCTAssertFalse(app.staticTexts["Git Flow"].exists)
    }

    func testStyleAndWidgetPinFlow() throws {
        let app = launchApp()
        createNote(in: app)

        let titleField = app.textFields["note-title-field"]
        let pinButton = app.buttons["Use in Widget"]
        XCTAssertTrue(pinButton.waitForExistence(timeout: 10))
        XCTAssertGreaterThanOrEqual(titleField.frame.minX, app.frame.minX)
        XCTAssertLessThanOrEqual(pinButton.frame.maxX, app.frame.maxX)

        openStyle(in: app)
        let mintButton = app.buttons["palette-59c979"]
        XCTAssertTrue(mintButton.waitForExistence(timeout: 10))
        mintButton.tap()
        XCTAssertEqual(mintButton.value as? String, "Selected")

        let fontPicker = app.buttons["font-style-picker"]
        XCTAssertTrue(fontPicker.waitForExistence(timeout: 10))
        fontPicker.tap()
        let serifButton = app.buttons["Serif"]
        XCTAssertTrue(serifButton.waitForExistence(timeout: 10))
        serifButton.tap()
        XCTAssertEqual(fontPicker.value as? String, "Serif")

        closeStyle(in: app)
        XCTAssertTrue(pinButton.waitForExistence(timeout: 10))
        pinButton.tap()
        XCTAssertTrue(app.staticTexts["Shown in widget"].waitForExistence(timeout: 10))
    }

    func testPaletteTapTargetsDoNotOverlap() throws {
        let app = launchApp()
        createNote(in: app)
        openStyle(in: app)
        let colors = ["4b88ff", "45c7c4", "8b7cff", "59c979", "8fbf3f", "d99a2b", "e86f51", "e85d75", "5d6bff", "5c6470"]
        let swatches = colors.map { app.buttons["palette-\($0)"] }
        for (index, swatch) in swatches.enumerated() {
            XCTAssertTrue(swatch.waitForExistence(timeout: 10))
            XCTAssertTrue(swatch.isHittable)
            XCTAssertGreaterThanOrEqual(swatch.frame.width, 44)
            XCTAssertGreaterThanOrEqual(swatch.frame.height, 44)
            for other in swatches.dropFirst(index + 1) {
                XCTAssertFalse(swatch.frame.intersects(other.frame), "Note colors must have separate tap targets.")
            }
        }
    }

    func testStyleCanBeClosedAndReopenedWithoutLosingChanges() throws {
        let app = launchApp(extraArguments: [
            "-showWidgetHints", "YES",
            "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryL"
        ])
        createNote(in: app)
        XCTAssertTrue(app.staticTexts["Ready for the widget"].waitForExistence(timeout: 10))
        let bodyEditor = app.textViews["note-body-editor"]
        bodyEditor.tap()
        bodyEditor.typeText("Keep this note while changing its appearance.")
        let editedBody = try XCTUnwrap(bodyEditor.value as? String)
        XCTAssertTrue(editedBody.contains("Keep this note while changing its appearance."))
        openStyle(in: app)
        let mint = app.buttons["palette-59c979"]
        XCTAssertTrue(mint.waitForExistence(timeout: 10))
        mint.tap()
        closeStyle(in: app)
        capture(app, "style-editor-after-dismissal", includeHierarchy: true)
        XCTAssertEqual(bodyEditor.value as? String, editedBody)
        XCTAssertGreaterThanOrEqual(bodyEditor.frame.height, 44)
        XCTAssertTrue(bodyEditor.isHittable)
        bodyEditor.tap()
        bodyEditor.typeText(" Still editable after Style.")
        XCTAssertTrue((bodyEditor.value as? String)?.contains("Still editable after Style.") == true)
        capture(app, "style-editor-after-resuming")
        openStyle(in: app)
        XCTAssertEqual(mint.value as? String, "Selected")
        closeStyle(in: app)
        let pin = app.buttons["widget-pin-button"]
        XCTAssertTrue(pin.waitForExistence(timeout: 10))
        pin.tap()
        XCTAssertTrue(app.staticTexts["Shown in widget"].waitForExistence(timeout: 10))
    }

    func testStyleMenusRemainUsableInLandscape() throws {
        let app = launchApp()
        createNote(in: app)
        addTeardownBlock {
            await MainActor.run {
                XCUIDevice.shared.orientation = .portrait
            }
        }
        XCUIDevice.shared.orientation = .landscapeLeft
        openStyle(in: app)
        capture(app, "style-landscape", includeHierarchy: true)
        XCTAssertGreaterThan(app.frame.width, app.frame.height)
        let done = app.buttons["note-style-done-button"]
        XCTAssertGreaterThanOrEqual(done.frame.minY, app.frame.minY)
        XCTAssertLessThanOrEqual(done.frame.maxY, app.frame.maxY)
        XCTAssertTrue(done.isHittable)
        let sizePicker = app.buttons["font-size-picker"]
        for _ in 0..<3 {
            if sizePicker.exists, sizePicker.isHittable, sizePicker.frame.maxY <= app.frame.maxY {
                break
            }
            app.collectionViews.firstMatch.swipeUp()
        }
        XCTAssertTrue(sizePicker.waitForExistence(timeout: 10))
        XCTAssertLessThanOrEqual(sizePicker.frame.maxY, app.frame.maxY)
        XCTAssertTrue(sizePicker.isHittable)
        let originalSize = try XCTUnwrap(sizePicker.value as? String)
        sizePicker.tap()
        for size in ["Small", "Medium", "Large"] {
            XCTAssertTrue(app.buttons[size].waitForExistence(timeout: 5))
        }
        app.buttons[originalSize].tap()
        closeStyle(in: app)
        XCTAssertTrue(app.textViews["note-body-editor"].isHittable)
    }

    func testEditorRemainsUsableAtAccessibilityTextSize() throws {
        let app = launchApp(extraArguments: [
            "-showWidgetHints", "YES",
            "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"
        ])
        createNote(in: app)
        XCTAssertGreaterThan(app.textFields["note-title-field"].frame.height, 44)
        let bodyEditor = app.textViews["note-body-editor"]
        bodyEditor.tap()
        bodyEditor.typeText("Writing with accessibility text.")
        let editedBody = try XCTUnwrap(bodyEditor.value as? String)
        openStyle(in: app)
        XCTAssertTrue(app.buttons["note-style-done-button"].isHittable)
        closeStyle(in: app)
        capture(app, "editor-accessibility-text", includeHierarchy: true)
        XCTAssertEqual(bodyEditor.value as? String, editedBody)
        XCTAssertGreaterThanOrEqual(bodyEditor.frame.height, 44)
        XCTAssertTrue(bodyEditor.isHittable)
        bodyEditor.tap()
        bodyEditor.typeText(" Still editable.")
        XCTAssertTrue((bodyEditor.value as? String)?.contains("Still editable.") == true)
    }

    private func openStyle(in app: XCUIApplication) {
        let button = app.buttons["note-style-button"]
        XCTAssertTrue(button.waitForExistence(timeout: 10))
        button.tap()
        XCTAssertTrue(app.buttons["note-style-done-button"].waitForExistence(timeout: 10))
    }

    private func closeStyle(in app: XCUIApplication) {
        app.buttons["note-style-done-button"].tap()
        XCTAssertTrue(app.buttons["note-style-button"].waitForExistence(timeout: 10))
    }

    func testTrashRestoreAndPermanentDeleteFlow() throws {
        let app = launchApp()
        createNote(in: app)
        renameCurrentNote("Disposable Note", in: app)

        openSecondaryAction("Move to Trash", in: app)
        openSecondaryAction("Show Trash", in: app)
        XCTAssertTrue(noteList(in: app).staticTexts["Disposable Note"].waitForExistence(timeout: 10))
        noteList(in: app).staticTexts["Disposable Note"].tap()

        let restoreButton = app.buttons["restore-note-button"]
        XCTAssertTrue(restoreButton.waitForExistence(timeout: 10))
        restoreButton.tap()
        XCTAssertTrue(noteList(in: app).staticTexts["Disposable Note"].waitForExistence(timeout: 10))

        noteList(in: app).staticTexts["Disposable Note"].tap()
        XCTAssertTrue(app.textFields["note-title-field"].waitForExistence(timeout: 10))
        openSecondaryAction("Move to Trash", in: app)
        openSecondaryAction("Show Trash", in: app)
        noteList(in: app).staticTexts["Disposable Note"].tap()

        let deleteButton = app.buttons["delete-note-button"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 10))
        deleteButton.tap()
        confirmPermanentDelete(in: app)
        XCTAssertTrue(app.staticTexts["Trash is empty"].waitForExistence(timeout: 10))
    }

    private func createNote(in app: XCUIApplication) {
        let newNoteButton = app.buttons["new-note-button"]
        XCTAssertTrue(newNoteButton.waitForExistence(timeout: 10))
        newNoteButton.tap()
        XCTAssertTrue(app.textFields["note-title-field"].waitForExistence(timeout: 10))
    }

    private func renameCurrentNote(_ title: String, in app: XCUIApplication) {
        let titleField = app.textFields["note-title-field"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 10))
        selectAllText(in: titleField, app: app)
        titleField.typeText(title)
        returnToList(in: app)
    }

    /// Selects all text in a field via the system edit menu.
    ///
    /// That menu is system chrome and appears on its own schedule -- later on a
    /// loaded machine. Two of the three call sites tapped it with no wait,
    /// which surfaced as "Failed to tap \"Select All\" MenuItem: No matches
    /// found" rather than as a product failure.
    private func selectAllText(in field: XCUIElement, app: XCUIApplication) {
        field.tap()
        field.press(forDuration: 1.0)
        XCTAssertTrue(
            app.menuItems["Select All"].waitForExistence(timeout: 10),
            "The edit menu never offered Select All."
        )
        app.menuItems["Select All"].tap()
    }

    private func returnToList(in app: XCUIApplication) {
        if app.keyboards.count > 0 {
            // Present is not the same as hittable: under load this failed with
            // kAXErrorCannotComplete scrolling the Return key into view.
            let returnKey = app.keyboards.buttons["Return"]
            if returnKey.waitForExistence(timeout: 5), returnKey.isHittable {
                returnKey.tap()
            }
        }
        // iPad keeps the list on screen in a split-view sidebar, so there is
        // nothing to pop and no BackButton to find.
        guard !isSplitViewLayout(in: app) else { return }
        let backButton = app.stackBackButton
        XCTAssertTrue(backButton.waitForExistence(timeout: 10))
        backButton.tap()
    }

    /// True on the iPad/regular-width layout, where NavigationSplitView shows
    /// the note list in a sidebar alongside the detail pane.
    private func isSplitViewLayout(in app: XCUIApplication) -> Bool {
        app.collectionViews["Sidebar"].exists
    }

    /// The note list itself: a system "Sidebar" collection view on iPad, and
    /// the app's own `note-list` on iPhone. Membership assertions must be
    /// scoped to it. On iPad a note's title also renders in the detail pane,
    /// which makes an app-wide staticTexts query ambiguous, and lets a stale
    /// detail pane defeat a "no longer in the list" assertion.
    private func noteList(in app: XCUIApplication) -> XCUIElement {
        let sidebar = app.collectionViews["Sidebar"]
        return sidebar.exists ? sidebar : app.collectionViews["note-list"]
    }

    /// Confirms the permanent-delete dialog. Both the detail pane and the
    /// dialog carry a "Delete Now" button, and the previous approach picked
    /// the last app-wide match on the assumption that the dialog sorts after
    /// the pane. That does not hold on iPad, where the confirmation is a
    /// popover: the pane's own button was tapped instead, the dialog was never
    /// confirmed, and the note survived.
    private func confirmPermanentDelete(in app: XCUIApplication) {
        let sheet = app.sheets.firstMatch
        let container = sheet.waitForExistence(timeout: 5) ? sheet : app.alerts.firstMatch
        let confirm = container.buttons["Delete Now"]
        XCTAssertTrue(confirm.waitForExistence(timeout: 10), "Delete confirmation dialog never offered Delete Now.")
        confirm.tap()
    }

    private func openSecondaryAction(_ name: String, in app: XCUIApplication) {
        let directButton = app.buttons[name]
        if directButton.waitForExistence(timeout: 2), directButton.isHittable {
            directButton.tap()
            return
        }

        let moreButton = app.buttons["More"]
        XCTAssertTrue(moreButton.waitForExistence(timeout: 10))
        moreButton.tap()
        XCTAssertTrue(directButton.waitForExistence(timeout: 10))
        directButton.tap()
    }

    /// Pops back to the note list on iPhone's compact NavigationStack, where
    /// the pushed editor screen replaces the list in the accessible
    /// hierarchy. A no-op on iPad/Mac's NavigationSplitView, where the
    /// sidebar list (and its search field) is already reachable -- detected
    /// here by checking for the search field rather than branching on
    /// device/size-class directly, so this helper works unmodified on both.
    private func returnToListIfPushed(in app: XCUIApplication) {
        guard !app.searchFields.firstMatch.exists else { return }
        let backButton = app.stackBackButton
        if backButton.waitForExistence(timeout: 2), backButton.isHittable {
            backButton.tap()
        }
    }

    /// Clearing the search field's text does not end its active/focused
    /// search session -- `.searchable()` keeps showing the Cancel/Close
    /// button and keeps the keyboard up until that session is explicitly
    /// dismissed, and while it's active iOS hides the rest of the
    /// navigation bar's toolbar items (New Note, Show Trash, ...) to make
    /// room for it. Confirmed via the accessibility hierarchy dump at a
    /// prior failure here: the toolbar existed but had zero buttons in it
    /// while the search field still reported `Keyboard Focused`.
    private func dismissSearchIfActive(in app: XCUIApplication) {
        let closeButton = app.buttons["Close"]
        if closeButton.waitForExistence(timeout: 2), closeButton.isHittable {
            closeButton.tap()
        }
    }

    /// Taps a text field and waits for the keyboard before returning. Typing
    /// without this races first-responder assignment on a loaded machine, which
    /// surfaces as "Neither element nor any descendant has keyboard focus"
    /// rather than as a real product failure.
    private func focusForTyping(_ field: XCUIElement, in app: XCUIApplication) {
        XCTAssertTrue(field.waitForExistence(timeout: 10))
        field.tap()
        XCTAssertTrue(
            app.keyboards.element.waitForExistence(timeout: 10),
            "Expected the keyboard to appear before typing."
        )
    }

    /// Target the note list so the gesture reaches its search drawer on
    /// iPhone and the sidebar on iPad, rather than another scrollable pane.
    private func revealSearchField(in app: XCUIApplication) -> XCUIElement {
        let field = app.searchFields.firstMatch
        if field.waitForExistence(timeout: 2) { return field }

        let list = noteList(in: app)
        if list.exists {
            let start = list.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.47))
            let end = list.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.85))
            start.press(forDuration: 0.1, thenDragTo: end)
        } else {
            app.swipeDown()
        }
        return field
    }

    // MARK: - Ad hoc QA sweep (manual verification pass, runs on iPhone and iPad)
    //
    // This drives the whole manual QA checklist end to end against a live
    // simulator, capturing a named screenshot at every checkpoint so the
    // run can be verified visually afterward. Screenshots are attached with
    // `.keepAlways` so they land in the .xcresult bundle for extraction.
    //
    // Originally written against iPad's NavigationSplitView, where the
    // sidebar list and the editor detail pane are on screen at the same
    // time. Verified against iPhone too: everything up through editing a
    // note holds as-is, but the list-level checks (pin invariant, search,
    // selecting a different note) need `returnToListIfPushed(in:)` first --
    // iPhone's compact NavigationStack pushes the editor over the list, so
    // the list briefly isn't part of the accessible hierarchy at all. On
    // iPad/Mac that helper is a no-op since the list is already reachable.

    func testQASweep() throws {
        // --- Item 1: fresh onboarding ---
        let app = XCUIApplication()
        app.launchArguments = ["-cheatsheet-ui-testing", "-cheatsheet-reset-onboarding"]
        app.launch()

        let doneButton = app.buttons["onboarding-done-button"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 10), "Onboarding sheet should appear on first launch.")
        XCTAssertTrue(app.staticTexts["Add notes"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Tune the look"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Pin the widget note"].waitForExistence(timeout: 5))
        capture(app, "01-onboarding-sheet")

        doneButton.tap()
        XCTAssertTrue(app.buttons["new-note-button"].waitForExistence(timeout: 10), "Should land on the notes surface after onboarding.")
        capture(app, "02-onboarding-dismissed")
        assertNoPersistenceBanner(app)

        // --- Item 2: relaunch with seeded screenshot demo notes ---
        app.terminate()
        app.launchArguments = ["-cheatsheet-ui-testing", "-cheatsheet-skip-onboarding", "-cheatsheet-seed-screenshot-demo"]
        app.launch()
        XCTAssertTrue(app.buttons["new-note-button"].waitForExistence(timeout: 10))

        let demoTitles = [
            "Git Rescue", "Ship Checklist", "Swift Concurrency", "Docker Cleanup",
            "Vim Motions", "zsh + Homebrew", "Xcode Shortcuts", "HTTP Status Codes"
        ]
        for title in demoTitles {
            app.revealNoteInList(title)
            XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 10), "Missing seeded demo note '\(title)'.")
        }
        app.revealNoteInList("Git Rescue", direction: .towardStart)
        XCTAssertTrue(app.images["Pinned"].waitForExistence(timeout: 10), "Expected exactly one pin indicator (Git Rescue) after seeding.")
        XCTAssertEqual(app.images.matching(identifier: "Pinned").count, 1)
        capture(app, "03-demo-notes-seeded")
        assertNoPersistenceBanner(app)

        // --- Item 3: open a seeded note, inspect raw text content ---
        // NOTE: `.firstMatch` works around a SwiftUI List/NavigationSplitView
        // accessibility quirk on this iOS 27 beta where the auto-selected
        // sidebar row briefly exposes its label as two duplicate StaticText
        // nodes, which makes a plain identifier lookup ambiguous for `.tap()`.
        app.staticTexts["Git Rescue"].firstMatch.tap()
        let titleFieldExisting = app.textFields["note-title-field"]
        XCTAssertTrue(titleFieldExisting.waitForExistence(timeout: 10))
        XCTAssertTrue(app.textViews["note-body-editor"].waitForExistence(timeout: 10))
        capture(app, "04-note-opened-git-rescue")

        // --- Item 4: new note opens straight into editor with default title ---
        let newNoteButton = app.buttons["new-note-button"]
        XCTAssertTrue(newNoteButton.waitForExistence(timeout: 10))
        newNoteButton.tap()
        let titleField = app.textFields["note-title-field"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 10))
        XCTAssertEqual(titleField.value as? String, "New Cheat Sheet")
        capture(app, "05-new-note-default-title")

        // --- Item 5: edit title + body ---
        titleField.tap()
        titleField.press(forDuration: 1.0)
        if app.menuItems["Select All"].waitForExistence(timeout: 3) {
            app.menuItems["Select All"].tap()
        }
        titleField.typeText("QA Sweep Note")
        capture(app, "06-title-edited")

        // Return ends title editing. On iPhone Duo the keyboard and its
        // suggestion bar cover the whole note editor, so it has to go first.
        titleField.typeText("\n")
        let bodyEditor = app.textViews["note-body-editor"]
        XCTAssertTrue(bodyEditor.waitForExistence(timeout: 10))
        bodyEditor.tap()
        bodyEditor.typeText("# QA Heading\n- [ ] Open task line\n- [x] Done task line")
        capture(app, "07-body-edited")

        // --- Item 6: palette picker, 3 distinct swatches ---
        // Deliberately avoids palette-4b88ff (Blue), which is the app's likely
        // default tint, so every tap here produces a visibly different color
        // from the note surface's starting state, not just from each other.
        openStyle(in: app)
        let paletteSamples = ["palette-d99a2b", "palette-e85d75", "palette-8b7cff"]
        for (index, identifier) in paletteSamples.enumerated() {
            let swatch = app.buttons[identifier]
            XCTAssertTrue(swatch.waitForExistence(timeout: 10), "Missing palette swatch \(identifier)")
            swatch.tap()
            XCTAssertEqual(swatch.value as? String, "Selected", "\(identifier) should report Selected after tap.")
            let suffix = ["a", "b", "c"][index]
            capture(app, "08\(suffix)-palette-\(identifier)")
        }

        // --- Item 7: font picker lists all 4 styles, selecting one changes typeface ---
        let fontPicker = app.buttons["font-style-picker"]
        XCTAssertTrue(fontPicker.waitForExistence(timeout: 10))
        fontPicker.tap()
        for style in ["Mono", "System", "Rounded", "Serif"] {
            XCTAssertTrue(app.buttons[style].waitForExistence(timeout: 5), "Font menu missing style \(style)")
        }
        capture(app, "09a-font-menu-open")
        app.buttons["Serif"].tap()
        XCTAssertEqual(fontPicker.value as? String, "Serif")
        capture(app, "09b-font-serif-applied")

        closeStyle(in: app)

        // --- Item 8: pin / unpin ---
        // Matched by identifier alone for the same iPhone Duo reason as the swatches.
        let pinButton = app.buttons["widget-pin-button"]
        XCTAssertTrue(pinButton.waitForExistence(timeout: 10))
        pinButton.tap()
        XCTAssertTrue(app.staticTexts["Shown in widget"].waitForExistence(timeout: 10))
        capture(app, "10a-note-pinned")
        returnToListIfPushed(in: app)
        XCTAssertEqual(app.images.matching(identifier: "Pinned").count, 1, "Only one note should be pinned after re-pinning.")
        capture(app, "10b-list-single-pin")

        // --- Item 9: search ---
        let searchField = revealSearchField(in: app)
        focusForTyping(searchField, in: app)
        searchField.typeText("docker")
        XCTAssertTrue(app.staticTexts["Docker Cleanup"].waitForExistence(timeout: 10))
        XCTAssertFalse(app.staticTexts["Vim Motions"].exists)
        capture(app, "11a-search-filtered-docker")

        if let value = searchField.value as? String, !value.isEmpty {
            // The screenshot above is a synchronous round trip long enough for
            // .searchable to drop first responder, so re-focus before clearing.
            focusForTyping(searchField, in: app)
            searchField.typeText(String(repeating: "\u{8}", count: value.count))
        }
        XCTAssertTrue(app.staticTexts["Vim Motions"].waitForExistence(timeout: 10), "Full list should return after clearing search.")
        capture(app, "11b-search-cleared")
        dismissSearchIfActive(in: app)

        // --- Item 10: trash flow (restore) ---
        app.staticTexts["Swift Concurrency"].firstMatch.tap()
        XCTAssertTrue(app.textFields["note-title-field"].waitForExistence(timeout: 10))
        tapToolbarAction(identifier: "move-to-trash-button", label: "Move to Trash", in: app)
        tapToolbarAction(identifier: "toggle-trash-button", label: "Show Trash", in: app)
        XCTAssertTrue(app.staticTexts["Swift Concurrency"].waitForExistence(timeout: 10))
        capture(app, "12a-trash-list")
        app.staticTexts["Swift Concurrency"].firstMatch.tap()
        XCTAssertTrue(app.buttons["restore-note-button"].waitForExistence(timeout: 10))
        capture(app, "12b-trash-detail-countdown")

        // Restoring already navigates back to the active list on its own
        // (TrashNoteView's restoreAction calls showNotes()), so no extra
        // toggle-trash tap is needed -- or findable, since by the time it
        // would run the toolbar button has already flipped back to "Show Trash".
        let restoreButton = app.buttons["restore-note-button"]
        restoreButton.tap()
        XCTAssertTrue(app.staticTexts["Swift Concurrency"].waitForExistence(timeout: 10), "Restored note should be back in the active list.")
        capture(app, "12c-note-restored")
        assertNoPersistenceBanner(app)

        // --- Item 10 continued: trash flow (permanent delete, different note) ---
        app.staticTexts["Vim Motions"].firstMatch.tap()
        XCTAssertTrue(app.textFields["note-title-field"].waitForExistence(timeout: 10))
        tapToolbarAction(identifier: "move-to-trash-button", label: "Move to Trash", in: app)
        tapToolbarAction(identifier: "toggle-trash-button", label: "Show Trash", in: app)
        XCTAssertTrue(app.staticTexts["Vim Motions"].waitForExistence(timeout: 10))
        app.staticTexts["Vim Motions"].firstMatch.tap()

        let deleteButton = app.buttons["delete-note-button"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 10))
        deleteButton.tap()
        capture(app, "13a-delete-confirmation-dialog")

        confirmPermanentDelete(in: app)
        XCTAssertFalse(noteList(in: app).staticTexts["Vim Motions"].waitForExistence(timeout: 5), "Permanently deleted note should be gone from Trash.")
        capture(app, "13b-note-deleted-from-trash")
        assertNoPersistenceBanner(app)
    }

    private func capture(_ app: XCUIApplication, _ name: String, includeHierarchy: Bool = false) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
        if includeHierarchy {
            let hierarchy = XCTAttachment(string: app.debugDescription)
            hierarchy.name = name + "-hierarchy"
            hierarchy.lifetime = .keepAlways
            add(hierarchy)
        }
    }

    private func assertNoPersistenceBanner(_ app: XCUIApplication) {
        XCTAssertFalse(app.otherElements["persistence-status-banner"].exists, "The storage failure banner must not appear during a healthy run.")
    }

    /// Taps a `.secondaryAction` toolbar item by its accessibility identifier
    /// when it's directly visible, falling back to the "More" overflow menu
    /// when it collapses there (which iPad's narrower detail-pane toolbar
    /// does routinely). Once collapsed into "More", iOS renders the item as a
    /// plain menu row and its SwiftUI `accessibilityIdentifier` no longer
    /// resolves it -- only its visible label does -- so the fallback must
    /// look up `label`, not `identifier`.
    private func tapToolbarAction(identifier: String, label: String, in app: XCUIApplication) {
        let direct = app.buttons[identifier]
        if direct.waitForExistence(timeout: 2), direct.isHittable {
            direct.tap()
            return
        }
        let moreButton = app.buttons["More"]
        if moreButton.waitForExistence(timeout: 2) {
            moreButton.tap()
        }
        let menuItem = app.buttons[label]
        XCTAssertTrue(menuItem.waitForExistence(timeout: 10), "Could not find toolbar action '\(label)' (\(identifier)), even behind More.")
        menuItem.tap()
    }
}

extension XCUIApplication {
    enum NoteListScrollDirection {
        case towardStart
        case towardEnd
    }

    func revealNoteInList(_ title: String, direction: NoteListScrollDirection = .towardEnd) {
        let sidebar = collectionViews["Sidebar"]
        let list = sidebar.exists ? sidebar : collectionViews["note-list"]
        guard list.waitForExistence(timeout: 5) else {
            XCTFail("Expected the note list before scrolling to '\(title)'.")
            return
        }
        let row = list.staticTexts[title].firstMatch
        // SwiftUI's lazy list omits offscreen notes from the SE accessibility tree.
        for _ in 0..<5 {
            if row.exists, row.isHittable, list.frame.contains(row.frame) {
                return
            }
            switch direction {
            case .towardStart:
                list.swipeDown()
            case .towardEnd:
                list.swipeUp()
            }
        }
        XCTAssertTrue(
            row.exists && row.isHittable && list.frame.contains(row.frame),
            "Expected note '\(title)' to be visible after at most five list swipes."
        )
    }

    /// The compact NavigationStack's system back button, matched by its system
    /// identifier: iPhone Duo puts it in a side toolbar, so there is no
    /// navigation bar to search.
    var stackBackButton: XCUIElement { buttons["BackButton"].firstMatch }
}
