# FastImage

Asynchronous `Image` with downloader and caching, for SwiftUI

<img src=https://raw.githubusercontent.com/nbrandes/FastImage/main/Docs/Media/fastimage.gif width=300 align="right" />

## Contents

- [Add the Package](#package)
- [Usage](#usage)
- [Parameters](#parameters)
- [Example](#example)
- [FastLoader](#fastloader)

## Package

### For Xcode Projects

File > Add Package Dependencies > Enter Package URL: https://github.com/nbrandes/FastImage

### For Swift Packages

Add a dependency in your `Package.swift`

```swift
.package(url: "https://github.com/nbrandes/FastImage.git"),
```

## Usage

Initialize `FastImage` with a `URL`
```swift
FastImage(url)
```

Provide a placeholder to be displayed while the image is loading. \
If no closure is provided, a `ProgressView` will be displayed.
```swift
FastImage(url) {
    Text("Loading")
}
```

## Parameters

Required: \
`url: URL` - the `URL` of an image to load

Optional: \
`progressWidth: CGFloat` - (Default 300) - width of the `ProgressView` frame \
`progressHeight: Color` - (Default 200) - height of the `ProgressView` frame \
`cache: Bool` - (Default true) - enable/disable image caching \
`placeholder: View` -` ViewBuilder` that is displayed while the image is fetched 

```swift
FastImage(url, progressWidth: 300, progressHeight: 200, cache: true) {
    Text("Loading")
}
```

## Example

```swift
import SwiftUI
import FastImage

struct ContentView: View {

    let paris = URL(string:"https://cdn.pixabay.com/photo/2019/02/21/18/52/paris-4011964_1280.jpg")!
    
    var body: some View {
        VStack() {
            FastImage(paris)
        }
    }
}
```

## FastLoader

For asynchronous downloading and caching without the SwiftUI component, use `FastLoader`

```swift
import FastImage

Task {
    do {
        let image = try await FastLoader().image(from: imageUrl)
        // Do something with the image...
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}
```
