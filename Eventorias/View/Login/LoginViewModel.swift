import Foundation
import FirebaseAuth
import Combine

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showError = false
    @Published var showLoginForm = false
    
    var authManager = AuthManager()
    
    func login() {
        isLoading = true
        errorMessage = ""
        showError = false
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                }
            }
        }
    }
    
    func signUp(name: String) {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty else {
            self.errorMessage = "Please fill all fields"
            self.showError = true
            return
        }
        
        isLoading = true
        authManager.signUp(email: email, password: password, name: name)
        
        // Sécurité : on repasse isLoading à false après un délai si l'AuthManager ne le fait pas
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
        }
    }
}
