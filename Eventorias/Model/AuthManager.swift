import FirebaseAuth
import Combine

@MainActor
class AuthManager: ObservableObject {
    @Published var user: FirebaseAuth.User?
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in

            Task { @MainActor in
                self?.user = user
            }
        }
    }
    
    func cleanUp() {
        if let handler = handler {
            Auth.auth().removeStateDidChangeListener(handler)
            self.handler = nil
        }
    }
    
    func signUp(email: String, password: String, name: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            Task { @MainActor in
                if let error = error {
                    print("❌ Auth Error: \(error.localizedDescription)")
                    return
                }
                
                guard let userId = result?.user.uid else { return }
                
                // --- DÉCOUPE DES RESPONSABILITÉS ---
                // 1. On prépare l'objet profil à partir de notre modèle UserProfile
                let newProfile = UserProfile(
                    id: userId,
                    name: name,
                    email: email,
                    avatarUrl: "https://i.pravatar.cc/150?u=\(userId)"
                )
                
                // 2. On utilise le Service pour enregistrer en base, pas Firestore en direct
                do {
                    try await FirestoreService.shared.createUserProfile(newProfile)
                    print("✅ Profil créé avec succès via FirestoreService")
                } catch {
                    print("❌ Erreur lors de la création du profil : \(error.localizedDescription)")
                }
            }
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
    
    deinit {
        if let handler = handler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
}
