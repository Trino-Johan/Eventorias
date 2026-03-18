import SwiftUI

// --- 1. BARRE DE RECHERCHE ---
struct SearchBarView: View {
    @Binding var text: String //
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white)
            
            TextField(
                "",
                text: $text,
                prompt: Text("Search").foregroundColor(.white.opacity(0.7))
            )
            .foregroundColor(.white)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(Color(white: 0.2))
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

// --- 2. MENU DE TRI ---
struct SortMenuView: View {
    @Binding var selection: SortOption //
    
    var body: some View {
        Menu {
            Button(action: { selection = .date }) {
                Label("Date", systemImage: "calendar")
            }
            Button(action: { selection = .name }) {
                Label("Name", systemImage: "abc")
            }
        } label: {
            HStack {
                Image(systemName: "arrow.up.arrow.down")
                Text("Sorting")
            }
            .font(.subheadline.bold())
            .padding(.vertical, 8)
            .padding(.horizontal, 15)
            .background(Color(white: 0.2))
            .foregroundColor(.white)
            .cornerRadius(15)
        }
    }
}

// --- 3. BOUTON D'AJOUT COMPACT (Inline) ---
struct AddEventInlineButton: View {
    @Binding var isPresented: Bool //
    
    var body: some View {
        Button(action: { isPresented = true }) {
            HStack {
                Image(systemName: "plus")
                Text("Add")
            }
            .font(.subheadline.bold())
            .padding(.vertical, 8)
            .padding(.horizontal, 15)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

// --- 4. LISTE DES ÉVÉNEMENTS ---
struct EventListView: View {
    let events: [Event] //
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(events) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        EventCard(event: event)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
