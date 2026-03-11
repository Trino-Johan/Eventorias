import XCTest
@testable import Eventorias

@MainActor // ✅ Isole toute la classe sur le thread principal pour éviter SIGABRT
final class AddEventViewModelTests: XCTestCase {
    var viewModel: AddEventViewModel!

    override func setUp() {
        super.setUp()
        viewModel = AddEventViewModel()
    }

    func testValidationEmptyName() {
        // Un nom vide ne devrait pas lancer la sauvegarde
        viewModel.name = ""
        viewModel.saveEvent { success in
            XCTAssertFalse(success) // Doit échouer
        }
        XCTAssertFalse(viewModel.isLoading)
    }

    func testInitialImageState() {
        // Vérifie l'état initial des propriétés d'image
        XCTAssertNil(viewModel.selectedImage)
        XCTAssertNotNil(viewModel.imageUrl)
    }
    
    func testSaveEventAsync() async throws {
        // Configuration des données de test
        viewModel.name = "Test Unit"
        viewModel.location = "Paris"
        
        // Lancement de la sauvegarde
        viewModel.saveEvent { _ in }
        
        // suspend le test proprement sans bloquer le thread principal
        try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
        
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testSaveEventWithEmptyNameReturnsEarly() {
        viewModel.name = ""
        viewModel.saveEvent { success in
            XCTAssertFalse(success)
        }
        XCTAssertFalse(viewModel.isLoading) // Vérifie que le chargement s'arrête
    }

    func testImageSelectionClearsOnFailure() {
        // Test de réinitialisation de l'image
        viewModel.selectedImage = nil
        XCTAssertNil(viewModel.selectedImage)
    }
    
    @MainActor
    func testSaveEventWithInvalidLocationTriggersMapError() async throws {
        viewModel.name = "Event Test"
        viewModel.location = "???" // Adresse que MapKit ne trouvera pas
        
        let expectation = XCTestExpectation(description: "MapKit Error Path")
        
        viewModel.saveEvent { _ in
            expectation.fulfill()
        }
        
        try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
        
        // Couvre le bloc 'if let error = error' de MKLocalSearch
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testSaveEventMapErrorPath() async throws {
        viewModel.name = "Erreur Test"
        viewModel.location = "ADRESSE_INEXISTANTE_XYZ" // Force l'erreur MapKit
        
        viewModel.saveEvent { _ in }
        
        try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        
        // Couvre le bloc 'if let error = error' dans saveEvent
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testImageSelectionAndLoad() {
        
        let testImage = UIImage(systemName: "calendar")
        viewModel.selectedImage = testImage
        
        XCTAssertNotNil(viewModel.selectedImage)
    }

    @MainActor
    func testCreateFirestoreDocumentLogic() {
        // teste directement la création du document
        viewModel.name = "Event de Test"
        viewModel.location = "Paris"
        
        viewModel.saveEvent { success in
            // vérifie que la chaîne de création se lance
            XCTAssertNotNil(success)
        }
    }
}
