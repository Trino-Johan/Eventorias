import Foundation
import FirebaseAuth
import Combine

final class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    func fetchProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {

            self.errorMessage = "Utilisateur non authentifié"
            return
        }
        
        isLoading = true
        Task {
            do {
                let fetchedProfile = try await FirestoreService.shared.fetchUserProfile(userId: userId)
                await MainActor.run {
                    self.profile = fetchedProfile
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
