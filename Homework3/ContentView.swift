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
            VStack {
                HStack {
                    Spacer() // Push the menu to the right side
                    
                    Menu {
                        // A-Z Sorting
                        Button(action: {
                            viewModel.sortOption = .az
                            viewModel.refreshFilms()
                        }) {
                            Label("A-Z", systemImage: "arrow.up")
                        }
                        
                        // Z-A Sorting
                        Button(action: {
                            viewModel.sortOption = .za
                            viewModel.refreshFilms()
                        }) {
                            Label("Z-A", systemImage: "arrow.down")
                        }
                        
                        // Publish Year Sorting
                        Button(action: {
                            viewModel.sortOption = .publishYear
                            viewModel.refreshFilms()
                        }) {
                            Label("Publish Year", systemImage: "calendar")
                        }
                        
                    } label: {
                        Label("Sort", systemImage: "arrowtriangle.down.fill")
                    }
                    .padding(.trailing) // Add padding to give some space from the edge
                }
                .padding(.top)
            
                
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
                .listStyle(.inset) // insetGrouped
            }
            .navigationTitle("Studio Ghibli Films")
        }
    }
}

#Preview {
    ContentView()
}
