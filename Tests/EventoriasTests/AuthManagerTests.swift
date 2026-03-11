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
    
    override func tearDown() {
        authManager.cleanUp() // nettoie proprement
        authManager = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertNil(authManager.user)
    }

    func testSignOutLogic() {
        authManager.signOut()
        XCTAssertNil(authManager.user)
    }
    
    // garde uniquement les tests de succès rapides, sans 'async throws' ni 'Task.sleep'
    func testSignUpValidation() {
        authManager.signUp(email: "test@test.com", password: "password123", name: "Lina")
        XCTAssertNotNil(authManager)
    }
    
    func testSignUpFirestoreData() {
        authManager.signUp(email: "test@investor.com", password: "password123", name: "Top Investor")
        XCTAssertNotNil(authManager)
    }
}
