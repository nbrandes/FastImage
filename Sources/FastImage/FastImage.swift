//
//  FastImage.swift
//  FastImage
//
//  Created by Nick Brandes on 1/19/24.
//

import SwiftUI

@available(iOS 16.0, *)
public struct FastImage: View {
    @State var image: UIImage?
    var url: URL
    var progressWidth: CGFloat
    var progressHeight: CGFloat
    
    public var body: some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .infinity)
            } else {
                ProgressView()
                    .frame(width: progressWidth, height: progressHeight)
            }
        }
        .onAppear() {
            fastDownImg()
        }
    }
    
    public init(url: URL, progressWidth: CGFloat = 300, progressHeight: CGFloat = 200) {
        self.url = url
        self.progressWidth = progressWidth
        self.progressHeight = progressHeight
    }
    
    private func fastDownImg() {
        Task {
            do {
                let imageTemp = try await FastLoader().image(from: url)
                image = imageTemp
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

@available(iOS 16.0, *)
public class FastLoader {
    
    private let imageCache = FastCache()

    func image(from url: URL) async throws -> UIImage {
        if let cachedImage = imageCache.image(for: url) {
            return cachedImage
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
