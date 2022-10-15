//
//  GI_ProfileApp.swift
//  GI Profile
//
//  Created by Vyacheslav Pukhanov on 13/10/2022.
//

import SwiftUI
import TelemetryClient
import WidgetKit

@main
struct GIProfileApp: App {
    @StateObject private var profileStore = ProfileStore()
    
    init() {
        let configuration = TelemetryManagerConfiguration(appID: "CEFA38F6-9411-4DF9-B1C9-083F4EF9673D")
        TelemetryManager.initialize(with: configuration)
        
        TelemetryManager.send("applicationDidFinishLaunching")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeScreen(
                    profiles: $profileStore.profiles,
                    saveAction: {
                        Task {
                            do {
                                try await ProfileStore.save(profiles: profileStore.profiles)
                                WidgetCenter.shared.reloadAllTimelines()
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
