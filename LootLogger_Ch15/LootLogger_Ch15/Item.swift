//
//  Item.swift
//  LootLogger_Ch15
//
//  Created by Ann Ubaka on 11/5/25.
//

import UIKit

class Item: Equatable, Codable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name &&
               lhs.serialNumber == rhs.serialNumber &&
               lhs.valueInDollars == rhs.valueInDollars &&
               lhs.dateCreated == rhs.dateCreated
    }
    
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    let dateCreated: Date
    let itemKey: String
    
    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self.name = name
        self.serialNumber = serialNumber
        self.valueInDollars = valueInDollars
        self.dateCreated = Date()
        self.itemKey = UUID().uuidString
    }
    
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny", "Dull", "Sparkly"]
            let nouns = ["Bear", "Spork", "Mac", "Trinket", "Widget"]
            
            let randomAdjective = adjectives.randomElement()!
            let randomNoun = nouns.randomElement()!
            let randomName = "\(randomAdjective) \(randomNoun)"
            
            let randomValue = Int.random(in: 0...100)
            let randomSerialNumber = UUID().uuidString.components(separatedBy: "-").first!
            
            self.init(name: randomName, serialNumber: randomSerialNumber, valueInDollars: randomValue)
        } else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }
}