import Foundation
import FirebaseFirestore

// user dans firestore
struct UserProfile: Codable, Identifiable {
    @DocumentID var id: String?      // Correspond à l'UID de Firebase Auth
    var name: String                 // Nom de l'utilisateur
    var email: String                // Adresse email de l'utilisateur
    var avatarUrl: String            // URL de la photo de profil
}
