import SwiftUI
import MapKit
import CoreLocation

struct IdentifiableLocation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct LocationPickerView: View {
    @Binding var selectedLocation: CLLocationCoordinate2D
    @Binding var selectedDistance: Double
    @StateObject private var locationManager = LocationManager()
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    var onShowResults: () -> Void
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: [IdentifiableLocation(coordinate: selectedLocation)]) { location in
                MapPin(coordinate: location.coordinate, tint: .blue)
            }
            .edgesIgnoringSafeArea(.all)
            .onChange(of: region.center) { newCenter in
                selectedLocation = newCenter
            }
            
            Slider(value: $selectedDistance, in: 1...20, step: 1)
                .padding()
                .overlay(Text("Distance: \(Int(selectedDistance)) km").padding(), alignment: .topTrailing)
            
            HStack {
                Button("Use My Current Location") {
                    if let location = locationManager.location {
                        selectedLocation = location.coordinate
                        region.center = location.coordinate
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Show Results") {
                    onShowResults()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        
        .overlay(
            Circle()
                .strokeBorder(Color.blue.opacity(0.5), lineWidth: 2)
                .background(Circle().fill(Color.blue.opacity(0.2)))
                .frame(width: CGFloat(selectedDistance) * 20, height: CGFloat(selectedDistance) * 20)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        )
        .overlay(
            Circle()
                .strokeBorder(Color.clear, lineWidth: 0)
                .background(Circle().fill(Color.black.opacity(0.3)))
                .frame(width: CGFloat(selectedDistance) * 40, height: CGFloat(selectedDistance) * 40)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        )
        .edgesIgnoringSafeArea(.all)
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation? = nil
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
        }
    }
}
