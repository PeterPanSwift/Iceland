import SwiftUI

@main
struct IcelandApp: App {
    @State private var favorites = FavoritesStore()

    init() {
        // UI tests start from a clean slate so every recording looks the same.
        if ProcessInfo.processInfo.arguments.contains("-resetFavorites") {
            UserDefaults.standard.removeObject(forKey: "favoriteAttractionIDs")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(favorites)
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            ExploreView()
                .tabItem { Label("探索", systemImage: "safari") }
            AttractionMapView()
                .tabItem { Label("地圖", systemImage: "map") }
            AboutIcelandView()
                .tabItem { Label("關於冰島", systemImage: "info.circle") }
        }
    }
}
