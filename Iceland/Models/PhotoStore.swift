import SwiftUI
import UIKit

/// Photos are downloaded from Wikimedia Commons at build time (scripts/fetch_photos.py)
/// and bundled as `<id>.jpg`, together with `credits.json` for attribution.
enum PhotoStore {
    struct Credit: Decodable, Identifiable {
        let id: String
        let title: String
        let page: String
        let artist: String
        let license: String
    }

    private static let cache = NSCache<NSString, UIImage>()

    static func image(_ id: String) -> UIImage? {
        if let cached = cache.object(forKey: id as NSString) { return cached }
        guard let url = Bundle.main.url(forResource: id, withExtension: "jpg"),
              let image = UIImage(contentsOfFile: url.path) else { return nil }
        cache.setObject(image, forKey: id as NSString)
        return image
    }

    static let credits: [Credit] = {
        guard let url = Bundle.main.url(forResource: "credits", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return [] }
        return (try? JSONDecoder().decode([Credit].self, from: data)) ?? []
    }()

    static func credit(for id: String) -> Credit? {
        credits.first { $0.id == id }
    }
}

/// Fills its frame with a bundled photo, or a gradient placeholder when the photo is missing.
struct PhotoView: View {
    let id: String
    var symbol = "mountain.2.fill"

    var body: some View {
        Color.clear
            .overlay {
                if let image = PhotoStore.image(id) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    LinearGradient(colors: [.cyan, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .overlay {
                            Image(systemName: symbol)
                                .font(.system(size: 48))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                }
            }
            .clipped()
    }
}
