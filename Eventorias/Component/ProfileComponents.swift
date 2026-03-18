import SwiftUI

// --- 1. L'AVATAR DU PROFIL ---
struct ProfileAvatarView: View {
    let urlString: String?
    
    var body: some View {
        AsyncImage(url: URL(string: urlString ?? "")) { image in
            image.resizable()
                .scaledToFill()
        } placeholder: {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .foregroundColor(.gray)
        }
        .frame(width: 50, height: 50)
        .background(Color.white)
        .clipShape(Circle())
    }
}

// --- 2. CHAMP D'INFORMATION ---
struct ProfileInfoField: View {
    let label: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Text(text)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(white: 0.2))
        .cornerRadius(10)
    }
}

// --- 3. BOUTTON NOTIFICATION ---
struct ProfileNotificationToggle: View {
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(isOn: $isOn) {
            Text("Notifications")
                .font(.body)
                .foregroundColor(.white)
        }
        .toggleStyle(SwitchToggleStyle(tint: Color.red))
        .padding(.vertical)
    }
}

// --- 4. BOUTON DÉCONNEXION ---
struct SignOutButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Sign Out")
                .foregroundColor(.red)
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .padding(.bottom, 20)
    }
}
