import SwiftUI

class FavoritesManager: ObservableObject {
    @Published var favoriteStoreIDs: Set<UUID> = [] {
        didSet {
            saveFavorites()
        }
    }
    
    init() {
        loadFavorites()
    }
    
    func toggleFavorite(store: Store) {
        if favoriteStoreIDs.contains(store.id) {
            favoriteStoreIDs.remove(store.id)
        } else {
            favoriteStoreIDs.insert(store.id)
        }
    }
    
    func isFavorite(store: Store) -> Bool {
        favoriteStoreIDs.contains(store.id)
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favoriteStores"),
           let savedStoreIDs = try? JSONDecoder().decode(Set<UUID>.self, from: data) {
            favoriteStoreIDs = savedStoreIDs
        }
    }
    
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoriteStoreIDs) {
            UserDefaults.standard.set(data, forKey: "favoriteStores")
        }
    }
}
