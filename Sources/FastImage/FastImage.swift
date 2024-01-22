//
//  FastImage.swift
//  FastImage
//
//  Created by Nick Brandes on 1/19/24.
//

import SwiftUI

@available(iOS 16.0, *)
public struct FastImage<Placeholder: View>: View {
    
    @State var image: UIImage?
    var url: URL
    var progressWidth: CGFloat
    var progressHeight: CGFloat
    var placeholder: Placeholder?
    var cache: Bool
    var aspectRatio: ContentMode
    
    public var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: aspectRatio)
                    .frame(width: .infinity)
            } else {
                if placeholder != nil {
                    placeholder
                } else {
                    ProgressView()
                        .frame(width: progressWidth, height: progressHeight)
                }
            }
        }
        .onAppear() {
            dowloadImageForURL()
        }
    }
    
    public init(_ url: URL,
                aspectRatio: ContentMode = .fit,
                progressWidth: CGFloat = 300,
                progressHeight: CGFloat = 200,
                cache: Bool = true,
                @ViewBuilder placeholder: @escaping () -> Placeholder? = { nil }) {
        self.url = url
        self.aspectRatio = aspectRatio
        self.progressWidth = progressWidth
        self.progressHeight = progressHeight
        self.placeholder = placeholder()
        self.cache = cache
    }
    
    public init?(_ url: URL,
                aspectRatio: ContentMode = .fit,
                progressWidth: CGFloat = 300,
                progressHeight: CGFloat = 200,
                cache: Bool = true) where Placeholder == AnyView {
        self.url = url
        self.aspectRatio = aspectRatio
        self.progressWidth = progressWidth
        self.progressHeight = progressHeight
        self.cache = cache
    }
    
    private func dowloadImageForURL() {
        Task {
            do {
                image = try await FastLoader().image(from: url, cacheEnabled: cache)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

@available(iOS 16.0, *)
public class FastLoader {
    
    private let imageCache = FastCache()

    func image(from url: URL, cacheEnabled: Bool = true) async throws -> UIImage {
        if cacheEnabled {
            if let cachedImage = imageCache.image(for: url) {
                return cachedImage
            }
        }
        
        let data = try await downloadImageData(from: url)
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "InvalidImageData", code: 0, userInfo: nil)
        }

        imageCache.cacheImage(image, for: url)
        return image
    }
    
    func downloadImageData(from url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}

private class FastCache {
    private var cache: [URL: UIImage] = [:]

    func cacheImage(_ image: UIImage, for url: URL) {
        cache[url] = image
    }

    func image(for url: URL) -> UIImage? {
        return cache[url]
    }
}
