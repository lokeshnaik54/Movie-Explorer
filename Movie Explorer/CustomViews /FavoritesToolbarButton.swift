//
//  FavouriteToolBarBtn.swift
//  Movie Explorer
//
//  Created by Gopal Kumar on 17/11/26.
//

import SwiftUI

struct FavoritesToolbarButton: View {
    
    @EnvironmentObject var favoriteViewModel: FavoriteViewModel
    
    var body: some View {
        NavigationLink {
            FavouriteView()
        } label: {
            Image(
                systemName: "heart")
            .foregroundColor(Color.red)
            
        }
    }
}

extension View {
    func favoritesToolbarButton() -> some View {
        toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                FavoritesToolbarButton()
            }
        }
    }
}

struct FavoritesToolbarButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FavoritesToolbarButton()
                .environmentObject(FavoriteViewModel())
        }
    }
}
