import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @State private var isSignUpMode = false
    @State private var name = ""
    
    var body: some View {
        ZStack {
            Color(white: 0.1).ignoresSafeArea()

            VStack(spacing: 30) {
                // 1. Header de retour
                if viewModel.showLoginForm {
                    LoginBackHeader {
                        withAnimation {
                            viewModel.showLoginForm = false
                            isSignUpMode = false
                        }
                    }
                    .transition(.opacity)
                }

                // 2. Logo
                LoginLogoView()
                
                // 3. Formulaire
                if viewModel.showLoginForm {
                    LoginFormFields(viewModel: viewModel, name: $name, isSignUpMode: isSignUpMode)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                // 4. Bouton Principal
                LoginPrimaryButton(
                    label: buttonLabel,
                    isLoading: viewModel.isLoading,
                    icon: isSignUpMode ? "person.badge.plus" : "envelope.fill",
                    action: handlePrimaryAction
                )
                
                // 5. Toggle Lien Inscription/Connexion
                if viewModel.showLoginForm {
                    Button(action: { withAnimation { isSignUpMode.toggle() } }) {
                        Text(isSignUpMode ? "Already have an account? Login" : "Don't have an account? Sign Up")
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }
                
                Spacer()
            }
            .padding(.top, viewModel.showLoginForm ? 20 : 50)
        }
        .alert("Auth Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
    
    // --- Logique UI extraite ---
    
    private var buttonLabel: String {
        if !viewModel.showLoginForm { return "Sign in with email" }
        return isSignUpMode ? "Create Account" : "Login"
    }
    
    private func handlePrimaryAction() {
        if viewModel.showLoginForm {
            if isSignUpMode {
                viewModel.signUp(name: name)
            } else {
                viewModel.login()
            }
        } else {
            withAnimation { viewModel.showLoginForm = true }
        }
    }
}
