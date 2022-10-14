//
//  ProfileView.swift
//  GI Profile
//
//  Created by Vyacheslav Pukhanov on 14/10/2022.
//

import SwiftUI

struct ProfileView: View {
    @Binding var profile: Profile
    
    var body: some View {
        Image(profile.namecard.filename)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .overlay {
                VStack {
                    HStack {
                        if let character = profile.character {
                                Image(character.filename)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 50)
                                    .background(
                                        Circle()
                                            .foregroundColor(/*@START_MENU_TOKEN@*/Color(red: 0.876, green: 0.56, blue: 0.364)/*@END_MENU_TOKEN@*/)
                                    )
                                    .clipShape(Circle())
                        }
                        if !profile.nickname.isEmpty {
                            Text(profile.nickname)
                                .font(.custom("HYWenHei", size: 20))
                                .foregroundColor(/*@START_MENU_TOKEN@*/Color(red: 0.909, green: 0.886, blue: 0.842)/*@END_MENU_TOKEN@*/)
                                .padding(.leading, 4)
                        }
                    }
                    if !profile.signature.isEmpty {
                        Text(profile.signature)
                            .font(.custom("HYWenHei", size: 16))
                            .foregroundColor(/*@START_MENU_TOKEN@*/Color(red: 0.909, green: 0.886, blue: 0.842)/*@END_MENU_TOKEN@*/)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
            }
            .ignoresSafeArea()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profile: .constant(
            Profile(
                character: Character.all[0],
                namecard: Namecard.all[0],
                nickname: "My Nickname",
                signature: "My signature is longer than it seems"
            )
        ))
    }
}
