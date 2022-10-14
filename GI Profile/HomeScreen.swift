//
//  HomeScreen.swift
//  GI Profile
//
//  Created by Vyacheslav Pukhanov on 13/10/2022.
//

import SwiftUI

struct HomeScreen: View {
    @Binding var profiles: [Profile]
    let saveAction: () -> Void
    
    @State private var newProfileData = Profile.Data()
    @State private var isPresentingNewProfile = false
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        List {
            ForEach(profiles) { profile in
                Text(profile.nickname)
            }
        }
        .navigationTitle("Profiles")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isPresentingNewProfile = true
                } label: {
                    Label("Create Profile", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $isPresentingNewProfile) {
            NavigationView {
                ProfileEditView(data: $newProfileData)
                    .navigationTitle("New Profile")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                let profile = Profile(data: newProfileData)
                                profiles.append(profile)
                                isPresentingNewProfile = false
                                newProfileData = Profile.Data()
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingNewProfile = false
                                newProfileData = Profile.Data()
                            }
                        }
                    }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}
