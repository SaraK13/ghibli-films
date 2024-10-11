//
//  FilmViewModel.swift
//  Homework3
//
//  Created by sara konno on 11.10.24.
//

import Foundation
import SwiftUI

class FilmViewModel: ObservableObject {
    @Published var films: [Film] = []
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

