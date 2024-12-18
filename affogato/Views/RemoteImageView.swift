//
//  RemoteImageView.swift
//  affogato
//
//  Created by Kevin ahmad on 30/10/24.
//

import SwiftUI

class ImageCache {
    static let shared = ImageCache()
    private var cache: [URL: Data] = [:]
    
    func get(_ url: URL) -> Data? {
        return cache[url]
    }
    
    func set(_ data: Data, for url: URL) {
        cache[url] = data
    }
}

struct RemoteImageView: View {
    let url: URL?
    var contentMode: ContentMode = .fill
    var allowTapGesture: Bool = false
    
    @State private var imageData: Data?
    @State private var retryCount = 0
    @State private var isLoading = false
    @State private var currentTask: URLSessionDataTask?
    private let maxRetries = 3
    private let fallbackImages = ["french-cuisine", "ikebana", "jewelry", "perfume", "pottery"]
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                if let data = imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                } else {
                    ZStack {
                        Color.black
                        if isLoading {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }
        .onAppear {
            loadImage()
        }
        .onChange(of: url) { _ in
            currentTask?.cancel()
            withAnimation {
                imageData = nil
                retryCount = 0
                isLoading = true
            }
            loadImage()
        }
        .if(allowTapGesture) { view in
            view.onTapGesture(perform: loadImage)
        }
    }
    
    private func loadImage() {
        guard let url = url else { return }
        
        if let cachedData = ImageCache.shared.get(url) {
            imageData = cachedData
            isLoading = false
            return
        }
        
        isLoading = true
        currentTask?.cancel()
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                let isCancelled = (error as? URLError)?.code == .cancelled
                
                if error == nil, let data = data {
                    ImageCache.shared.set(data, for: url)
                    withAnimation(.easeInOut(duration: 0.2)) {
                        self.imageData = data
                        self.isLoading = false
                    }
                } else if retryCount < maxRetries && !isCancelled {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        retryCount += 1
                        loadImage()
                    }
                } else {
                    self.isLoading = false
                }
            }
        }
        
        currentTask = task
        task.resume()
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
