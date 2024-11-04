import SwiftUI
import MapKit

struct FilterSheetView: View {
    @Binding var isPresented: Bool
    
    @State private var selectedDay: String = "Today"
    @State private var collectionTime: ClosedRange<Double> = 0...24
    @State private var selectedFoodTypes: Set<String> = []
    
    let days = ["Today", "Tomorrow"]
    let foodTypes = ["Meal", "Bread", "Salad", "Groceries", "Other"]
    
    var body: some View {
        NavigationView {
            VStack {
                // Collection Day Picker
                Section(header: Text("Collection Day").bold()) {
                    Picker("Collection Day", selection: $selectedDay) {
                        ForEach(days, id: \.self) { day in
                            Text(day).tag(day)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                
                // Collection Time Range Slider with Two Handles
                Section(header: Text("Collection Time").bold()) {
                    VStack {
                        HStack {
                            Text(timeString(from: collectionTime.lowerBound))
                            Spacer()
                            Text(timeString(from: collectionTime.upperBound))
                        }
                        .padding(.horizontal)
                        
                        RangeSlider(range: $collectionTime, bounds: 0...24)
                            .frame(height: 50)
                            .padding(.horizontal)
                    }
                    .padding()
                }
                
                // Food Type Selection with Buttons
                Section(header: Text("Food Type").bold()) {
                    VStack {
                        ForEach(foodTypes, id: \.self) { foodType in
                            Button(action: {
                                toggleSelection(for: foodType)
                            }) {
                                HStack {
                                    Text(foodType)
                                    Spacer()
                                    if selectedFoodTypes.contains(foodType) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                // Clear All and Apply Buttons
                HStack {
                    Button(action: {
                        clearFilters()
                    }) {
                        Text("Clear All")
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        applyFilters()
                        isPresented = false
                    }) {
                        Text("Apply")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func clearFilters() {
        selectedDay = "Today"
        collectionTime = 0...24
        selectedFoodTypes.removeAll()
    }
    
    private func applyFilters() {
        // 필터링 적용 로직 추가
        print("Filters applied:")
        print("Selected Day: \(selectedDay)")
        print("Collection Time: \(collectionTime.lowerBound) to \(collectionTime.upperBound)")
        print("Selected Food Types: \(selectedFoodTypes)")
    }
    
    private func toggleSelection(for foodType: String) {
        if selectedFoodTypes.contains(foodType) {
            selectedFoodTypes.remove(foodType)
        } else {
            selectedFoodTypes.insert(foodType)
        }
    }
    
    private func timeString(from value: Double) -> String {
        let hours = Int(value)
        let minutes = Int((value - Double(hours)) * 60)
        return String(format: "%02d:%02d", hours, minutes)
    }
}

struct RangeSlider: View {
    @Binding var range: ClosedRange<Double>
    var bounds: ClosedRange<Double>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Track
                Rectangle()
                    .fill(Color(.systemGray4))
                    .frame(height: 4)
                    .cornerRadius(2)
                
                // Selected Range
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: CGFloat(range.upperBound - range.lowerBound) / CGFloat(bounds.upperBound - bounds.lowerBound) * geometry.size.width, height: 4)
                    .offset(x: CGFloat((range.lowerBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * geometry.size.width)
                    .cornerRadius(2)
                
                // Lower Thumb
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
                    .offset(x: CGFloat((range.lowerBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * geometry.size.width - 10)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newValue = min(max(Double(value.location.x / geometry.size.width) * (bounds.upperBound - bounds.lowerBound) + bounds.lowerBound, bounds.lowerBound), range.upperBound)
                                range = newValue...range.upperBound
                            }
                    )
                
                // Upper Thumb
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
                    .offset(x: CGFloat((range.upperBound - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * geometry.size.width - 10)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newValue = max(min(Double(value.location.x / geometry.size.width) * (bounds.upperBound - bounds.lowerBound) + bounds.lowerBound, bounds.upperBound), range.lowerBound)
                                range = range.lowerBound...newValue
                            }
                    )
            }
        }
    }
}
