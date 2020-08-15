//
//  Favorite+CoreDataProperties.swift
//  
//
//  Created by Madi Kabdrash on 8/15/20.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var defenition: String?
    @NSManaged public var word: String?

}
