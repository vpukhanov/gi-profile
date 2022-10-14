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

extension Profile {
    struct Data {
        var character: Character? = nil
        var namecard = Namecard.all[0]
        var nickname = ""
        var signature = ""
    }
    
    var data: Data {
        Data(character: character, namecard: namecard, nickname: nickname, signature: signature)
    }
}
