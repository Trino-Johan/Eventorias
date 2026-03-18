import SwiftUI

struct AppTabView: View {
    @StateObject var viewModel = EventsViewModel()
    
    var body: some View {
        TabView {
            // Premier onglet : Liste avec sa propre navigation
            NavigationStack {
                MainView(viewModel: viewModel)
            }
            .tabItem {
                Label("Events", systemImage: "calendar")
            }
            
            // Deuxième onglet : Profil avec sa propre navigation
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
        .tint(.red) // Applique la couleur rouge aux icônes sélectionnées
    }
}
