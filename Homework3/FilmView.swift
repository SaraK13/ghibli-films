import SwiftUI
import Foundation

struct FilmView: View {
    let film: Film
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // film image
                ZStack(alignment: .bottomTrailing) {
                    AsyncImage(url: URL(string: film.image)) { phase in
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
                    
                    Text("\(film.title)")
                        .padding()
                        .foregroundColor(.primary)
                        .background(Color.primary
                            .colorInvert()
                            .opacity(0.75))
                        .offset(x: -5, y: -5)
                }
                
                Text("Original Title: \(film.original_title)")
                    .font(.body)
                    .padding(.bottom, 16)
                
                Text(film.description)
                    .font(.body)
                    .padding(.bottom, 16)
                
                Text("Director: \(film.director)")
                    .font(.body)
                    .padding(.bottom, 16)
                
                Text("Release year: \(film.release_date)")
                    .font(.body)
                    .padding(.bottom, 16)
                
                Text("id: \(film.id)")
                
                Spacer()
            }
            .padding()
            
            Button("Open Image URL") {
                UIApplication.shared.open(URL(string: "\(film.image)")!)
            }
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundStyle(.white)
            .clipShape(Capsule())
        }

    }
}
