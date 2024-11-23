import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State private var isFullScreenPresented = false
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Full-width image at the top with the first special
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
                    
                    // Grid with the rest of the specials
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.specials.dropFirst()) { special in
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
                    .padding(.vertical, 10)
                }
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
