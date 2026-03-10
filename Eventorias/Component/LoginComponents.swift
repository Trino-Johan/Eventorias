import SwiftUI

// --- 1. LE LOGO ---
struct LoginLogoView: View {
    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                Image(systemName: "sun.max")
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
            
            Text("EVENTORIAS")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .kerning(4)
        }
    }
}

// --- 2. LE HEADER DE RETOUR ---
struct LoginBackHeader: View {
    let action: () -> Void
    var body: some View {
        HStack {
            Button(action: action) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium))
            }
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

// --- 3. LES CHAMPS DU FORMULAIRE ---
struct LoginFormFields: View {
    @ObservedObject var viewModel: LoginViewModel
    @Binding var name: String
    let isSignUpMode: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            if isSignUpMode {
                TextField("Full Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .transition(.opacity)
            }
            
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)
        }
        .padding(.horizontal, 40)
    }
}

// --- 4. LE BOUTON D'ACTION PRINCIPAL ---
struct LoginPrimaryButton: View {
    let label: String
    let isLoading: Bool
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    HStack {
                        Image(systemName: icon)
                        Text(label)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding(.horizontal, 40)
    }
}
