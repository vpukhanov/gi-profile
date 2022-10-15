//
//  ProfileEditView.swift
//  GI Profile
//
//  Created by Vyacheslav Pukhanov on 14/10/2022.
//

import SwiftUI

struct ProfileEditView: View {
    @Binding var data: Profile.Data
    
    var body: some View {
        Form {
            Section {
                Picker("Character", selection: $data.character) {
                    Text("None").tag(nil as Character?)
                    ForEach(Character.all) { character in
                        Text(character.name)
                            .tag(character as Character?)
                    }
                }
                
                // Pickers can technically display image + text, but it
                // breaks the label view of the collapsed picker. So I
                // display the selected character's picture separately
                if let character = data.character {
                    HStack {
                        Spacer()
                        Image(character.filename)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                        Spacer()
                    }
                }
            }
            
            Section {
                Picker("Namecard", selection: $data.namecard) {
                    ForEach(Namecard.all) { namecard in
                        Text(namecard.name)
                            .tag(namecard)
                    }
                }
                HStack {
                    Spacer()
                    Image(data.namecard.filename)
                        .resizable()
                        .scaledToFit()
                    Spacer()
                }
            }
            
            Section {
                TextField("Nickname", text: $data.nickname)
                TextField("Signature", text: $data.signature)
            }
        }
    }
}

