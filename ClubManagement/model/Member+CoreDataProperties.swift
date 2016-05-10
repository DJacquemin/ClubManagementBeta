//
//  Member+CoreDataProperties.swift
//  
//
//  Created by student5306 on 28/04/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Member {

    @NSManaged var birthdate: NSDate?
    @NSManaged var firstname: String?
    @NSManaged var lastname: String?
    @NSManaged var licenseExpiration: NSDate?
    @NSManaged var events: NSSet?
    
    @NSManaged func removeEventsObject(event:Event)
    @NSManaged func addEventsObject(event:Event)

}
