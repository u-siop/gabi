import SwiftUI
import MapKit

struct SearchView: View {
    @State private var selectedTab = 0
    @State private var isFilterSheetPresented = false
    @State private var isLocationPickerPresented = false
    @State private var selectedLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    @State private var selectedDistance: Double = 10
    @State private var filteredStores: [Store] = mockStores
    
    var body: some View {
        NavigationView {
            VStack {
                // 상단 고정된 검색 바와 버튼들
                HStack {
                    SearchBar(text: .constant(""))
                    Button(action: {
                        isFilterSheetPresented.toggle()
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .font(.title2)
                            .padding(.horizontal)
                    }
                    
                    Button(action: {
                        isLocationPickerPresented.toggle()
                    }) {
                        Image(systemName: "location.circle")
                            .font(.title2)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
                .background(Color(.systemBackground))
                
                Picker("Search Mode", selection: $selectedTab) {
                    Text("List").tag(0)
                    Text("Map").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedTab == 0 {
                    SearchListView(filteredStores: $filteredStores)
                } else {
                    VStack {
                        SearchMapView(filteredStores: $filteredStores, selectedLocation: $selectedLocation, selectedDistance: $selectedDistance)
                        Button("Select Location") {
                            isLocationPickerPresented.toggle()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            .sheet(isPresented: $isFilterSheetPresented) {
                FilterSheetView(isPresented: $isFilterSheetPresented)
            }
            .sheet(isPresented: $isLocationPickerPresented) {
                LocationPickerView(
                    selectedLocation: $selectedLocation,
                    selectedDistance: $selectedDistance,
                    onShowResults: {
                        filterStores()
                        isLocationPickerPresented = false
                    })
            }
        }
    }
    
    private func filterStores() {
        // 필터링 로직 - 선택된 위치와 거리 기준으로 상점 목록 필터링
        filteredStores = mockStores.filter { store in
            let storeLocation = CLLocation(latitude: store.latitude, longitude: store.longitude)
            let selectedLocationCL = CLLocation(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
            let distance = storeLocation.distance(from: selectedLocationCL) / 1000.0 // km 단위로 변환
            
            return distance <= selectedDistance
        }
    }
}

struct StoreRowMinimal: View {
    var store: Store
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(store.name)
                    .font(.headline)
                Text(store.distance)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 10)
    }
}

struct SearchListView: View {
    @Binding var filteredStores: [Store]
    
    var body: some View {
        List(filteredStores) { store in
            NavigationLink(destination: StoreDetailView(store: store)) {
                StoreRowMinimal(store: store)
            }
        }
    }
}

struct SearchMapView: View {
    @Binding var filteredStores: [Store]
    @Binding var selectedLocation: CLLocationCoordinate2D
    @Binding var selectedDistance: Double
    
    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(
            center: selectedLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )), annotationItems: filteredStores.map { IdentifiableLocation(coordinate: $0.locationCoordinate) }) { location in
            MapMarker(coordinate: location.coordinate, tint: .red)
        }
    }
}
