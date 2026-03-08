import FirebaseAuth
import Combine


class AuthManager: ObservableObject {
    // publie l'utilisateur dès qu'il change
    @Published var user: FirebaseAuth.User?
    
    init() {
        // Ecoute Firebase en temps réel
        Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }
}
