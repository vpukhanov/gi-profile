//
//  IntentHandler.swift
//  IntentsExtension
//
//  Created by Vyacheslav Pukhanov on 14/10/2022.
//

import Intents

class IntentHandler: INExtension, ConfigurationIntentHandling {
    func resolveProfile(for intent: ConfigurationIntent, with completion: @escaping (ConfiguredProfileResolutionResult) -> Void) {
        if let profile = intent.profile {
            completion(.success(with: profile))
        } else {
            completion(.confirmationRequired(with: intent.profile))
        }
    }
    
    func provideProfileOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<ConfiguredProfile>?, Error?) -> Void) {
        ProfileStore.load { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let profiles):
                let configuredProfiles = profiles.map { ConfiguredProfile(identifier: $0.id.uuidString, display: $0.nickname) }
                completion(INObjectCollection(items: configuredProfiles), nil)
            }
        }
    }
}
