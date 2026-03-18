import Foundation
import FirebaseFirestore

// Identifiable pour les listes swfitUI et Codable pour Firestore
struct Event: Identifiable, Codable {
    @DocumentID var id: String?      // Identifiant unique généré par Firestore
    var name: String                 // Titre de l'événement
    var date: Date                   // Date et heure de l'événement
    var imageUrl: String             // URL de l'image d'illustration
    var description: String = ""     // Description détaillée
    var location: String?            // Adresse ou lieu
}
