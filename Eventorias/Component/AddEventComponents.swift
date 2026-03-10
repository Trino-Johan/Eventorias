import SwiftUI
import PhotosUI

// --- 1. Header ---
struct AddEventHeader: View {
    let dismissAction: () -> Void
    var body: some View {
        HStack {
            Button(action: dismissAction) {
                Image(systemName: "arrow.left").foregroundColor(.white).font(.title3.bold())
            }
            Text("Creation of an event").font(.title3.bold()).foregroundColor(.white).padding(.leading, 10)
            Spacer()
        }.padding()
    }
}

// --- 2. Champ de saisie personnalisé ---
struct CustomInputField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isLarge: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.caption).foregroundColor(.gray)
            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.gray.opacity(0.6)))
                .padding()
                .frame(height: isLarge ? 80 : 55, alignment: isLarge ? .topLeading : .center)
                .background(Color(white: 0.2))
                .cornerRadius(10)
                .foregroundColor(.white)
        }
    }
}

// --- 3. Sélecteur de Date ---
struct CustomDatePicker: View {
    let label: String
    @Binding var selection: Date
    let components: DatePickerComponents
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.caption).foregroundColor(.gray)
            DatePicker("", selection: $selection, displayedComponents: components)
                .labelsHidden()
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color(white: 0.2))
                .cornerRadius(10)
                .colorScheme(.dark)
        }
    }
}

// --- 4. Bouton Galerie (PhotosUI) --- Pas l'abonnement firebase pour stocker des photso prises
struct GalleryPickerButton: View {
    @Binding var selection: PhotosPickerItem?
    var body: some View {
        PhotosPicker(selection: $selection, matching: .images, photoLibrary: .shared()) {
            HStack {
                Image(systemName: "photo.on.rectangle.angled")
                Text("Select a photo from gallery")
            }
            .font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding().background(Color.red).cornerRadius(15)
        }.padding(.top, 10)
    }
}

// --- 5. Bouton Sauvegarder ---
struct SaveEventButton: View {
    @ObservedObject var viewModel: AddEventViewModel
    let dismissAction: () -> Void
    
    var body: some View {
        Button(action: {
            viewModel.saveEvent { success in if success { dismissAction() } }
        }) {
            if viewModel.isLoading {
                ProgressView().tint(.white)
            } else {
                Text("Validate").font(.headline).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding().background(viewModel.name.isEmpty ? Color.gray : Color.red).cornerRadius(10)
            }
        }
        .disabled(viewModel.name.isEmpty || viewModel.isLoading)
        .padding(.horizontal).padding(.bottom, 10)
    }
}

// --- 6. Aperçu Image ---
struct EventImagePreview: View {
    let image: UIImage
    var body: some View {
        Image(uiImage: image).resizable().scaledToFill().frame(height: 180).cornerRadius(15).clipped().padding(.top, 10)
    }
}
