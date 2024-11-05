import Foundation
import CoreData

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() { }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    func fetchFilms() -> [FilmModel] {
        let request: NSFetchRequest<FilmModel> = FilmModel.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch films: \(error)")
            return []
        }
    }
    
    func deleteAllFilms() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FilmModel.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Failed to delete films: \(error)")
        }
    }
}
