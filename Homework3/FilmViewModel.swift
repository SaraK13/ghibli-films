import Foundation
import SwiftUI

enum SortOption: String, CaseIterable {
    case az = "A-Z"
    case za = "Z-A"
    case publishYear = "Publish Year"
}

class FilmViewModel: ObservableObject {
    @Published var films: [Film] = [] // holding the list of films
    //@Publishedは、ObservableObjectプロトコルを採用したクラス内で使われるプロパティラッパー。Publishedを使うことで、そのプロパティが変更された時に自動的に通知が行われ、そのプロパティを監視しているビューが再描画される仕組みを提供する。
    
    @Published var errorMessage: String? = nil
    @Published var sortOption: SortOption = .az
    
    private let filmService: FilmServiceProtocol
    
    init(filmService: FilmServiceProtocol) {
        self.filmService = filmService
    }
    
    func getAllFilms() async {
        do {
            let fetchedFilms = try await filmService.fetchFilms()
            DispatchQueue.main.async {
                if fetchedFilms.isEmpty {
                    self.errorMessage = "No films found"
                } else {
                    self.films = self.sortFilms(fetchedFilms, by: self.sortOption)
                    self.errorMessage = nil // Clear error if data is successfully loaded. without this line, error msg persisted even after correct URL was given
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error fetching films: \(error.localizedDescription)"
            }
        }
    }
    
    func sortFilms(_ films: [Film], by option: SortOption) -> [Film] {
        switch option {
        case .az:
            return films.sorted { $0.title < $1.title } // A-Z sorting
        case .za:
            return films.sorted { $0.title > $1.title } // Z-A sorting
        case .publishYear:
            return films.sorted { $0.release_date < $1.release_date } // Sort by year
        }
    }
    
    func refreshFilms() {
        self.films = sortFilms(self.films, by: self.sortOption)
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

