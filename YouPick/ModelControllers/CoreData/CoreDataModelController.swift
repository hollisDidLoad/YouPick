//
//  CoreDataModelController.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/31/22.
//

import Foundation

class CoreDataModelController {
    static let shared = CoreDataModelController()
    private init() {}
    
    let context = CoreDataStack.context
    
    var savedRestaurants = [SavedRestaurants]()
    
    func retrieveRestaurants(completion: @escaping () -> Void) {
        do {
            savedRestaurants = try context.fetch(SavedRestaurants.fetchRestaurants())
            DispatchQueue.main.async {
                completion()
            }
        } catch {
            print("Error fetching Core Data: \(error)")
        }
    }
    
    func createRestaurantData(with name: String, _ url: URL, and location: String) {
        let newRestaurantData = SavedRestaurants(context: context)
        newRestaurantData.name = name
        newRestaurantData.location = location
        newRestaurantData.url = url
        saveData()
    }
    
    func deleteRestaurantData(with data: SavedRestaurants) {
        context.delete(data)
        saveData()
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving Core Data: \(error)")
        }
    }
}
