//
//  Homework3App.swift
//  Homework3
//
//  Created by sara konno on 11.10.24.
//

import SwiftUI

@main
struct Homework3App: App {
    // Create an observable instance of the Core Data stack.core
    @StateObject private var coreDataStack = CoreDataStack.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Inject the persistent container's managed object context
                // into the environment.
                .environment(\.managedObjectContext,
                              coreDataStack.persistentContainer.viewContext)
        }
    }
}
