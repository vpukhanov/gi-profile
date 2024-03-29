//
//  Character.swift
//  GI Profile
//
//  Created by Vyacheslav Pukhanov on 13/10/2022.
//

import Foundation

struct Character: Identifiable, Hashable, Codable {
    var id: String { name }
    
    let name: String
    let filename: String
    
    static var all: [Character] = {
        Bundle.main.decode([Character].self, from: "characters.json")
            .sorted(by: { $0.name < $1.name })
    }()
}
