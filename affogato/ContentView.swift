import SwiftUI

struct ContentView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var postViewModel = PostViewModel()
    
    @State private var selectedTab = 0
    @State private var showingPostView = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    HomeView(viewModel: homeViewModel)
                        .tag(0)
                    
                    Color.clear
                        .tag(1)
                    
                    SavedView()
                        .tag(2)
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 60)
                }
                
                HStack(spacing: 0) {
                    TabBarButton(systemName: "sparkles", isSelected: selectedTab == 0)
                        .onTapGesture { selectedTab = 0 }
                    
                    TabBarButton(systemName: "plus", isSelected: selectedTab == 1)
                        .onTapGesture {
                            showingPostView = true
                            selectedTab = 0
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black)
                                .frame(width: 50, height: 32)
                        )
                    
                    TabBarButton(systemName: "heart.fill", isSelected: selectedTab == 2)
                        .onTapGesture { selectedTab = 2 }

                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                .padding(.horizontal)
            }
            .sheet(isPresented: $showingPostView) {
                PostView(viewModel: postViewModel)
            }
        }
    }
}
