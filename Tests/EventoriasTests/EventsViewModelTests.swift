import XCTest
import Combine
@testable import Eventorias

@MainActor
final class EventsViewModelTests: XCTestCase {
    var viewModel: EventsViewModel!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        viewModel = EventsViewModel()
        cancellables = []
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.sortOption, .date)
        XCTAssertTrue(viewModel.searchText.isEmpty)
    }

    func testSearchDebounceTriggersLoading() async throws {
        // 1. crée une attente
        let expectation = expectation(description: "isLoading doit passer à true")
        
        // 2. écoute le changement de isLoading
        viewModel.$isLoading
            .dropFirst() // On ignore l'état initial (false)
            .filter { $0 == true } // On ne veut que le moment où il devient true
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
        
        // 3. déclenche la recherche
        viewModel.searchText = "Concert"
        
        // 4. attend que l'événement se produise
        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func testSortOptionChange() async throws {
        let expectation = expectation(description: "Le tri doit déclencher isLoading")
        
        viewModel.$isLoading
            .dropFirst()
            .filter { $0 == true }
            .sink { _ in expectation.fulfill() }
            .store(in: &cancellables)
        
        // On change le tri
        viewModel.sortOption = .name
        
        await fulfillment(of: [expectation], timeout: 2.0)
    }
}
