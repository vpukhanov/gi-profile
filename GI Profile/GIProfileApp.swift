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
                        Task {
                            do {
                                try await ProfileStore.save(profiles: profileStore.profiles)
                            } catch {
                                fatalError(error.localizedDescription)
                            }
                        }
                    }
                )
            }
            .task {
                do {
                    profileStore.profiles = try await ProfileStore.load()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}
