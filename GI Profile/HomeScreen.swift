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
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}
