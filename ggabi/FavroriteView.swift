import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var favoriteManager: FavoritesManager
    
    var favoriteStores: [Store] {
        mockStores.filter { favoriteManager.isFavorite(store: $0) }
    }
    
    var body: some View {
        NavigationView {
            Text("Favorite Restaurants")
                .font(.title2)
                .bold()
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(favoriteStores) { store in
                        NavigationLink(destination: StoreDetailView(store: store)) {
                            StoreCard(store: store)
                                .frame(width: 300)
                                .overlay(FavoriteButton(store: store))
                        }
                    }
                }
                .padding([.leading, .trailing])
            }
            
            .navigationTitle("Favorite")
        }
    }
}
