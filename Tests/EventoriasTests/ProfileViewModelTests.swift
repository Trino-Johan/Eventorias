import XCTest
import FirebaseAuth
@testable import Eventorias

final class ProfileViewModelTests: XCTestCase {
    var viewModel: ProfileViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ProfileViewModel()
    }

    @MainActor
    func testFetchProfileWithoutAuth() {
        // On s'assure d'être déconnecté
        try? Auth.auth().signOut()
        
        viewModel.fetchProfile()
        
        XCTAssertEqual(viewModel.errorMessage, "Utilisateur non authentifié")
        XCTAssertFalse(viewModel.isLoading)
    }
}
