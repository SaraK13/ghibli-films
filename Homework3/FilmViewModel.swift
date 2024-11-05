import Foundation
import SwiftUI
import CoreData

enum SortOption: String, CaseIterable {
    case az = "A-Z"
    case za = "Z-A"
    case publishYear = "Publish Year"
}

class FilmViewModel: ObservableObject {
    @Published var films: [FilmModel] = [] // holding the list of films
    //@Publishedは、ObservableObjectプロトコルを採用したクラス内で使われるプロパティラッパー。Publishedを使うことで、そのプロパティが変更された時に自動的に通知が行われ、そのプロパティを監視しているビューが再描画される仕組みを提供する。
    
    @Published var errorMessage: String? = nil
    @Published var sortOption: SortOption = .az
    
    private let coreDataStack = CoreDataStack.shared
    private let filmService: FilmServiceProtocol
    private var isDataLoaded = false
    
    init(filmService: FilmServiceProtocol) {
        self.filmService = filmService
    }
    
    func loadFilmsFromDatabase() {
        // Avoid reloading if films are already loaded
        guard !isDataLoaded else { return }
        
        let fetchedFilms = coreDataStack.fetchFilms()
        DispatchQueue.main.async {
            self.films = self.sortFilms(fetchedFilms)
            self.isDataLoaded = true  // Mark as loaded after initial fetch
            print("Fetched \(fetchedFilms.count) films from Core Data")
        }
    }
    
    func reloadFilmsFromAPI() async {
        do {
            let fetchedFilms = try await filmService.fetchFilms()
            
            // Fetch existing films from Core Data
            let existingFilms = coreDataStack.fetchFilms()
            let existingFilmIDs = Set(existingFilms.map { $0.id })
            
            // Filter out films that are not already in Core Data
            let newFilms = fetchedFilms.filter { !existingFilmIDs.contains($0.id) }
            
            if newFilms.isEmpty {
                // If no new films are found, print a log message
                DispatchQueue.main.async {
                    print("No new films found in API response")
                }
            } else {
                // If there are new films, update the database
                coreDataStack.deleteAllFilms() // Clear the database
                
                for film in fetchedFilms {
                    let filmEntity = FilmModel(context: coreDataStack.context)
                    filmEntity.id = film.id
                    filmEntity.title = film.title
                    filmEntity.film_description = film.description
                    filmEntity.image = film.image
                    filmEntity.original_title = film.original_title
                    filmEntity.director = film.director
                    filmEntity.release_date = film.release_date
                }
                
                coreDataStack.saveContext()
                
                DispatchQueue.main.async {
                    self.loadFilmsFromDatabase()  // Refresh films only after database update
                    self.errorMessage = nil  // Clear error if data was successfully updated
                    print("Database updated with new films")
                }
            }
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error fetching films: \(error.localizedDescription)"
                print("Error fetching films: \(error.localizedDescription)")
            }
        }
    }

    
    func sortFilms(_ films: [FilmModel]) -> [FilmModel] {
        switch sortOption {
            case .az:
                return films.sorted { $0.title ?? "" < $1.title ?? "" }
            case .za:
                return films.sorted { $0.title ?? "" > $1.title ?? "" }
            case .publishYear:
                return films.sorted { $0.release_date ?? "" < $1.release_date ?? "" }
        }
    }
    
    func updateSorting() {
        DispatchQueue.main.async {
            self.films = self.sortFilms(self.films)
        }
    }
    
    // for API change. whenever API is changed, database will be reset
    func deleteFilms() {
        coreDataStack.deleteAllFilms()
        self.isDataLoaded = false
        print("All films deleted from Core Data due to URL change")
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

