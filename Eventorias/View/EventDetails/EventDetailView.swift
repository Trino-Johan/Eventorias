import SwiftUI

struct EventDetailView: View {
    @Environment(\.dismiss) var dismiss
    let event: Event
    
    var body: some View {
        ZStack {
            Color(white: 0.1).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Header personnalisé
                EventDetailHeader(title: event.name, dismissAction: { dismiss() })
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // 2. Image principale
                        EventDetailMainImage(imageUrl: event.imageUrl)
                        
                        // 3. Date, Heure et Avatar
                        EventDetailMetaSection(date: event.date)
                        
                        // 4. Description
                        Text(event.description)
                            .font(.system(size: 15))
                            .lineSpacing(4)
                            .foregroundColor(.white.opacity(0.9))
                        
                        // 5. Localisation et Map
                        EventDetailLocationSection(location: event.location)
                    }
                    .padding(20)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
