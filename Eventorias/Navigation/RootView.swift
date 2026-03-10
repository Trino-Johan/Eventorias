import SwiftUI

struct RootView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        Group {
            if authManager.user != nil {
                // ✅ On affiche la vue avec les onglets, pas juste la liste
                AppTabView()
            } else {
                LoginView()
            }
        }
    }
}
