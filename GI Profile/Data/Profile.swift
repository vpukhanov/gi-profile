//
//  Profile.swift
//  GI Profile
//
//  Created by Vyacheslav Pukhanov on 14/10/2022.
//

import Foundation

struct Profile: Codable {
    let id: UUID
    var character: Character?
    var namecard: Namecard
    var nickname: String
    var signature: String
    
    init(id: UUID = UUID(), character: Character? = nil, namecard: Namecard, nickname: String = "", signature: String = "") {
        self.id = id
        self.character = character
        self.namecard = namecard
        self.nickname = nickname
        self.signature = signature
    }
}
