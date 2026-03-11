import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor // ✅ Sécurité absolue pour la classe
class AuthManager: ObservableObject {
    @Published var user: FirebaseAuth.User?
    private var db = Firestore.firestore()
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            // ✅ Force la mise à jour sur le Main Thread
            Task { @MainActor in
                self?.user = user
            }
        }
    }
    
    func cleanUp() {
        if let handler = handler {
            Auth.auth().removeStateDidChangeListener(handler)
            self.handler = nil // On vide la mémoire immédiatement
        }
    }
    
    func signUp(email: String, password: String, name: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            // ✅ Retourne sur le Main Thread avant de lire l'erreur ou la DB
            Task { @MainActor in
                if let error = error {
                    print("❌ Auth Error: \(error.localizedDescription)")
                    return
                }
                
                guard let userId = result?.user.uid else { return }
                
                let profileData: [String: Any] = [
                    "name": name,
                    "email": email,
                    "avatarUrl": "https://i.pravatar.cc/150?u=\(userId)"
                ]
                
                // ✅ Version asynchrone moderne (supprime l'avertissement jaune de Xcode)
                do {
                    try await self?.db.collection("users").document(userId).setData(profileData)
                    print("✅ Profil créé pour \(name)")
                } catch {
                    print("❌ Firestore Error: \(error.localizedDescription)")
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
