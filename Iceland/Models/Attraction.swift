import CoreLocation
import SwiftUI

struct Attraction: Identifiable, Hashable {
    let id: String
    let name: String
    let englishName: String
    let region: Region
    let category: Category
    let tagline: String
    let description: String
    let highlights: [String]
    let bestSeason: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

enum Region: String, CaseIterable, Identifiable {
    case reykjavik = "雷克雅維克"
    case goldenCircle = "黃金圈"
    case southCoast = "南岸"
    case southeast = "東南部"
    case west = "西部"
    case north = "北部"

    var id: String { rawValue }
}

enum Category: String {
    case waterfall = "瀑布"
    case geothermal = "地熱"
    case glacier = "冰河"
    case history = "歷史"
    case coast = "海岸"
    case mountain = "山岳"
    case city = "城市"

    var symbol: String {
        switch self {
        case .waterfall: "drop.fill"
        case .geothermal: "flame.fill"
        case .glacier: "snowflake"
        case .history: "building.columns.fill"
        case .coast: "water.waves"
        case .mountain: "mountain.2.fill"
        case .city: "building.2.fill"
        }
    }

    var color: Color {
        switch self {
        case .waterfall: .blue
        case .geothermal: .orange
        case .glacier: .cyan
        case .history: .brown
        case .coast: .indigo
        case .mountain: .green
        case .city: .purple
        }
    }
}
