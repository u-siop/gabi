import Foundation

struct Store: Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var imageName: String
    var availableItems: Int
}

struct Reservation: Identifiable {
    var id = UUID()
    var store: Store
    var date: Date
}

let sampleStores = [
    Store(name: "Ggabi Cafe", description: "Cozy and calm cafe", imageName: "cafe", availableItems: 5),
    Store(name: "Ggabi Bakery", description: "Freshly baked bread", imageName: "bakery", availableItems: 2),
    Store(name: "Ggabi Sushi", description: "Delicious sushi rolls", imageName: "sushi", availableItems: 3)
]
