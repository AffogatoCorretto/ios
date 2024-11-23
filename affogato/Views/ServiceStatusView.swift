import SwiftUI

struct ServiceStatusView: View {
    @StateObject private var viewModel = SpecialsViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Button("Fetch Specials") {
                    viewModel.fetchSpecials()
                }
                .padding()

                if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    List(viewModel.specials) { special in
                        VStack(alignment: .leading) {
                            Text(special.itemName)
                                .font(.headline)
                            Text("Rating: \(special.rating, specifier: "%.1f") (\(special.ratingCount) reviews)")
                                .font(.subheadline)
                            Text("Distance: \(special.distance, specifier: "%.2f") km")
                                .font(.subheadline)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Specials")
            .padding()
        }
    }
}
