import XCTest

final class SporOkonomiUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        configureForIsolatedFileStore(app, skipOnboarding: true)
    }

    override func tearDownWithError() throws {
        app = nil
    }

    private func launchApp() {
        app.launch()
        continuePastAuthChoiceIfNeeded(app)
        XCTAssertTrue(app.tabBars.firstMatch.waitForExistence(timeout: 5))
    }

    private func configureForIsolatedFileStore(_ targetApp: XCUIApplication, skipOnboarding: Bool) {
        targetApp.launchArguments += ["UITEST_FILE_STORE", "UITEST_DISABLE_FACEID"]
        if skipOnboarding {
            targetApp.launchArguments += ["UITEST_SKIP_ONBOARDING"]
        }
        targetApp.launchEnvironment["UITEST_STORE_ID"] = UUID().uuidString
    }

    private func continuePastAuthChoiceIfNeeded(_ targetApp: XCUIApplication) {
        let continueButton = targetApp.buttons["Fortsett uten konto"]
        if continueButton.waitForExistence(timeout: 8) {
            continueButton.tap()
        }
    }

    private func waitForOnboardingIntro(_ targetApp: XCUIApplication) {
        waitForOnboardingStep("intro", in: targetApp)
    }

    private func waitForOnboardingStep(_ step: String, in targetApp: XCUIApplication) {
        let stepElement = targetApp.descendants(matching: .any)["onboarding.step.\(step)"]
        if stepElement.waitForExistence(timeout: 5) {
            return
        }

        continuePastAuthChoiceIfNeeded(targetApp)
        XCTAssertTrue(stepElement.waitForExistence(timeout: 10))
    }

    private func tapButton(_ identifier: String, in targetApp: XCUIApplication) {
        let button = targetApp.buttons[identifier]
        XCTAssertTrue(button.waitForExistence(timeout: 5))
        button.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }

    private func openTab(_ title: String) {
        let tabButton = app.tabBars.buttons[title]
        XCTAssertTrue(tabButton.waitForExistence(timeout: 5))
        tabButton.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }

    @MainActor
    func testMainTabsAreVisible() throws {
        launchApp()

        XCTAssertTrue(app.tabBars.buttons["Budsjett"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.tabBars.buttons["Investeringer"].exists)
        XCTAssertTrue(app.tabBars.buttons["Oversikt"].exists)
        XCTAssertFalse(app.tabBars.buttons["Tips"].exists)
        XCTAssertTrue(app.tabBars.buttons["Innstillinger"].exists)
    }

    @MainActor
    func testOnboardingShowsOnFreshLaunchWithoutSkipFlag() throws {
        let onboardingApp = XCUIApplication()
        configureForIsolatedFileStore(onboardingApp, skipOnboarding: false)
        onboardingApp.launch()

        waitForOnboardingIntro(onboardingApp)
        XCTAssertTrue(onboardingApp.buttons["onboarding.primary_cta"].exists)
        XCTAssertTrue(onboardingApp.buttons["onboarding.secondary_cta"].exists)
    }

    @MainActor
    func testOnboardingFlowCanCompleteUsingCurrentUI() throws {
        let onboardingApp = XCUIApplication()
        configureForIsolatedFileStore(onboardingApp, skipOnboarding: false)
        onboardingApp.launch()

        waitForOnboardingIntro(onboardingApp)
        tapButton("onboarding.primary_cta", in: onboardingApp)

        waitForOnboardingStep("goals", in: onboardingApp)
        tapButton("onboarding.option.spare_mer", in: onboardingApp)
        tapButton("onboarding.primary_cta", in: onboardingApp)

        waitForOnboardingStep("income", in: onboardingApp)
        let incomeField = onboardingApp.textFields["onboarding.step.income"]
        XCTAssertTrue(incomeField.waitForExistence(timeout: 5))
        incomeField.tap()
        incomeField.typeText("12000")
        tapButton("onboarding.primary_cta", in: onboardingApp)

        waitForOnboardingStep("fixed_costs", in: onboardingApp)
        tapButton("onboarding.option.husleie", in: onboardingApp)
        tapButton("onboarding.primary_cta", in: onboardingApp)

        XCTAssertTrue(onboardingApp.tabBars.firstMatch.waitForExistence(timeout: 5))
        XCTAssertTrue(onboardingApp.tabBars.buttons["Oversikt"].exists)
    }

    @MainActor
    func testOnboardingCanCompleteWithoutIncome() throws {
        let onboardingApp = XCUIApplication()
        configureForIsolatedFileStore(onboardingApp, skipOnboarding: false)
        onboardingApp.launch()

        waitForOnboardingIntro(onboardingApp)
        tapButton("onboarding.primary_cta", in: onboardingApp)

        waitForOnboardingStep("goals", in: onboardingApp)
        tapButton("onboarding.secondary_cta", in: onboardingApp)

        waitForOnboardingStep("income", in: onboardingApp)
        XCTAssertTrue(onboardingApp.buttons["onboarding.secondary_cta"].exists)
        tapButton("onboarding.primary_cta", in: onboardingApp)

        waitForOnboardingStep("fixed_costs", in: onboardingApp)
        tapButton("onboarding.primary_cta", in: onboardingApp)

        XCTAssertTrue(onboardingApp.tabBars.firstMatch.waitForExistence(timeout: 5))
        XCTAssertTrue(onboardingApp.tabBars.buttons["Oversikt"].exists)
    }

    @MainActor
    func testSettingsShowsDataAndDeleteConfirmation() throws {
        launchApp()

        openTab("Innstillinger")

        XCTAssertTrue(app.staticTexts["Data og personvern"].waitForExistence(timeout: 5))
        app.staticTexts["Data og personvern"].tap()
        XCTAssertTrue(app.navigationBars["Data og personvern"].waitForExistence(timeout: 5))

        let deleteButton = app.buttons["Slett lokale data"]
        if !deleteButton.exists {
            app.swipeUp()
        }
        XCTAssertTrue(deleteButton.exists)
    }

    @MainActor
    func testBudgetShowsEmptyStateOnFreshStore() throws {
        launchApp()
        openTab("Budsjett")

        XCTAssertTrue(app.navigationBars["Budsjett"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Ingen grenser satt ennå"].exists)
        XCTAssertTrue(app.staticTexts["Legg til første transaksjon"].exists)
        XCTAssertTrue(app.staticTexts["Legg til inntekt eller utgift først. Sett grenser senere hvis du vil følge budsjettet tettere."].exists)
    }

    @MainActor
    func testInvestmentsShowsEmptyStateOnFreshStore() throws {
        launchApp()
        openTab("Investeringer")

        XCTAssertTrue(app.navigationBars["Investeringer"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Kom i gang med investeringer"].exists)
        XCTAssertTrue(app.buttons["Kom i gang"].exists)
    }

    @MainActor
    func testOverviewShowsEmptyStatePromptsOnFreshStore() throws {
        launchApp()
        openTab("Oversikt")

        XCTAssertTrue(app.navigationBars["Oversikt"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Ingen registreringer ennå"].exists)
        XCTAssertTrue(app.staticTexts["Legg til en inntekt eller utgift for å få en enkel oversikt over denne måneden."].exists)
        XCTAssertTrue(app.buttons["Legg til første inntekt"].exists)
    }
}
