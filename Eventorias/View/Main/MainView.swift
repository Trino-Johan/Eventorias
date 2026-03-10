import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: EventsViewModel
    @State private var isShowingAddSheet = false
    
    var body: some View {
        ZStack {
            Color(white: 0.1).ignoresSafeArea()

            VStack(spacing: 12) {
                // 1. Recherche
                SearchBarView(text: $viewModel.searchText)
                
                // 2. Ligne d'actions
                HStack {
                    SortMenuView(selection: $viewModel.sortOption)
                    Spacer()
                    AddEventInlineButton(isPresented: $isShowingAddSheet)
                }
                .padding(.horizontal)
                
                // 3. Liste
                EventListView(events: viewModel.events)
            }
            .padding(.top, 10)
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingAddSheet) {
            AddEventView()
        }
    }
}
