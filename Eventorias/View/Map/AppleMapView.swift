import SwiftUI
import MapKit

struct AppleMapView: View {
    let address: String
    
    @State private var position: MapCameraPosition = .automatic
    @State private var coordinate: CLLocationCoordinate2D?

    var body: some View {
        Map(position: $position) {
            if let coordinate = coordinate {
                Marker(address, coordinate: coordinate)
                    .tint(.red)
            }
        }
        .onAppear {
            updateLocation()
        }
    }

    // Utilise MKLocalSearch
    private func updateLocation() {
        // 1. On prépare la requête de recherche MapKit
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = address
        
        let search = MKLocalSearch(request: searchRequest)
        
        Task {
            do {
                // 2. lance la recherche de manière asynchrone
                let response = try await search.start()
                
                // 3. On récupère le premier résultat trouvé
                if let firstItem = response.mapItems.first {
                    let center = firstItem.placemark.coordinate
                    
                    // Mise à jour de l'UI sur le thread principal
                    await MainActor.run {
                        self.coordinate = center
                        withAnimation(.spring()) {
                            self.position = .region(MKCoordinateRegion(
                                center: center,
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            ))
                        }
                    }
                }
            } catch {
                print("❌ MapKit Search Error : \(error.localizedDescription)")
            }
        }
    }
}
