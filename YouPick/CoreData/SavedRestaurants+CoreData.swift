//
//  SavedRestaurants+CoreData.swift
//  YouPick
//
//  Created by Hollis Kwan on 10/31/22.
//

import CoreData

class SavedRestaurants: NSManagedObject {
    
    class func fetchRestaurants() -> NSFetchRequest<SavedRestaurants> {
        return NSFetchRequest<SavedRestaurants>(entityName: "SavedRestaurants")
    }
    
    @NSManaged public var location: String
    @NSManaged public var name: String
    @NSManaged public var url: URL
}
