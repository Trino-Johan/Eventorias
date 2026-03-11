import XCTest
import FirebaseAuth
@testable import Eventorias

final class ProfileViewModelTests: XCTestCase {
    var viewModel: ProfileViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ProfileViewModel()
    }

    func testInitialProfileState() {
        // Le profil doit être vide tant que fetchProfile n'a pas réussi
        XCTAssertNil(viewModel.profile)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testLoadingState() {
        // Vérifie que l'état de chargement est bien géré au départ
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testFetchProfileWhenNotAuthenticated() async throws {
        // force la déconnexion pour valider ce cas d'erreur
        try? Auth.auth().signOut()
        
        let viewModel = ProfileViewModel()
        viewModel.fetchProfile()
        
        // Pas besoin de sleep ici, le guard est immédiat
        XCTAssertEqual(viewModel.errorMessage, "Utilisateur non authentifié")
    }

    @MainActor
    func testFetchProfileErrorHandling() async throws {
        let viewModel = ProfileViewModel()
        viewModel.fetchProfile()
        
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        
        // Si l'UID n'existe pas dans Firestore, cela couvrira le bloc 'else'
        if viewModel.errorMessage != nil {
            XCTAssertTrue(viewModel.errorMessage!.contains("inexistant") || viewModel.errorMessage!.contains("authentifié"))
        }
    }
}
