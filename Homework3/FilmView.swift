import SwiftUI
import Foundation

struct FilmView: View {
    let film: FilmModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // film image
                ZStack(alignment: .bottomTrailing) {
                    if let imageUrlString = film.image, let imageUrl = URL(string: imageUrlString) {
                        AsyncImage(url: imageUrl) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 200)
                                    .cornerRadius(10)
                            } else if phase.error != nil {
                                Color.red // Error placeholder
                            } else {
                                Color.gray // Loading placeholder
                            }
                        }
                        
                        Text(film.title ?? "Unknown Title")
                            .padding()
                            .foregroundColor(.primary)
                            .background(Color.primary
                                .colorInvert()
                                .opacity(0.75))
                            .offset(x: -5, y: -5)
                    }
                }
                
                Text("Original Title: \(film.original_title ?? "N/A")")
                    .font(.body)
                    .padding(.bottom, 16)
                
                Text("Description: \(film.film_description ?? "N/A")")
                    .font(.body)
                    .padding(.bottom, 16)
                
                Text("Director: \(film.director ?? "Unknown")")
                    .font(.body)
                    .padding(.bottom, 16)
                
                Text("Release year: \(film.release_date ?? "N/A")")
                    .font(.body)
                    .padding(.bottom, 16)
                
                Text("id: \(film.id ?? "No ID")")
                
                Spacer()
            }
            .padding()
                
            if let imageUrlString = film.image, let imageUrl = URL(string: imageUrlString) {
                Button("Open Image URL") {
                    UIApplication.shared.open(imageUrl)
                }
                .padding()
                .background(Color(red: 0, green: 0, blue: 0.5))
                .foregroundStyle(.white)
                .clipShape(Capsule())
            }
        }
    }
}
