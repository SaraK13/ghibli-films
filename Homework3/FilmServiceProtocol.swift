//
//  FilmServiceProtocol.swift
//  Homework3
//
//  Created by sara konno on 11.10.24.
//

import Foundation

protocol FilmServiceProtocol {
    func fetchFilms() async throws -> [Film]
}
