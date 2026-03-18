import XCTest
@testable import Eventorias

@MainActor
final class AddEventViewModelTests: XCTestCase {
    var viewModel: AddEventViewModel!

    override func setUp() {
        super.setUp()
        viewModel = AddEventViewModel()
    }

    func testValidationEmptyNameFails() {
        viewModel.name = ""
        viewModel.saveEvent { success in
            XCTAssertFalse(success)
        }
        XCTAssertFalse(viewModel.isLoading)
    }

    func testSaveEventFlow() async throws {
        viewModel.name = "Unit Test Event"
        viewModel.location = "Paris"
        
        let expectation = XCTestExpectation(description: "Attente de sauvegarde")
        
        viewModel.saveEvent { _ in
            expectation.fulfill()
        }
        
        // attend que la closure soit appelée
        await fulfillment(of: [expectation], timeout: 5.0)

        XCTAssertFalse(viewModel.isLoading, "Le chargement doit être terminé ici")
    }
}
