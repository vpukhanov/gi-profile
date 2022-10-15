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
    
    @State private var profileData = Profile.Data()
    
    @State private var isCreatingProfile = false
    
    @State private var isEditingProfile = false
    @State private var editingProfileId: UUID = UUID()
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        List {
            ForEach($profiles) { $profile in
                Button {
                    profileData = profile.data
                    editingProfileId = profile.id
                    isEditingProfile = true
                } label: {
                    ProfileView(profile: $profile)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .buttonStyle(.plain)
            }
            .onDelete { profiles.remove(atOffsets: $0) }
        }
        .navigationTitle("Profiles")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isCreatingProfile = true
                } label: {
                    Label("Create Profile", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $isCreatingProfile, onDismiss: { profileData = Profile.Data() }) {
            NavigationView {
                ProfileEditView(data: $profileData)
                    .navigationTitle("New Profile")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                let profile = Profile(data: profileData)
                                profiles.append(profile)
                                isCreatingProfile = false
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isCreatingProfile = false
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $isEditingProfile, onDismiss: { profileData = Profile.Data() }) {
            NavigationView {
                ProfileEditView(data: $profileData)
                    .navigationTitle("Edit Profile")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                let idx = profiles.firstIndex { $0.id == editingProfileId }
                                profiles[idx!].update(from: profileData)
                                isEditingProfile = false
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isEditingProfile = false
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
