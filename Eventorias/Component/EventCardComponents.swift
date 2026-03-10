import SwiftUI

// --- 1. L'AVATAR CIRCULAIRE ---
struct EventAvatarView: View {
    let eventId: String?
    
    var body: some View {
        AsyncImage(url: URL(string: "https://i.pravatar.cc/100?u=\(eventId ?? "")")) { img in
            img.resizable().scaledToFill()
        } placeholder: {
            Circle().fill(Color.gray)
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())
    }
}

// --- 2. LES TEXTES (NOM + DATE) ---
struct EventInfoTextView: View {
    let name: String
    let date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(date.formatted(date: .long, time: .omitted))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

// --- 3. L'IMAGE D'ILLUSTRATION ---
struct EventThumbnailView: View {
    let imageUrl: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image.resizable()
                .scaledToFill()
        } placeholder: {
            Rectangle().fill(Color.gray.opacity(0.3))
        }
        .frame(width: 120, height: 80)
        .cornerRadius(10)
        .clipped()
        .padding(6)
    }
}
