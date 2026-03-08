import SwiftUI

struct LoginView: View {
    // Lie la view au ViewModel
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            // Le fond sombre
            Color.black.ignoresSafeArea()

            VStack(spacing: 30) { // Espace les éléments verticalement
                // Le Logo
                ZStack {
                    Image(systemName: "sun.max") //P Pas trouvé le symbol exact
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                      
                    Image(systemName: "moon.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 30)
                        .foregroundColor(.white)
                        .scaleEffect(x: -1, y: 1)
                }
                // Titre
                Text("EVENTORIAS")
                    .font(.largeTitle) // Taille imposante
                    .fontWeight(.bold) // En gras
                    .foregroundColor(.white) // Couleur blanche
                    .kerning(4) // Espacement entre les lettres pour un look "logo"
                    .padding(.bottom, 30)
                
                if viewModel.showLoginForm {
                    VStack(spacing: 15) {
                                TextField("Email", text: $viewModel.email)
                                    .textFieldStyle(.roundedBorder)
                                    .autocapitalization(.none)
                                
                                SecureField("Password", text: $viewModel.password)
                                    .textFieldStyle(.roundedBorder)
                            }
                            .padding(.horizontal, 40)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                Button(action: {
                    if viewModel.showLoginForm {
                        viewModel.login() // Si c'est ouvert, connecte
                    } else {
                        withAnimation {
                            viewModel.showLoginForm = true
                        }
                    }
                }) {
                    Group {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            HStack {
                                Image(systemName: "envelope.fill")
                                Text(viewModel.showLoginForm ? "Login" : "Sign in with email")
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.bottom,300)
                .padding(.horizontal, 40)
                .alert("Connexion error", isPresented: $viewModel.showError) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(viewModel.errorMessage)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
