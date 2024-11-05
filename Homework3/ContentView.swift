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
    
    @AppStorage(UserSettings.Keys.apiUrl) private var apiUrl = UserSettings.shared.apiUrl
    @AppStorage(UserSettings.Keys.showImages) private var showImages = UserSettings.shared.showImages

    @State private var errorMessage: String?
    
    // Get a reference to the managed object context from the environment.
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)  // Show the error message
                        .foregroundColor(.red)
                        .padding()
                }
                
                sortingMenu
                
                filmListView
                    .refreshable { // Refresh logic: Call reloadFilmsFromAPI to refresh the data<
                        Task {
                            await viewModel.reloadFilmsFromAPI()
                        }
                    }
                    .onAppear {
                        if viewModel.films.isEmpty {  // Only load if the films array is empty
                            viewModel.loadFilmsFromDatabase()
                            Task {
                                await viewModel.reloadFilmsFromAPI()
                            }
                        }
                    }
                    // React to apiUrl changes
                    .onChange(of: apiUrl) {
                        Task {
                            viewModel.deleteFilms()  // Clear the database on URL change
                            await viewModel.reloadFilmsFromAPI()
                        }
                    }
                    .listStyle(.inset)
            }
            .navigationTitle("Studio Ghibli Films")
        }
    }
    
    private var sortingMenu: some View {
        HStack {
            Spacer()
            Menu {
                Button(action: {
                    viewModel.sortOption = .az
                    viewModel.updateSorting()
                }) {
                    Label("A-Z", systemImage: "arrow.up")
                }
                
                Button(action: {
                    viewModel.sortOption = .za
                    viewModel.updateSorting()
                }) {
                    Label("Z-A", systemImage: "arrow.down")
                }
                
                Button(action: {
                    viewModel.sortOption = .publishYear
                    viewModel.updateSorting()
                }) {
                    Label("Publish Year", systemImage: "calendar")
                }
            } label: {
                Label("Sort \(viewModel.sortOption.rawValue)", systemImage: "arrowtriangle.down.fill")
            }
            .padding(.trailing)
        }
        .padding(.top)
    }
    
    private var filmListView: some View {
        List(viewModel.films.indices, id: \.self) { index in
            let film = viewModel.films[index]
            NavigationLink(destination: FilmView(film: film)) {
                FilmRow(film: film, showImages: showImages)
            }
        }
    }
}

struct FilmRow: View {
    let film: FilmModel
    let showImages: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            if showImages, let imageURL = URL(string: film.image ?? "") {
                AsyncImage(url: imageURL) { phase in
                    FilmImageView(phase: phase)
                }
            }
            
            VStack(alignment: .leading) {
                Text(film.title ?? "Unknown Title")
                    .font(.headline)
                Text(film.film_description ?? "No Description")
                    .font(.subheadline)
                    .lineLimit(3)
            }
            .padding(.leading, 8)
        }
        .padding(.vertical, 8)
    }
}

    // Simplified FilmImageView to encapsulate AsyncImage phases
struct FilmImageView: View {
    let phase: AsyncImagePhase
    
    var body: some View {
        switch phase {
            case .empty:
                Color.gray
                    .frame(width: 100, height: 150)
                    .cornerRadius(8)
            case .success(let image):
                image.resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 150)
                    .cornerRadius(8)
            case .failure:
                Color.red
                    .frame(width: 100, height: 150)
                    .cornerRadius(8)
            @unknown default:
                EmptyView()
        }
    }
}

#Preview {
    ContentView()
}
