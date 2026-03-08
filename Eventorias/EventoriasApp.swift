import SwiftUI
import FirebaseCore // 1. On importe l'outil Firebase

// 2. On crée une classe pour configurer Firebase au lancement
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct EventoriasApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authManager = AuthManager() // 1. On crée le surveillant

    var body: some Scene {
        WindowGroup {
            // 2. On vérifie la présence d'un utilisateur
            if authManager.user != nil {
                MainView() // L'utilisateur est connecté (Étape 4)
            } else {
                LoginView() // Personne n'est connecté (Étape 3)
            }
        }
    }
}
