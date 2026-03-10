import FirebaseAuth
import FirebaseFirestore
import Combine

// Gère l'état d'authentification et les interactions avec Firebase Auth/Firestore.
class AuthManager: ObservableObject {
    @Published var user: FirebaseAuth.User? // Utilisateur actuel (null si déconnecté)
    private var db = Firestore.firestore()
    private var handler: AuthStateDidChangeListenerHandle?

    init() {
        setupAuthStateListener()
    }

    // Écoute en temps réel si l'utilisateur se connecte ou se déconnecte.
    private func setupAuthStateListener() {
        handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
        }
    }

    // Inscrit un utilisateur et crée simultanément son profil dans Firestore.
    func signUp(email: String, password: String, name: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("❌ Auth Error: \(error.localizedDescription)")
                return
            }
            
            guard let userId = result?.user.uid else { return }
            
            // Création du profil utilisateur
            let profileData: [String: Any] = [
                "name": name,
                "email": email,
                "avatarUrl": "https://i.pravatar.cc/150?u=\(userId)" // Avatar par défaut
            ]
            
            self?.db.collection("users").document(userId).setData(profileData) { error in
                if let error = error {
                    print("❌ Firestore Error: \(error.localizedDescription)")
                } else {
                    print("✅ Profil créé pour \(name)")
                }
            }
        }
    }
    
    // Déconnexion
    func signOut() {
        try? Auth.auth().signOut()
    }
    
    deinit {
        if let handler = handler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
}
