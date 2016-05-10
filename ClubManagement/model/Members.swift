//
//  Members.swift
//  ClubManagement
//
//  Created by student5306 on 19/02/16.
//  Copyright © 2016 student5306. All rights reserved.
//

import Foundation

class Members {
    
    private lazy var membersByFirstLetter = [String:[Member]](minimumCapacity: 26)
    
    var firstLetters:[String] {
        get {
            var firstLetters = Array(membersByFirstLetter.keys) as [String]
            
            firstLetters.sortInPlace { (character1, character2) -> Bool in
                return character1<character2
            }
            
            return firstLetters
        }
    }
    
    init() {
        if let members = DBManager.sharedInstance.allMember() {
            for var member in members {
                addMember(member)
            }
        }
    }
    
    func getMember(section:Int, row:Int) -> Member {
        
        let firstLetter = firstLetters[section]
        
        return self[firstLetter][row]
    }
    
    func getIndexForSectionWithLetter(letter:String) -> Int {
        return Int(letter.unicodeScalars[letter.unicodeScalars.startIndex].value - 65)
    }
    
    //MARK: - Add/Remove methods
    
    func addMember(member:Member) {
        if let firstCharacter = member.lastname!.characters.first {
            let firstLetter = String(firstCharacter)
            var members = self[firstLetter]
            members.append(member)
            membersByFirstLetter[firstLetter] = members
        }
    }
    
    func removeMember(section:Int, row:Int) {
        let firstLetter = firstLetters[section]
        DBManager.sharedInstance.removeMember(self[firstLetter][row])
        membersByFirstLetter[firstLetters[section]]?.removeAtIndex(row)
    }
    
    //MARK: - Subscripts
    
    subscript(firstLetter:String) -> [Member] {
        get {
            if let members = membersByFirstLetter[firstLetter] {
                return members
            }
            membersByFirstLetter[firstLetter] = [Member]()
            
            return membersByFirstLetter[firstLetter]!
        }
    }
    
    
    subscript(firstLetter:String, index:Int) -> Member {
        return self[firstLetter][index]
    }
    
    subscript(letterIndex:Int, memberIndex:Int) -> Member {
        return membersByFirstLetter[firstLetters[letterIndex]]![memberIndex]
    }
}