import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State private var isSearchActive = false
    @State private var searchText: String = ""
    
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    struct Category: Identifiable {
        let id = UUID()
        let name: String
        let iconName: String
    }
    
    let categories = [
        Category(name: "Restaurants", iconName: "food-icon"),
        Category(name: "Nature", iconName: "tree-icon"),
        Category(name: "Shopping", iconName: "shopping-icon"),
        Category(name: "Nightlife", iconName: "party-icon"),
        Category(name: "Athletics", iconName: "snorkeling-icon"),
        Category(name: "Landmark", iconName: "pin-icon"),
        Category(name: "Culture", iconName: "fan-icon"),
        Category(name: "Events", iconName: "calendar-icon")
    ]
    
    var filteredSpecials: [Special] {
        if searchText.isEmpty {
            return viewModel.specials
        } else {
            return viewModel.specials.filter { $0.itemName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 16) {
                        Spacer().frame(height: 100)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Categories")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(categories) { category in
                                        VStack {
                                            ZStack {
                                                Circle()
                                                    .fill(Color(hex: "#F5F5F5"))
                                                    .frame(width: 60, height: 60)
                                                Image(category.iconName)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 60, height: 60)
                                                    .clipShape(Circle())
                                            }
                                            Text(category.name)
                                                .font(.caption)
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(filteredSpecials) { special in
                                NavigationLink(destination: ActivityDetailView(special: special)) {
                                    if let imageUrl = special.images.first { // Ensure there's at least one image
                                        StackedImagesCard(
                                            imageUrl: imageUrl,
                                            title: special.itemName,
                                            rating: special.rating,
                                            ratingCount: special.ratingCount
                                        )
                                    } else {
                                        // Fallback if no image is available
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 180, height: 240)
                                            .overlay(
                                                Text("No Image")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            )
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }

                        .padding(.horizontal, 10)
                    }
                    .padding(.bottom, 10)
                }
                
                HStack {
                    if isSearchActive {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                            Button(action: {
                                withAnimation {
                                    isSearchActive = false
                                    searchText = ""
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color(.systemGray6))
                        .cornerRadius(25)
                        .transition(.opacity)
                    } else {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "#D6EAF8"))
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Circle()
                                            .stroke(Color(hex: "#F5F5F5"), lineWidth: 1)
                                    )
                                Image("memoji")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            }
                            .padding(.leading, 16)

                            VStack(alignment: .center) {
                                Text("Lower East Side")
                                    .font(.subheadline)
                                    .fontWeight(.medium)

                                HStack {
                                    Image(systemName: "cloud.fill")
                                        .foregroundColor(.gray)
                                    Text("23°C")
                                        .font(.caption)
                                }
                            }
                            .frame(maxWidth: .infinity)

                            Button(action: {
                                withAnimation {
                                    isSearchActive = true
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: "#F5F5F5"))
                                        .frame(width: 40, height: 40)
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.black)
                                        .font(.title3)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 50)
                .padding(.bottom, 10)
                .padding(.horizontal)
                .background(Color.white)
                .zIndex(1)
            }
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                viewModel.fetchSpecials()
            }
        }
    }
}
