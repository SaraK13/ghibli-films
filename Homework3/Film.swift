//
//  Film.swift
//  Homework3
//
//  Created by sara konno on 11.10.24.
//

import Foundation //  Foundation is the framework that brings in that class hierarchy.

struct Film: Decodable {
    let id: String
    let title: String
    let description: String
    let image: String
    let original_title: String
    let director: String
    let release_date: String
}