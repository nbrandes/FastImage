# FastImage

Asynchronous Image View with downloader and cache support, for SwiftUI

<img src=https://raw.githubusercontent.com/nbrandes/FastImage/main/Docs/Media/fastimage.gif width=300 align="right" />

## Contents

- [Add the Package](#package)
- [Usage](#usage)
- [Parameters](#parameters)
- [Example](#example)
- [FastLoader](#fastloader)

## Package

### For Xcode Projects

File > Swift Packages > Add Package Dependency: https://github.com/nbrandes/FastImage

### For Swift Packages

Add a dependency in your your `Package.swift`

```swift
.package(url: "https://github.com/nbrandes/FastImage.git"),
```

## Usage

Initialize FastImage with a URL

```swift
let wall = URL(string:"https://cdn.pixabay.com/photo/2017/10/21/16/30/suwon-2875142_1280.jpg")!
FastImage(url: wall)
```

## Parameters

Required:
* `url: URL` - the URL of an image to load

Optional:
* `progressWidth: CGFloat` - Width of the ProgressView frame - default is 300
* `progressHeight: Color` - Height of the ProgressView frame - default is 200

```swift
FastImage(url: paris, progressWidth: 300, progressHeight: 200)
```

## Example

```swift
import SwiftUI
import FastImage

struct ContentView: View {

    let paris = URL(string:"https://cdn.pixabay.com/photo/2019/02/21/18/52/paris-4011964_1280.jpg")!
    let marsh = URL(string:"https://cdn.pixabay.com/photo/2018/09/17/07/58/trees-3683234_1280.jpg")!
    let wall = URL(string:"https://cdn.pixabay.com/photo/2017/10/21/16/30/suwon-2875142_1280.jpg")!
    
    var body: some View {
        VStack() {
            FastImage(url: paris)
            FastImage(url: marsh)
            FastImage(url: wall)
        }
    }
}
```

## FastLoader

FastLoader can fetch images with caching support

```swift
struct ContentView: View {
    
    @State var image: UIImage?
    var placeholder = UIImage(named: "placeholder")
    
    var body: some View {
        Image(uiImage: (image ?? placeholder)!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:UIScreen.main.bounds.width - 40)
        Button("Load URL") {
            downloadImage()
        }
        .buttonStyle(.borderedProminent)
    }
    
    func downloadImage() {
        let imageDownloader = FastLoader()
        let imageUrl = URL(string:"https://cdn.pixabay.com/photo/2017/10/21/16/30/suwon-2875142_1280.jpg")!
        Task {
            do {
                let imageTemp = try await imageDownloader.image(from: imageUrl)
                image = imageTemp
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
```
