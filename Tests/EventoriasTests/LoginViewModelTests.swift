import XCTest
@testable import Eventorias

@MainActor
final class LoginViewModelTests: XCTestCase {
    
    // rend le test lui-même asynchrone
    func testLoginFailureLogic() async throws {
        let viewModel = LoginViewModel()
        
        await MainActor.run {
            viewModel.email = "test@invalid.com"
            viewModel.password = "1"
            viewModel.login()
        }
        
        // Au lieu de bloquer avec 'wait', on suspend le test
        try await Task.sleep(for: .seconds(2))
        
        await MainActor.run {
            XCTAssertTrue(viewModel.showError)
            XCTAssertFalse(viewModel.errorMessage.isEmpty)
        }
    }
    
    @MainActor
    func testLoginWithWrongPasswordTriggersErrorMessage() async throws {
        let viewModel = LoginViewModel()
        viewModel.email = "test@test.com"
        viewModel.password = "mauvais_pass" // Force une erreur Firebase
        
        viewModel.login()
        
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        
        // Couvre self.errorMessage = error.localizedDescription
        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.errorMessage.isEmpty)
    }
    
    @MainActor
    func testLoginErrorPath() async throws {
        let viewModel = LoginViewModel()
        // Utilise un email unique pour éviter les conflits de cache Firebase
        viewModel.email = "error-test-\(UUID().uuidString)@test.com"
        viewModel.password = "mauvais_pass"
        
        viewModel.login()
        
        // Attend que isLoading repasse à false
        let timeout = Date().addingTimeInterval(10) // Timeout de 10s par sécurité
        while viewModel.isLoading && Date() < timeout {
            await Task.yield() // Laisse le fil principal mettre à jour le ViewModel
        }
        
        // Vérifications finales
        XCTAssertTrue(viewModel.showError, "Le ViewModel devrait afficher une erreur après un mauvais mot de passe")
        XCTAssertFalse(viewModel.errorMessage.isEmpty, "Le message d'erreur ne doit pas être vide")
    }
    
    @MainActor
    func testSignUpLogic() async throws {
        let viewModel = LoginViewModel()
        
        // Cas 1 : Champs vides (Couvre le guard et l'erreur)
        viewModel.email = ""
        viewModel.signUp(name: "")
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Please fill all fields")
        
        // Cas 2 : Inscription valide (Couvre l'appel à AuthManager)
        viewModel.email = "newuser@test.com"
        viewModel.password = "password123"
        viewModel.signUp(name: "New User")
        
        XCTAssertTrue(viewModel.isLoading)
        
        // Attente du délai de sécurité de 2s présent dans ton code
        try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
        XCTAssertFalse(viewModel.isLoading)
    }
}

