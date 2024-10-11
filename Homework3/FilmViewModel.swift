//
//  FilmViewModel.swift
//  Homework3
//
//  Created by sara konno on 11.10.24.
//

import Foundation
import SwiftUI

class FilmViewModel: ObservableObject {
    @Published var films: [Film] = [] // holding the list of films
    @Published var errorMessage: String? = nil
    
    private let filmService: FilmServiceProtocol
    
    init(filmService: FilmServiceProtocol) {
        self.filmService = filmService
    }
    
    func getAllFilms() {
        Task {
            do {
                let fetchedFilms = try await filmService.fetchFilms()
                DispatchQueue.main.async {
                    if fetchedFilms.isEmpty {
                        self.errorMessage = "No films found"
                    } else {
                        self.films = fetchedFilms.sorted { $0.title < $1.title }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching films: \(error.localizedDescription)"
                }
            }
        }
    }
}

// The @Published propety holds list of films
// When fetchFilms() is called in the FilmViewModel, it fetches the films from the FilmService,
// and once the data is downloaded and parsed, the films array is updated.
// SwiftUI automatically updates the view when @Published properties change.
// So, when films is updated, the view is notified and re-rendered with the new data.
// And in ContentView:
// The @StateObject keyword in ContentView observes the FilmViewModel object.
// This means that the view is automatically updated whenever the films array in FilmViewModel is changed.
// When the films array is updated (after downloading and parsing is complete),
// SwiftUI triggers the re-render of the List in ContentView, and the new data is displayed.

