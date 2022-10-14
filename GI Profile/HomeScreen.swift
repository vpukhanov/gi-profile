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
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        List {
            
        }
        .navigationTitle("Profiles")
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(profiles: .constant([]), saveAction: {})
    }
}
