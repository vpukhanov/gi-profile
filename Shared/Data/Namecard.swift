//
//  Namecard.swift
//  GI Profile
//
//  Created by Vyacheslav Pukhanov on 13/10/2022.
//

import Foundation

struct Namecard: Identifiable, Hashable, Codable {
    var id: String { name }
    
    let name: String
    let filename: String
    
    static var all: [Namecard] = {
        Bundle.main.decode([Namecard].self, from: "namecards.json")
    }()
}
