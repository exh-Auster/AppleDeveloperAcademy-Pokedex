//
//  UserImageView.swift
//  Pokedex
//
//  Created by Felipe Ribeiro on 20/03/25.
//

import SwiftUI

struct UserImageView: View {
    var selectedUser: User
    
    var body: some View {
        ZStack {
            if selectedUser == .ash {
                Image("ash")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 32, height: 32)
                
                Text(String(selectedUser.rawValue.prefix(1)).uppercased())
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    UserImageView(selectedUser: .ash)
}
