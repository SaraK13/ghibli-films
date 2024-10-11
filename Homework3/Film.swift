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
}
