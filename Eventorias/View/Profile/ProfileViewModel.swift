import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

final class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private var db = Firestore.firestore()

    func fetchProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.errorMessage = "Utilisateur non authentifié"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Ecoute le document utilisateur
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                if let document = snapshot, document.exists {
                    do {
                        self?.profile = try document.data(as: UserProfile.self)
                    } catch {
                        self?.errorMessage = "Erreur de décodage du profil"
                    }
                } else {
                    self?.errorMessage = "Profil inexistant dans Firestore"
                }
            }
        }
    }
}
