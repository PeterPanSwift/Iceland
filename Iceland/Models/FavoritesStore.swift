import Foundation
import Observation

@Observable
final class FavoritesStore {
    private static let key = "favoriteAttractionIDs"

    private(set) var ids: Set<String>

    init() {
        ids = Set(UserDefaults.standard.stringArray(forKey: Self.key) ?? [])
    }

    func contains(_ attraction: Attraction) -> Bool {
        ids.contains(attraction.id)
    }

    func toggle(_ attraction: Attraction) {
        if ids.contains(attraction.id) {
            ids.remove(attraction.id)
        } else {
            ids.insert(attraction.id)
        }
        UserDefaults.standard.set(Array(ids), forKey: Self.key)
    }
}
