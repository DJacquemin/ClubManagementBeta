//
//  DBManager.swift
//  ClubManagement
//
//  Created by student5306 on 15/04/16.
//  Copyright © 2016 student5306. All rights reserved.
//

import CoreData

class DBManager {
    static let sharedInstance = DBManager()
    
    var managedObjectContext:NSManagedObjectContext!
    
    private init(){
        let documentPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true)[0]
        let filePath = documentPath + "/clubManager.sqlite"
        let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)
        let persistenceStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
        let urlDB = NSURL(fileURLWithPath: filePath)
        
        do {
            try persistenceStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: urlDB, options: nil)
        } catch let error as NSError {
            print("error, could not open DB \(error)")
        }
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistenceStoreCoordinator
    }
    
    func save(){
        if(managedObjectContext.hasChanges) {
            do{
                try managedObjectContext.save()
            } catch let error as NSError {
                print("error, could not save \(error)")
            }
        }
    }
    
    //MARK: - Add entities
    
    func addMember(lastname:String, firstname:String, birthdate:NSDate, licenseExpiration:NSDate, events:[Event]?) -> Member {
        let entityMember = NSEntityDescription.entityForName("Member", inManagedObjectContext: managedObjectContext)
        let member = Member(entity: entityMember!, insertIntoManagedObjectContext: managedObjectContext)
        
        member.lastname = lastname
        member.firstname = firstname
        member.birthdate = birthdate
        member.licenseExpiration = licenseExpiration
        
        if let eventsToAdd = events {
            member.events = NSSet(array: eventsToAdd)
        }
        
        save()
        
        return member
    }
    
    func addEvent(name:String, beginning:NSDate, end:NSDate, type:EventType, participants:[Member]?) -> Event {
        let entityEvent = NSEntityDescription.entityForName("Event", inManagedObjectContext: managedObjectContext)
        let event = Event(entity: entityEvent!, insertIntoManagedObjectContext: managedObjectContext)
        
        event.name = name
        event.beginning = beginning
        event.end = end
        event.type = type.rawValue
        
        if let participantsToAdd = participants {
            event.participants = NSSet(array: participantsToAdd)
        }
        
        save()
        
        return event
    }
    
    //MARK: - Remove entities
    
    func removeMember(member:Member) {
        managedObjectContext.deleteObject(member)
        save()
    }
    
    func removeEvent(event:Event) {
        managedObjectContext.deleteObject(event)
        save()
    }
    
    //MARK: - All entities
    
    func allMember() -> [Member]? {
        let fetchRequest = NSFetchRequest(entityName: "Member")
        do {
            let members = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Member]
            return members
        } catch let error as NSError {
            print("error = \(error)")
        }
        return nil
    }
    
    func allEvents() -> [Event]? {
        let fetchRequest = NSFetchRequest(entityName: "Event")
        do {
            let events = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Event]
            return events
        } catch let error as NSError {
            print("error = \(error)")
        }
        return nil
    }
    
    //MARK: Fetch Requests
    
    func eventsForToday() -> [Event]? {
        let fetchRequest = NSFetchRequest(entityName: "Event")
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components([.Year, .Month, .Day], fromDate: NSDate())
        let beginning = calendar.dateFromComponents(components)!.dateByAddingTimeInterval(NSTimeInterval(NSTimeZone.localTimeZone().secondsFromGMT))
        let end = calendar.dateByAddingUnit(.Day, value: 1, toDate: beginning, options: NSCalendarOptions.MatchStrictly)!
        fetchRequest.predicate = NSPredicate(format: "beginning >= %@ AND end <= %@", beginning, end)
        do {
            let events = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Event]
            return events
        } catch let error as NSError {
            print("error = \(error)")
        }
        return nil
    }
    
    func getMemberWithLicenceExpiration() -> [Member]? {
        let fetchRequest = NSFetchRequest(entityName: "Member")
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let maxDate = calendar.dateByAddingUnit(.Month, value: 3, toDate: NSDate(), options: [])
        fetchRequest.predicate = NSPredicate(format: "licenseExpiration <= %@", maxDate!)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "licenseExpiration", ascending: true)]
        do {
            let members = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Member]
            return members
        } catch let error as NSError {
            print("error = \(error)")
        }
        return nil
    }
    
    func getNextEvents() -> [Event]? {
        let fetchRequest = NSFetchRequest(entityName: "Event")
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let maxDate = calendar.dateByAddingUnit(.Month, value: 3, toDate: NSDate(), options: [])
        fetchRequest.predicate = NSPredicate(format: "beginning <= %@ AND beginning >= %@", maxDate!, NSDate())
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "beginning", ascending: true)]
        do {
            let events = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Event]
            return events
        } catch let error as NSError {
            print("error = \(error)")
        }
        return nil
    }
    
    func allTraining() -> [Event]? {
        let fetchRequest = NSFetchRequest(entityName: "Event")
        fetchRequest.predicate = NSPredicate(format: "type = Training")
        do {
            let events = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Event]
            return events
        } catch let error as NSError {
            print("error \(error)")
        }
        return nil
    }
    
}
