//
//  FilmView.swift
//  Homework3
//
//  Created by sara konno on 11.10.24.
//

import SwiftUI
import Foundation

struct FilmView: View {
    let film: Film
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // film image
                AsyncImage(url: URL(string: film.image)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .cornerRadius(10)
                    } else if phase.error != nil {
                        Color.red // Error placeholder
                    } else {
                        Color.gray // Loading placeholder
                    }
                }
                
                Text("Original Title: \(film.original_title)")
                    .font(.body)
                    .padding(.bottom, 16)
                
                Text(film.description)
                    .font(.body)
                    .padding(.bottom, 16)
                
                Text("Director: \(film.director)")
                    .font(.body)
                    .padding(.bottom, 16)
                
                Text("Release year: \(film.release_date)")
                    .font(.body)
                    .padding(.bottom, 16)
                
                Text("id: \(film.id)")
                Text("Image URL:")
                Link("\(film.image)", destination: URL(string: "\(film.image)")!)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(film.title)
    }
}
