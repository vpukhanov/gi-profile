//
//  GI_ProfileApp.swift
//  GI Profile
//
//  Created by Vyacheslav Pukhanov on 13/10/2022.
//

import SwiftUI

@main
struct GIProfileApp: App {
    @StateObject private var profileStore = ProfileStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeScreen(
                    profiles: $profileStore.profiles,
                    saveAction: {
                        ProfileStore.save(profiles: profileStore.profiles) { result in
                            if case .failure(let error) = result {
                                fatalError(error.localizedDescription)
                            }
                        }
                    }
                )
            }
            .onAppear {
                ProfileStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let profiles):
                        profileStore.profiles = profiles
                    }
                }
            }
        }
    }
}
