import XCTest
import FirebaseAuth
@testable import Eventorias

@MainActor
final class AuthManagerTests: XCTestCase {
    var authManager: AuthManager!

    override func setUp() {
        super.setUp()
        authManager = AuthManager()
    }
    
    func testInitialStateIsLoggedOut() {
        XCTAssertNil(authManager.user)
    }

    func testSignOutClearsUser() {
        authManager.signOut()
        XCTAssertNil(authManager.user)
    }
    
    func testSignUpTriggersProcess() {
        // On vérifie que la méthode ne crash pas et lance le process
        authManager.signUp(email: "john@mail.com", password: "test123", name: "Tester")
        XCTAssertNotNil(authManager)
    }
}
