import SwiftUI
import FirebaseCore

@main
struct EventoriasApp: App {
    // 1. On gère l'état d'authentification au niveau le plus haut de l'app
    @StateObject private var authManager = AuthManager()

    // 2. Configuration de Firebase dans l'initialiseur
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            // 3. Utilisation de la RootView pour la logique d'affichage
            RootView()
                .environmentObject(authManager) // Injection pour les vues enfants
        }
    }
}
