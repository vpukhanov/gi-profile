//
//  Profile.swift
//  GI Profile
//
//  Created by Vyacheslav Pukhanov on 14/10/2022.
//

import Foundation

struct Profile: Codable {
    let character: Character
    let namecard: Namecard
    let nickname: String
    let signature: String
}
