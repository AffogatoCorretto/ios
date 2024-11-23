import SwiftUI

struct StoryProgressBar: View {
    let totalStories: Int
    let currentIndex: Int
    let progress: CGFloat
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalStories, id: \.self) { index in
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .foregroundColor(.white.opacity(0.3))
                            .cornerRadius(2)
                        
                        Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(2)
                            .frame(width: index == currentIndex
                                  ? geometry.size.width * progress
                                  : index < currentIndex ? geometry.size.width : 0)
                    }
                }
                .frame(height: 2)
            }
        }
        .padding(.horizontal)
    }
}


struct FullScreenImageView: View {
    let special: Special
    @Binding var isPresented: Bool
    @State private var currentIndex = 0
    @State private var progress: CGFloat = 0
    @State private var timer: Timer?
    @State private var isLoved: Bool = false
    @State private var isSharing: Bool = false
    
    // Constants
    private let storyDuration: TimeInterval = 5.0
    private let progressUpdateInterval: TimeInterval = 0.1
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                // Story content
                Group {
                    if currentIndex < special.images.count,
                       let url = URL(string: special.images[currentIndex]) {
                        RemoteImageView(url: url)
                            .edgesIgnoringSafeArea(.all) // Make sure it goes edge to edge
                    }
                }
                
                // Touch areas for navigation
                HStack(spacing: 0) {
                    // Left side tap area
                    Rectangle()
                        .foregroundColor(.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            print("Tapped left, current index: \(currentIndex)")  // Debug print
                            if currentIndex > 0 {
                                currentIndex -= 1
                                resetProgress()
                            }
                        }
                        .frame(width: geometry.size.width / 2)
                    
                    // Right side tap area
                    Rectangle()
                        .foregroundColor(.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            print("Tapped right, current index: \(currentIndex), total images: \(special.images.count)")  // Debug print
                            if currentIndex < special.images.count - 1 {
                                currentIndex += 1
                                resetProgress()
                            }
                        }
                        .frame(width: geometry.size.width / 2)
                }
                
                // Rest of your overlay content...
                VStack {
                    // Progress bars
                    StoryProgressBar(
                        totalStories: special.images.count,
                        currentIndex: currentIndex,
                        progress: progress
                    )
                    .padding(.top, geometry.safeAreaInsets.top + 10)
                    
                    Spacer()
                    
                    // Bottom info overlay
                    HStack {
                        VStack(alignment: .leading) {
                            Text(special.itemName)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("\(special.distance, specifier: "%.1f") Miles away from you")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            StarRating(
                                rating: special.rating,
                                fontSize: 14,
                                ratingCount: special.ratingCount,
                                color: .yellow
                            )
                        }
                        Spacer()
                        VStack(spacing: 20) {
                            Button(action: {
                                isSharing = true
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.white)
                                    .font(.title)
                            }
                            Button(action: {
                                isLoved.toggle()
                            }) {
                                Image(systemName: isLoved ? "heart.fill" : "heart")
                                    .foregroundColor(isLoved ? .red : .white)
                                    .font(.title)
                            }
                            Button(action: {
                                isPresented = false
                            }) {
                                Image(systemName: "arrow.down.right.and.arrow.up.left")
                                    .foregroundColor(.white)
                                    .font(.title)
                            }
                        }
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .black.opacity(0.5)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
            .sheet(isPresented: $isSharing) {
                if currentIndex < special.images.count {
                    ActivityViewController(activityItems: [special.images[currentIndex]])
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .overlay(
            Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .clipShape(Circle())
            }
            .padding(),
            alignment: .topTrailing
        )
        .onAppear(perform: startTimer)
        .onDisappear(perform: stopTimer)
    }
    
    private func preloadNextImage() {
        let nextIndex = currentIndex + 1
        if nextIndex < special.images.count,
           let nextUrl = URL(string: special.images[nextIndex]) {
            URLSession.shared.dataTask(with: nextUrl) { data, response, error in
                if let data = data, error == nil {
                    ImageCache.shared.set(data, for: nextUrl)
                }
            }.resume()
        }
    }
    
    private func startTimer() {
        stopTimer()
        preloadNextImage() // Preload next image
        timer = Timer.scheduledTimer(withTimeInterval: progressUpdateInterval, repeats: true) { _ in
            if progress < 1.0 {
                progress += CGFloat(progressUpdateInterval / storyDuration)
            } else {
                if currentIndex < special.images.count - 1 {
                    currentIndex += 1
                    resetProgress()
                    preloadNextImage() // Preload next image after advancing
                } else {
                    stopTimer()
                    isPresented = false
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func resetProgress() {
        progress = 0
        stopTimer()
        startTimer()
    }
}
// Safe array access extension
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
