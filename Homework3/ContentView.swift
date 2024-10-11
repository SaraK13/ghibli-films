//
//  ContentView.swift
//  Homework3
//
//  Created by sara konno on 11.10.24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FilmViewModel(filmService: FilmService())

    var body: some View {
        NavigationView {
            List(viewModel.films, id: \.id) { film in
                NavigationLink(destination: FilmView(film: film)) {
                    HStack(alignment: .top) {
                        // Use AsyncImage to fetch the image from URL
                        AsyncImage(url: URL(string: film.image)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(8)
                            } else if phase.error != nil {
                                // In case of an error loading the image
                                Color.red
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(8)
                            } else {
                                // Placeholder while loading the image
                                Color.gray
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(8)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text(film.title)
                                .font(.headline)
                            Text(film.description)
                                .font(.subheadline)
                                .lineLimit(3) // Limiting lines to avoid too much text in the list
                        }
                        .padding(.leading, 8)
                    }
                    .padding(.vertical, 8)
                }
                
            }
            .refreshable { // Refresh logic: Call getAllFilms to refresh the data
                viewModel.getAllFilms()
            }
            .onAppear {
                viewModel.getAllFilms()
            }
            .navigationTitle("Studio Ghibli Films")
            .listStyle(.inset) // insetGrouped
        }
    }
}

#Preview {
    ContentView()
}
