import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject var profileViewModel = ProfileViewModel()
    @State private var areNotificationsEnabled = true
    
    var body: some View {
        VStack(spacing: 30) {
            // --- 1. En-tête avec Avatar ---
            headerSection
            
            // --- 2. États de chargement/erreur ---
            statusSection
            
            // --- 3. Informations utilisateur ---
            VStack(spacing: 20) {
                ProfileInfoField(
                    label: "Name",
                    text: profileViewModel.profile?.name ?? "Loading..."
                )
                
                ProfileInfoField(
                    label: "E-mail",
                    text: authManager.user?.email ?? "Loading..."
                )
            }
            
            // --- 4. Réglages ---
            ProfileNotificationToggle(isOn: $areNotificationsEnabled)
            
            Spacer()
            
            // --- 5. Action ---
            SignOutButton(action: { authManager.signOut() })
        }
        .padding()
        .background(Color(white: 0.1).edgesIgnoringSafeArea(.all))
        .onAppear {
            profileViewModel.fetchProfile()
        }
    }
    
    // --- COMPOSANTS INTERNES ---

    private var headerSection: some View {
        HStack {
            Text("User profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Spacer()
            
            ProfileAvatarView(urlString: profileViewModel.profile?.avatarUrl)
        }
        .padding(.top)
    }

    @ViewBuilder
    private var statusSection: some View {
        if profileViewModel.isLoading {
            ProgressView().tint(.white)
        } else if let error = profileViewModel.errorMessage {
            Text(error).foregroundColor(.red).font(.caption)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthManager())
}
