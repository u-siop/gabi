import SwiftUI

struct StoreDetailView: View {
    var store: Store
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(store.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
            
            Text(store.name)
                .font(.largeTitle)
                .bold()
                .padding([.top, .bottom], 10)
            
            Text(store.description)
                .font(.body)
                .padding(.bottom, 10)
            
            HStack {
                Text("Discount: \(store.discount)")
                    .font(.headline)
                    .foregroundColor(.green)
                Spacer()
                Text("Distance: \(store.distance)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 20)
            
            Spacer()
        }
        .padding()
        .navigationTitle(store.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
