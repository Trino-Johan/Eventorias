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
    
    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    private var listener: ListenerRegistration?
    
    init() {
        // Recherche : attend 0.5s
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.fetchEvents(with: text, sortedBy: self?.sortOption ?? .date)
            }
            .store(in: &cancellables)
            
        // Tri : réagit au changement
        $sortOption
            .sink { [weak self] newSort in
                self?.fetchEvents(with: self?.searchText ?? "", sortedBy: newSort)
            }
            .store(in: &cancellables)
    }
    
    // Ajout d'un paramètre 'sortedBy' pour être sûr d'utiliser la nouvelle valeur
    func fetchEvents(with filter: String, sortedBy option: SortOption) {
        self.isLoading = true
        listener?.remove()
        
        var query: Query = db.collection("events")
        
        // Filtrage serveur
        if !filter.isEmpty {
            query = query.whereField("name", isGreaterThanOrEqualTo: filter)
                         .whereField("name", isLessThanOrEqualTo: filter + "\u{f8ff}")
        }
        
        // Tri serveur
        let orderField = (option == .date) ? "date" : "name"
        query = query.order(by: orderField, descending: option == .date)
        
        listener = query.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            self.isLoading = false
            
            if let error = error {
                print("❌ Erreur Firestore : \(error.localizedDescription)")
                return
            }
            
            self.events = snapshot?.documents.compactMap { try? $0.data(as: Event.self) } ?? []
        }
    }
}
