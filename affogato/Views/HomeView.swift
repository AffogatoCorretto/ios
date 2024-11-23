import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State private var isFullScreenPresented = false
    @State private var searchText: String = ""
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    // Mock data for categories
    struct Category: Identifiable {
        let id = UUID()
        let name: String
        let iconName: String
    }
    
    let categories = [
        Category(name: "Hotels", iconName: "bed.double.fill"),
        Category(name: "Restaurants", iconName: "fork.knife"),
        Category(name: "Attractions", iconName: "star.fill"),
        Category(name: "Shopping", iconName: "bag.fill"),
        Category(name: "Nightlife", iconName: "moon.stars.fill")
    ]
    
    // Computed property for filtered specials based on search text
    var filteredSpecials: [Special] {
        if searchText.isEmpty {
            return viewModel.specials
        } else {
            return viewModel.specials.filter { $0.itemName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Title at the top
                    Text("New experience awaits")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 50)
                    
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(categories) { category in
                                VStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 60, height: 60)
                                        Image(systemName: category.iconName)
                                            .foregroundColor(.white)
                                            .font(.title)
                                    }
                                    Text(category.name)
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Commented out the first big image
                    /*
                    if let firstSpecial = viewModel.specials.first {
                        RemoteImageView(url: URL(string: firstSpecial.images.first ?? ""))
                            .frame(height: 400)
                            .aspectRatio(contentMode: .fill)
                            .overlay(
                                VStack {
                                    Spacer()
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(firstSpecial.itemName)
                                                .font(.title)
                                                .fontWeight(.bold)
                                            Text("\(firstSpecial.distance, specifier: "%.1f") Miles away from you")
                                                .font(.subheadline)
                                            StarRating(
                                                rating: firstSpecial.rating,
                                                fontSize: 14,
                                                ratingCount: firstSpecial.ratingCount,
                                                color: .yellow
                                            )
                                        }
                                        Spacer()
                                        Button(action: {
                                            isFullScreenPresented = true
                                        }) {
                                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                                .font(.title)
                                                .foregroundColor(.white)
                                                .padding(10)
                                                .background(Color.black.opacity(0.5))
                                                .clipShape(Circle())
                                        }
                                    }
                                    .padding()
                                }
                                .foregroundColor(.white)
                            )
                            .clipped()
                    }
                    */
                    
                    // Grid with the specials
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(filteredSpecials) { special in
                            NavigationLink(destination: ActivityDetailView(special: special)) {
                                VStack(alignment: .leading) {
                                    if !special.images.isEmpty {
                                        StackedImagesCard(images: special.images)
                                            .frame(height: 150)
                                    } else {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.gray)
                                            .frame(height: 150)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(special.itemName)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        
                                        StarRating(
                                            rating: special.rating,
                                            fontSize: 12,
                                            ratingCount: special.ratingCount,
                                            color: .yellow
                                        )
                                    }
                                    .padding([.leading, .top, .bottom], 5)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .padding(.bottom, 10)
            }
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $isFullScreenPresented) {
                if let firstSpecial = viewModel.specials.first {
                    FullScreenImageView(special: firstSpecial, isPresented: $isFullScreenPresented)
                }
            }
            .onAppear {
                viewModel.fetchSpecials() // Automatically fetch when the view appears
            }
        }
    }
}
