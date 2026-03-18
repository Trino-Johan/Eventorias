import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var addViewModel = AddEventViewModel()
    
    var body: some View {
        ZStack {
            Color(white: 0.1).ignoresSafeArea()
            
            VStack {
                AddEventHeader(dismissAction: { dismiss() })
                
                ScrollView {
                    VStack(spacing: 10) {
                        if let image = addViewModel.selectedImage {
                            EventImagePreview(image: image)
                        }

                        CustomInputField(label: "Title", placeholder: "New event", text: $addViewModel.name)
                        CustomInputField(label: "Description", placeholder: "Enter description", text: $addViewModel.description, isLarge: true)
                        
                        HStack(spacing: 10) {
                            CustomDatePicker(label: "Date", selection: $addViewModel.eventDate, components: .date)
                            CustomDatePicker(label: "Time", selection: $addViewModel.eventDate, components: .hourAndMinute)
                        }
                        
                        CustomInputField(label: "Address", placeholder: "Enter full address", text: $addViewModel.location)
                        
                        GalleryPickerButton(selection: $addViewModel.imageSelection)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                SaveEventButton(viewModel: addViewModel, dismissAction: { dismiss() })
            }
        }
        .navigationBarHidden(true)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationView {
        AddEventView()
    }
}
