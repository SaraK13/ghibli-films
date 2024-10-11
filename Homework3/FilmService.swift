//
//  FilmService.swift
//  Homework3
//
//  Created by sara konno on 11.10.24.
//

import Foundation

class FilmService: FilmServiceProtocol {
    
    func fetchFilms() async throws -> [Film] {
            guard let url = URL(string: "https://ghibliapi.vercel.app/films") else {
                throw URLError(.badURL)
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let films = try JSONDecoder().decode([Film].self, from: data)
            return films
        }
}
