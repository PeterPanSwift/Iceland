import Foundation

enum IcelandData {
    static let attractions: [Attraction] = [
        Attraction(
            id: "hallgrimskirkja",
            name: "哈爾格林姆教堂",
            englishName: "Hallgrímskirkja",
            region: .reykjavik,
            category: .city,
            tagline: "雷克雅維克的天際線地標",
            description: "高 74.5 公尺的哈爾格林姆教堂是冰島最高的教堂，外觀設計靈感來自冰島常見的柱狀玄武岩。教堂於 1945 年動工、1986 年完工，搭電梯登上塔頂，可以俯瞰雷克雅維克色彩繽紛的屋頂與遠方的海灣。",
            highlights: ["登塔俯瞰市區全景", "巨型管風琴", "門前的萊夫·艾瑞克森雕像"],
            bestSeason: "全年",
            latitude: 64.1417, longitude: -21.9266
        ),
        Attraction(
            id: "blue-lagoon",
            name: "藍湖溫泉",
            englishName: "Blue Lagoon",
            region: .reykjavik,
            category: .geothermal,
            tagline: "熔岩原中的乳藍色地熱溫泉",
            description: "藍湖位於雷克雅內斯半島的熔岩原上，乳藍色的溫泉水富含二氧化矽、藻類與礦物質，水溫約 37–39°C。距離凱夫拉維克國際機場只要約 20 分鐘車程，許多旅客會在抵達或離開冰島時順道造訪。",
            highlights: ["矽泥面膜", "湖中酒吧", "熔岩原步道"],
            bestSeason: "全年（需預約）",
            latitude: 63.8804, longitude: -22.4495
        ),
        Attraction(
            id: "thingvellir",
            name: "辛格維利爾國家公園",
            englishName: "Þingvellir",
            region: .goldenCircle,
            category: .history,
            tagline: "站在兩大板塊之間",
            description: "西元 930 年，冰島的議會「阿爾庭」在這裡成立，是世界上最古老的議會之一。這裡同時是北美板塊與歐亞板塊分離的裂谷地帶，2004 年列入聯合國教科文組織世界遺產。",
            highlights: ["Almannagjá 裂谷步道", "Silfra 裂縫浮潛", "Öxarárfoss 瀑布"],
            bestSeason: "全年",
            latitude: 64.2559, longitude: -21.1299
        ),
        Attraction(
            id: "geysir",
            name: "史托克間歇泉",
            englishName: "Strokkur · Geysir",
            region: .goldenCircle,
            category: .geothermal,
            tagline: "每幾分鐘一次的大地噴泉",
            description: "蓋錫爾地熱區是英文「geyser（間歇泉）」一詞的由來。如今最活躍的是史托克間歇泉，大約每 5 到 10 分鐘噴發一次，水柱通常高達 15 到 20 公尺，偶爾甚至衝上 40 公尺。",
            highlights: ["近距離觀賞噴發", "冒著蒸汽的地熱池", "Geysir 遊客中心"],
            bestSeason: "全年",
            latitude: 64.3125, longitude: -20.3009
        ),
        Attraction(
            id: "gullfoss",
            name: "黃金瀑布",
            englishName: "Gullfoss",
            region: .goldenCircle,
            category: .waterfall,
            tagline: "黃金圈最壯觀的雙層瀑布",
            description: "白河（Hvítá）在這裡分成兩段落入深邃的峽谷，總落差約 32 公尺。晴天時水霧常映出彩虹，冬天則會被冰雪包覆成另一番景象，是黃金圈路線的三大必訪景點之一。",
            highlights: ["上下兩層觀景台", "水霧彩虹", "冬季冰封景色"],
            bestSeason: "6 月 – 9 月",
            latitude: 64.3271, longitude: -20.1199
        ),
        Attraction(
            id: "seljalandsfoss",
            name: "塞里雅蘭瀑布",
            englishName: "Seljalandsfoss",
            region: .southCoast,
            category: .waterfall,
            tagline: "可以走到瀑布後方",
            description: "塞里雅蘭瀑布從約 60 公尺高的懸崖傾瀉而下，最特別的是有一條步道能繞到水簾後方，從瀑布裡面看出去的景色令人難忘。記得帶上防水外套！",
            highlights: ["瀑布後方步道", "夕陽時分逆光", "附近的秘境瀑布 Gljúfrabúi"],
            bestSeason: "5 月 – 9 月",
            latitude: 63.6156, longitude: -19.9886
        ),
        Attraction(
            id: "skogafoss",
            name: "斯科加瀑布",
            englishName: "Skógafoss",
            region: .southCoast,
            category: .waterfall,
            tagline: "彩虹與維京傳說",
            description: "寬約 25 公尺、落差約 60 公尺的斯科加瀑布，晴天時幾乎總能看到彩虹。傳說第一位定居此地的維京人把寶箱藏在瀑布後方。沿著旁邊的階梯可以登上瀑布頂端。",
            highlights: ["登上 500 多階觀景台", "雙彩虹", "Fimmvörðuháls 健行起點"],
            bestSeason: "全年",
            latitude: 63.5321, longitude: -19.5114
        ),
        Attraction(
            id: "reynisfjara",
            name: "黑沙灘",
            englishName: "Reynisfjara",
            region: .southCoast,
            category: .coast,
            tagline: "玄武岩柱與海蝕柱",
            description: "黑色的火山沙、像管風琴一樣排列的玄武岩柱，以及海上的 Reynisdrangar 海蝕柱，構成冰島最具代表性的海岸景觀。這裡的「瘋狗浪」非常危險，請務必與海浪保持距離。",
            highlights: ["Gardar 玄武岩柱", "Reynisdrangar 海蝕柱", "夏季可見海鸚"],
            bestSeason: "全年",
            latitude: 63.4044, longitude: -19.0447
        ),
        Attraction(
            id: "jokulsarlon",
            name: "傑古沙龍冰河湖",
            englishName: "Jökulsárlón",
            region: .southeast,
            category: .glacier,
            tagline: "漂浮著藍色冰山的湖",
            description: "從瓦特納冰原延伸出的布雷扎梅庫冰河在這裡崩解，巨大的冰山在湖中緩緩漂向大西洋。湖口對面就是「鑽石沙灘」，晶瑩的冰塊散落在黑沙上閃閃發光。",
            highlights: ["水陸兩用船遊湖", "鑽石沙灘", "海豹出沒"],
            bestSeason: "全年",
            latitude: 64.0784, longitude: -16.2306
        ),
        Attraction(
            id: "kirkjufell",
            name: "草帽山",
            englishName: "Kirkjufell",
            region: .west,
            category: .mountain,
            tagline: "冰島最常被拍攝的山",
            description: "位於斯奈山半島的草帽山高約 463 公尺，獨特的圓錐外型搭配前方的 Kirkjufellsfoss 小瀑布，是攝影師最愛的構圖，也曾在影集《冰與火之歌：權力遊戲》中登場。",
            highlights: ["Kirkjufellsfoss 瀑布前景", "冬季極光構圖", "斯奈山半島自駕"],
            bestSeason: "9 月 – 3 月（極光）",
            latitude: 64.9417, longitude: -23.3067
        ),
        Attraction(
            id: "dettifoss",
            name: "黛提瀑布",
            englishName: "Dettifoss",
            region: .north,
            category: .waterfall,
            tagline: "歐洲最具威力的瀑布之一",
            description: "黛提瀑布寬約 100 公尺、落差約 45 公尺，灰白色的冰河融水以驚人的水量轟隆落下，站在旁邊能感受到地面的震動。它位於瓦特納冰原國家公園內，是北部最震撼的自然景觀。",
            highlights: ["東西兩岸不同視角", "上游的 Selfoss", "Ásbyrgi 馬蹄峽谷"],
            bestSeason: "6 月 – 9 月",
            latitude: 65.8147, longitude: -16.3846
        ),
        Attraction(
            id: "myvatn",
            name: "米湖",
            englishName: "Mývatn",
            region: .north,
            category: .geothermal,
            tagline: "火山與地熱交織的湖區",
            description: "米湖周圍布滿火山口、熔岩迷宮與冒著硫磺蒸汽的 Hverir 地熱區。泡在米湖溫泉裡眺望湖景，是比藍湖更悠閒的選擇；這裡也是北部觀賞極光的熱門地點。",
            highlights: ["Hverir 泥漿池", "Dimmuborgir 熔岩迷宮", "米湖自然溫泉"],
            bestSeason: "全年",
            latitude: 65.6039, longitude: -16.9961
        ),
    ]

    static let featuredIDs = ["jokulsarlon", "kirkjufell", "skogafoss", "blue-lagoon", "reynisfjara"]

    static var featured: [Attraction] {
        featuredIDs.compactMap { id in attractions.first { $0.id == id } }
    }

    static func attractions(in region: Region) -> [Attraction] {
        attractions.filter { $0.region == region }
    }

    struct Fact: Identifiable {
        let title: String
        let value: String
        let symbol: String
        var id: String { title }
    }

    static let facts: [Fact] = [
        Fact(title: "首都", value: "雷克雅維克", symbol: "building.2"),
        Fact(title: "人口", value: "約 39 萬人", symbol: "person.3"),
        Fact(title: "面積", value: "103,000 km²", symbol: "map"),
        Fact(title: "貨幣", value: "冰島克朗 ISK", symbol: "banknote"),
        Fact(title: "語言", value: "冰島語", symbol: "character.bubble"),
        Fact(title: "時區", value: "UTC+0", symbol: "clock"),
    ]

    struct Tip: Identifiable {
        let title: String
        let detail: String
        let symbol: String
        var id: String { title }
    }

    static let tips: [Tip] = [
        Tip(title: "環島 1 號公路", detail: "全長約 1,320 公里的環島公路串起大部分景點，自駕 7 到 10 天最為從容。", symbol: "car.fill"),
        Tip(title: "追極光", detail: "9 月到隔年 3 月是極光季，選擇晴朗、遠離光害的夜晚，並留意極光預報。", symbol: "sparkles"),
        Tip(title: "午夜太陽", detail: "6 月下旬幾乎沒有黑夜，可以把行程排得很滿，但記得帶眼罩好好睡覺。", symbol: "sun.max.fill"),
        Tip(title: "多層次穿搭", detail: "冰島的天氣一天多變，防風防水外套與保暖中層是必備裝備。", symbol: "cloud.sun.rain.fill"),
    ]
}
