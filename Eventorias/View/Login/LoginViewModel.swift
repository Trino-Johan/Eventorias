import Foundation
import Combine
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showError = false
    @Published var showLoginForm = false
    
    func login() {
        isLoading = true // le spinner
        errorMessage = "" // réinitialise les erreurs
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            // C'est ici que Firebase répond
            self.isLoading = false // Arrête le spinner dans tous les cas
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.showError = true
            } else {
                print("User found : \(result?.user.uid ?? "")")
            }
        }
    }
}
