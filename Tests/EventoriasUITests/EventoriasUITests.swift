import XCTest

final class EventoriasUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    func testProfileSettings() {
        let profileTab = app.tabBars.buttons["Profile"]
        
        // --- 1. CONNEXION SI BESOIN ---
        if !profileTab.waitForExistence(timeout: 5) {
            let startLogin = app.buttons["Sign in with email"]
            if startLogin.exists {
                startLogin.tap()
            }
            
            let emailField = app.textFields["Email"]
            XCTAssertTrue(emailField.waitForExistence(timeout: 5))
            emailField.tap()
            emailField.typeText("123@gmail.com")
            
            let passwordField = app.secureTextFields["Password"]
            passwordField.tap()
            passwordField.typeText("test123")
            
            // cache le clavier pour être sûr que le bouton Login est visible
            if app.keyboards.count > 0 {
                app.typeText("\n")
            }

            app.buttons["Login"].tap()
        }

        // --- 2. ATTENTE ET DIAGNOSTIC ---
        let profileAppeared = profileTab.waitForExistence(timeout: 15)
        
        if !profileAppeared {
            let errorAlert = app.alerts["Auth Error"]
            if errorAlert.exists {
                let message = errorAlert.staticTexts.element(boundBy: 1).label
                XCTFail("❌ ÉCHEC AUTHENTIFICATION : \(message)")
            } else {
                XCTFail("❌ TIMEOUT : L'onglet n'est pas apparu et aucune alerte n'a été trouvée. Vérifie ta console Firebase.")
            }
        } else {
            profileTab.tap()
            XCTAssertTrue(app.staticTexts["User profile"].exists)
        }
    }

    func testSignUpModeToggle() {
        // force la déconnexion pour tester le toggle de login
        let profileTab = app.tabBars.buttons["Profile"]
        if profileTab.waitForExistence(timeout: 5) {
            profileTab.tap()
            app.buttons["Sign Out"].tap()
        }

        let startButton = app.buttons["Sign in with email"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 5))
        startButton.tap()
        
        let toggleSignUp = app.buttons["Don't have an account? Sign Up"]
        XCTAssertTrue(toggleSignUp.waitForExistence(timeout: 5))
        toggleSignUp.tap()
        
        let fullNameField = app.textFields["Full Name"]
        XCTAssertTrue(fullNameField.waitForExistence(timeout: 5), "Le champ Full Name devrait apparaître en mode Sign Up")
        
        app.buttons["Already have an account? Login"].tap()
        XCTAssertFalse(fullNameField.exists)
    }
}
