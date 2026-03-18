import SwiftUI

struct EventCard: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: 0) {
            // Partie gauche : Infos
            HStack(spacing: 12) {
                EventAvatarView(eventId: event.id)
                EventInfoTextView(name: event.name, date: event.date)
            }
            .padding(.leading, 15)
            
            Spacer()
            
            // Partie droite : Image
            EventThumbnailView(imageUrl: event.imageUrl)
        }
        .background(Color(white: 0.15))
        .cornerRadius(15)
    }
}
