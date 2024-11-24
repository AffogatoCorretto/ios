import SwiftUI

struct ContentView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var selectedTab = 0
    @State private var showingSearchPopup = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Main Tab View
                TabView(selection: $selectedTab) {
                    HomeView(viewModel: homeViewModel)
                        .tag(0)
                    
                    Color.clear // Placeholder for middle tab content
                        .tag(1)
                    
                    SavedView()
                        .tag(2)
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 90) // Prevent content from being hidden by the navbar
                }
                
                // Floating Navbar
                HStack(spacing: 0) {
                    // Home Tab Button
                    TabBarButton(systemName: "sparkles", isSelected: selectedTab == 0)
                        .onTapGesture { selectedTab = 0 }
                    
                    Spacer()
                    
                    // Search Button
                    // Search Button
                    TabBarButton(systemName: "magnifyingglass", isSelected: false, foregroundColor: .white)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showingSearchPopup = true
                            }
                        }
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 60, height: 60)
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        )
                        .offset(y: -30) // Lift the search button above the navbar

                    
                    Spacer()
                    
                    // Saved Tab Button
                    TabBarButton(systemName: "heart.fill", isSelected: selectedTab == 2)
                        .onTapGesture { selectedTab = 2 }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)

                .padding(.horizontal)
                .padding(.bottom, 20) // Lift navbar off the screen bottom
                
                // Search Popup Overlay
                if showingSearchPopup {
                    Color.black.opacity(0.4) // Semi-transparent background
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showingSearchPopup = false
                            }
                        }
                    
                    SearchPopupView(showingSearchPopup: $showingSearchPopup)
                        .transition(.move(edge: .bottom))
                        .animation(.spring())
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
