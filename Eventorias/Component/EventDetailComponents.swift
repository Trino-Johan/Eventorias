import SwiftUI
import MapKit

// --- 1. LE HEADER AVEC RETOUR ---
struct EventDetailHeader: View {
    let title: String
    let dismissAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: dismissAction) {
                Image(systemName: "arrow.left")
                    .font(.title3.bold())
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.white)
                .padding(.leading, 15)
            
            Spacer()
        }
        .padding()
        .background(Color(white: 0.1))
    }
}

// --- 2. L'IMAGE PRINCIPALE ---
struct EventDetailMainImage: View {
    let imageUrl: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image.resizable()
                 .aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle().foregroundColor(.gray.opacity(0.2))
        }
        .frame(height: 375)
        .cornerRadius(20)
        .clipped()
    }
}

// --- 3. INFOS TEMPORELLES ET ORGANISATEUR ---
struct EventDetailMetaSection: View {
    let date: Date
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 12) {
                Label(date.formatted(date: .long, time: .omitted), systemImage: "calendar")
                    .font(.system(size: 16, weight: .medium))
                
                Label(date.formatted(date: .omitted, time: .shortened), systemImage: "clock")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.white)
            
            Spacer()
            
            // Avatar
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 45, height: 45)
                .foregroundColor(.gray)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.red, lineWidth: 1))
        }
    }
}

// --- 4. SECTION LOCALISATION AVEC MZP ---
struct EventDetailLocationSection: View {
    let location: String?
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                Text(location ?? "Paris, France")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            if let loc = location, !loc.isEmpty {
                // Utilisation de appleMapview
                AppleMapView(address: loc)
                    .frame(width: 150, height: 70)
                    .cornerRadius(12)
            }
        }
    }
}
