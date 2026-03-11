import SwiftUI
import PhotosUI
import FirebaseFirestore
import MapKit
import Combine

class AddEventViewModel: ObservableObject {
    @Published var name = ""
    @Published var description = ""
    @Published var eventDate = Date()
    @Published var location = ""
    @Published var imageUrl = "https://picsum.photos/400"
    @Published var isLoading = false
    
    // Gestion de l'image
    @Published var selectedImage: UIImage?
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                loadTransferable(from: imageSelection)
            }
        }
    }
    
    private var db = Firestore.firestore()

    // Charge l'image sélectionnée depuis la galerie
    private func loadTransferable(from imageSelection: PhotosPickerItem) {
        imageSelection.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data?):
                    self.selectedImage = UIImage(data: data)
                case .success(nil):
                    print("⚠️ Aucune donnée d'image trouvée")
                case .failure(let error):
                    print("❌ Erreur de chargement : \(error.localizedDescription)")
                }
            }
        }
    }

    // Enrigistre l'evenement
    func saveEvent(completion: @escaping (Bool) -> Void) {
        guard !name.isEmpty else {
                completion(false)
            
                return
            }
        self.isLoading = true
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = location
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] _, error in
            if let error = error {
                print("🌍 Erreur MapKit Search: \(error.localizedDescription)")
            }
            self?.createFirestoreDocument(completion: completion)
        }
    }

    private func createFirestoreDocument(completion: @escaping (Bool) -> Void) {
        let newEvent = Event(
            name: name,
            date: eventDate,
            imageUrl: imageUrl,
            description: description,
            location: location
        )
        
        do {
            _ = try db.collection("events").addDocument(from: newEvent)
            self.isLoading = false
            completion(true)
        } catch {
            print("❌ Erreur Firestore : \(error.localizedDescription)")
            self.isLoading = false
            completion(false)
        }
    }
}
