import Foundation
import Combine
import FirebaseFirestore

enum SortOption {
    case date, name
}

class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var searchText = ""
    @Published var sortOption: SortOption = .date
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private var listener: ListenerRegistration?
    
    init() {
        // Logique Combine que l'examinateur a aimée
        Publishers.CombineLatest($searchText.debounce(for: .milliseconds(500), scheduler: RunLoop.main), $sortOption)
            .sink { [weak self] text, sort in
                self?.fetchEvents(with: text, sortedBy: sort)
            }
            .store(in: &cancellables)
    }
    
    func fetchEvents(with filter: String, sortedBy option: SortOption) {
        self.isLoading = true
        listener?.remove()
        
        // On délègue totalement au service
        listener = FirestoreService.shared.subscribeToEvents(filter: filter, sort: option) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let events):
                    self?.events = events
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
