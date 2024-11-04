import SwiftUI

struct FavoriteButton: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    var store: Store
    
    var body: some View {
        Button(action: {
            favoritesManager.toggleFavorite(store: store)
        }) {
            Image(systemName: favoritesManager.isFavorite(store: store) ? "heart.fill" : "heart")
                .foregroundColor(favoritesManager.isFavorite(store: store) ? .red : .gray)
                .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HomeView: View {
    @State private var searchText = ""
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var nearbyStores: [Store] = mockStores
    var favoriteStores: [Store] {
        mockStores.filter { favoritesManager.isFavorite(store: $0) }
    }
    var recommendedStores: [Store] = mockStores.filter { $0.name.contains("Sushi") }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.top)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // 가까운 음식점 섹션
                        Text("Nearby Restaurants")
                            .font(.title2)
                            .bold()
                            .padding(.leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(nearbyStores) { store in
                                    NavigationLink(destination: StoreDetailView(store: store)) {
                                        StoreCard(store: store)
                                            .frame(width: 300)
                                            .overlay(FavoriteButton(store: store))
                                    }
                                }
                            }
                            .padding([.leading, .trailing])
                        }
                        
                        // 즐겨찾기 섹션
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
                        
                        // 추천 음식점 섹션
                        Text("Recommended for You")
                            .font(.title2)
                            .bold()
                            .padding(.leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(recommendedStores) { store in
                                    NavigationLink(destination: StoreDetailView(store: store)) {
                                        StoreCard(store: store)
                                            .frame(width: 300)
                                            .overlay(FavoriteButton(store: store))
                                    }
                                }
                            }
                            .padding([.leading, .trailing])
                        }
                        
                    }
                    .padding(.top)
                }
            }
            .background(Color(.systemBackground))
        }
    }
}

struct StoreCard: View {
    var store: Store
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                Image(store.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(10)
                
                FavoriteButton(store: store)
                    .padding([.top, .trailing], 10)
            }
            
            Text(store.name)
                .font(.headline)
                .padding(.top, 5)
            
            Text(store.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .padding(.bottom, 5)
            
            HStack {
                Text(store.discount)
                    .font(.subheadline)
                    .foregroundColor(.green)
                Spacer()
                Text(store.distance)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    // 추가적인 행동이 필요하다면 여기에서 처리
                }
            
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .padding(.trailing, 10)
                }
            }
        }
    }
}
