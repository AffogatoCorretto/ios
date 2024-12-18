import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State private var searchText: String = ""
    @State private var showingNotificationPage = false

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
        Category(name: "Culture", iconName: "fan-icon"),
        Category(name: "Nightlife", iconName: "party-icon"),
        Category(name: "Athletics", iconName: "snorkeling-icon"),
        Category(name: "Landmark", iconName: "pin-icon"),
        Category(name: "Shopping", iconName: "shopping-icon"),
        Category(name: "Events", iconName: "calendar-icon")
    ]
    
    var displayedItems: [Special] {
        if viewModel.isSearching && !viewModel.searchText.isEmpty {
            return viewModel.searchResults
        } else if searchText.isEmpty {
            return viewModel.specials
        } else {
            return viewModel.filteredSpecials
        }
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 16) {
                        Spacer().frame(height: 100)

                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search for cool places", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(.primary)
                                .accentColor(.purple)
                                .onSubmit {
                                    viewModel.searchText = searchText
                                    viewModel.performSearch()
                                }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color(.systemGray6))
                        )
                        .padding(.horizontal)
                        
                        // Categories Section
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Categories")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                Spacer()
                            }
                            
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
                        
                        HStack {
                            Text("Explore the unexpected ✨")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            Spacer()
                        }

                        // If searching and loading, show a loading indicator
                        if viewModel.isLoading && viewModel.isSearching {
                            VStack(spacing: 16) {
                                ActivityIndicator(isAnimating: .constant(true), style: .large)
                                Text("Loading...")
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 50)
                        } else {
                            // Show results
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach(displayedItems) { special in
                                    NavigationLink(destination: ActivityDetailView(special: special)) {
                                        if let imageUrl = special.images.first {
                                            StackedImagesCard(
                                                imageUrl: imageUrl,
                                                title: special.itemName,
                                                rating: special.rating,
                                                ratingCount: special.ratingCount
                                            )
                                        } else {
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

//                        .padding(.bottom, 200)
                    }
                }
                .edgesIgnoringSafeArea([.top, .bottom])
                .sheet(isPresented: $showingNotificationPage) {
                    NotificationView()
                }

                // Header
                HStack {
                    // User icon
                    NavigationLink(destination: ProfileView()) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#D6EAF8"))
                                .frame(width: 50, height: 50)
                            Image("memoji")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }
                    }
                    
                    // Location and weather
                    VStack(alignment: .center) {
                        Text("Greenwich Village")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        HStack {
                            Image(systemName: "cloud.fill")
                                .foregroundColor(.gray)
                            Text("10°C")
                                .font(.caption)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Notification icon
                    Button(action: {
                        showingNotificationPage = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#F5F5F5"))
                                .frame(width: 40, height: 40)
                            Image(systemName: "bell.fill")
                                .foregroundColor(.black)
                                .font(.title3)
                            
                            // Optional notification badge
                            if true {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                                    .offset(x: 12, y: -12)
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

            // Global loading overlay
            if viewModel.isLoading && !viewModel.isSearching {
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 16) {
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                        Text("Loading...")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(10)
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
}
