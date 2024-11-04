import CoreLocation

struct Store: Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var imageName: String
    var discount: String
    var distance: String
    var distanceValue: Double // 숫자로 된 거리값
    var latitude: Double
    var longitude: Double
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

let mockStores = [
    Store(name: "Bakery", description: "Fresh baked goods", imageName: "bakery", discount: "50%", distance: "1.2km", distanceValue: 1.2, latitude: 37.7749, longitude: -122.4194),
    Store(name: "Sushi Place", description: "Discounted sushi rolls", imageName: "sushi", discount: "30%", distance: "0.8km", distanceValue: 0.8, latitude: 37.7750, longitude: -122.4183),
    Store(name: "Grocery Store", description: "Discount on fresh produce", imageName: "grocery", discount: "40%", distance: "2.0km", distanceValue: 2.0, latitude: 37.7760, longitude: -122.4172)
]
