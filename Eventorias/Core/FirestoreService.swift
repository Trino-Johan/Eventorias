import Foundation
import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}

    // --- Événements ---
    
    // Écoute en temps réel (utilisé par EventsViewModel)
    func subscribeToEvents(filter: String, sort: SortOption, completion: @escaping (Result<[Event], Error>) -> Void) -> ListenerRegistration {
        var query: Query = db.collection("events")
        
        if !filter.isEmpty {
            query = query.whereField("name", isGreaterThanOrEqualTo: filter)
                         .whereField("name", isLessThanOrEqualTo: filter + "\u{f8ff}")
        }
        
        let orderField = (sort == .date) ? "date" : "name"
        query = query.order(by: orderField, descending: sort == .date)
        
        return query.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let events = snapshot?.documents.compactMap { try? $0.data(as: Event.self) } ?? []
            completion(.success(events))
        }
    }

    func addEvent(_ event: Event) async throws {
        try db.collection("events").addDocument(from: event)
    }

    // --- Profil Utilisateur ---

    func createUserProfile(_ profile: UserProfile) async throws {
        try db.collection("users").document(profile.id ?? "").setData(from: profile)
    }

    func fetchUserProfile(userId: String) async throws -> UserProfile? {
        let snapshot = try await db.collection("users").document(userId).getDocument()
        return try snapshot.data(as: UserProfile.self)
    }
}
