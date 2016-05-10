//
//  Event+CoreDataProperties.swift
//  
//
//  Created by student5306 on 26/04/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var beginning: NSDate?
    @NSManaged var end: NSDate?
    @NSManaged var name: String?
    @NSManaged var type: String?
    @NSManaged var participants: NSSet?
    
    @NSManaged func removeParticipantsObject(participant:Member)
    @NSManaged func addParticipantsObject(participant:Member)

}
