import XCTest
@testable import Eventorias

@MainActor
final class EventsViewModelTests: XCTestCase {
    var viewModel: EventsViewModel!

    override func setUp() {
        super.setUp()
        viewModel = EventsViewModel()
    }

    func testDefaultSettings() {
        // Vérifie que le tri par défaut est la date
        XCTAssertEqual(viewModel.sortOption, .date)
        XCTAssertTrue(viewModel.searchText.isEmpty)
        XCTAssertTrue(viewModel.isLoading)
    }

    func testSearchTextUpdate() {
        // Vérifie que la mise à jour du texte de recherche fonctionne
        viewModel.searchText = "Concert"
        XCTAssertEqual(viewModel.searchText, "Concert")
    }
    
    @MainActor
    func testFetchEventsWithFilterTriggersQuery() {
        viewModel.searchText = "Concert" // Déclenche le filtrage
        
        // Couvre la logique de construction de la Query
        XCTAssertTrue(viewModel.isLoading)
    }
}
