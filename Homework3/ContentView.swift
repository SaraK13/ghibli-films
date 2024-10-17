//
//  ContentView.swift
//  Homework3
//
//  Created by sara konno on 11.10.24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FilmViewModel(filmService: FilmService())
    //@StateObjectは、SwiftUIにおける状態管理のための属性で、参照型オブジェクトのライフサイクルをSwiftUIが管理するために使用されます。特に、ObservableObjectを使っている場合に、ビューがそのオブジェクトを監視し、データが変化したときにビューを自動的に再描画する仕組みを提供. 新しいオブジェクトを作成し、そのライフサイクルを管理.

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
                        Label("Sort \(viewModel.sortOption.rawValue)", systemImage: "arrowtriangle.down.fill")
                    }
                    .padding(.trailing) // Add padding to give some space from the edge
                }
                .padding(.top)
            
                
                List(viewModel.films.indices, id: \.self) { index in
                    let film = viewModel.films[index] // Access film by index
                    
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
                        .background(index == 0 ? Color.blue.opacity(0.3) : Color.clear)
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
