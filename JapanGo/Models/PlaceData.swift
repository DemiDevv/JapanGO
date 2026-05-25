//
//  PlaceData.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 13.03.2026.
//

import Foundation

struct PlaceData: Decodable {
    let categories: [CategoryInfo]
    let regions: [RegionInfo]
    let places: [Place]
}

enum PlaceCategory: String, Decodable, Hashable {
    case temples
    case food
    case nature
    case entertainment
    case shopping
    case culture
    case viewpoints
}

struct CategoryInfo: Decodable, Identifiable {
    let id: PlaceCategory
    let nameEN: String
    let nameRU: String
    let icon: String
}

struct RegionInfo: Decodable, Identifiable {
    let id: String
    let nameEN: String
    let nameRU: String
}

struct Place: Decodable, Identifiable, Hashable {
    let id: String
    let name: String
    let nameJP: String
    let descriptionEN: String
    let descriptionRU: String
    let category: PlaceCategory
    let rating: Double
    let latitude: Double
    let longitude: Double
    let address: String
    let addressJP: String
    let city: String
    let region: String
    let imageURLs: [String]
    let price: String
    let hours: String
    let closedDays: String?
    let website: String?
    let phoneNumber: String?
    let nearestStation: String
    let walkFromStation: Int
    let tipsEN: String
    let tipsRU: String
    let tags: [String]
    let seasonRecommendation: String?
}

#if DEBUG
extension Place {
    static let mock = Place(
        id: "1",
        name: "Fushimi Inari Taisha",
        nameJP: "伏見稲荷大社",
        descriptionEN: "Iconic Shinto shrine with thousands of vermillion torii gates.",
        descriptionRU: "Знаменитое святилище с тысячами алых ворот тории.",
        category: .temples,
        rating: 4.8,
        latitude: 34.9671,
        longitude: 135.7727,
        address: "68 Fukakusa Yabunouchicho, Fushimi-ku, Kyoto",
        addressJP: "京都市伏見区深草藪之内町68",
        city: "Kyoto",
        region: "Kansai",
        imageURLs: ["https://images.unsplash.com/photo-1570459027562-4a916cc6113f?w=800", "https://images.unsplash.com/photo-1614865816782-82e0a9b2a5e7?w=800", "https://images.unsplash.com/photo-1570459027562-4a916cc6113f?w=800"],
        price: "Free",
        hours: "24/7",
        closedDays: nil,
        website: "http://inari.jp",
        phoneNumber: nil,
        nearestStation: "Inari Station (JR Nara Line)",
        walkFromStation: 1,
        tipsEN: "Arrive before 7 AM to avoid crowds.",
        tipsRU: "Приходите до 7 утра.",
        tags: ["torii", "shrine", "hiking"],
        seasonRecommendation: "Year-round"
    )

    static let mockArray: [Place] = [
        mock,
        Place(
            id: "2",
            name: "Senso-ji Temple",
            nameJP: "浅草寺",
            descriptionEN: "Tokyo's oldest temple in Asakusa.",
            descriptionRU: "Старейший храм Токио в Асакуса.",
            category: .temples,
            rating: 4.7,
            latitude: 35.7148,
            longitude: 139.7967,
            address: "2-3-1 Asakusa, Taito-ku, Tokyo",
            addressJP: "東京都台東区浅草2-3-1",
            city: "Tokyo",
            region: "Kanto",
            imageURLs: ["https://images.unsplash.com/photo-1570459027562-4a916cc6113f?w=800"],
            price: "Free",
            hours: "6:00-17:00",
            closedDays: nil,
            website: "https://www.senso-ji.jp",
            phoneNumber: nil,
            nearestStation: "Asakusa Station",
            walkFromStation: 5,
            tipsEN: "Visit Nakamise-dori for street food.",
            tipsRU: "Пройдите по Накамисэ-дори.",
            tags: ["temple", "asakusa"],
            seasonRecommendation: "Year-round"
        ),
        Place(
            id: "3",
            name: "Kinkaku-ji",
            nameJP: "金閣寺",
            descriptionEN: "Zen Buddhist temple covered in gold leaf, beautifully reflected in a mirror pond.",
            descriptionRU: "Дзен-буддийский храм, покрытый сусальным золотом, отражающийся в зеркальном пруду.",
            category: .temples,
            rating: 4.7,
            latitude: 35.0394,
            longitude: 135.7292,
            address: "1 Kinkakujicho, Kita-ku, Kyoto",
            addressJP: "京都市北区金閣寺町1",
            city: "Kyoto",
            region: "Kansai",
            imageURLs: [
                "https://images.unsplash.com/photo-1490806843957-31f4c9a91c65?w=800",
                "https://images.unsplash.com/photo-1614865816782-82e0a9b2a5e7?w=800"
            ],
            price: "¥500",
            hours: "9:00-17:00",
            closedDays: nil,
            website: "https://www.shokoku-ji.jp/kinkakuji/",
            phoneNumber: nil,
            nearestStation: "Kinkakuji-michi Bus Stop",
            walkFromStation: 5,
            tipsEN: "Best photos in the morning when sun illuminates the golden pavilion.",
            tipsRU: "Лучшие фото утром, когда солнце освещает павильон.",
            tags: ["golden", "zen", "buddhist", "pond", "iconic"],
            seasonRecommendation: "Year-round, magical with snow"
        ),
        Place(
            id: "9",
            name: "Tsukiji Outer Market",
            nameJP: "築地場外市場",
            descriptionEN: "Historic market area famous for fresh sushi, seafood, and Japanese street food.",
            descriptionRU: "Исторический рынок со свежими суши и уличной едой.",
            category: .food,
            rating: 4.7,
            latitude: 35.6654,
            longitude: 139.7707,
            address: "4-16-2 Tsukiji, Chuo-ku, Tokyo",
            addressJP: "東京都中央区築地4-16-2",
            city: "Tokyo",
            region: "Kanto",
            imageURLs: [
                "https://images.unsplash.com/photo-1553621042-f6e147245754?w=800",
                "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800"
            ],
            price: "Free entry, food from ¥300",
            hours: "5:00-14:00",
            closedDays: "Sundays",
            website: "http://www.tsukiji.or.jp",
            phoneNumber: nil,
            nearestStation: "Tsukiji Station (Hibiya Line)",
            walkFromStation: 1,
            tipsEN: "Go before 8 AM for freshest selections. Try tamagoyaki.",
            tipsRU: "Приходите до 8 утра. Попробуйте тамагояки.",
            tags: ["sushi", "seafood", "market", "street food", "morning"],
            seasonRecommendation: "Year-round"
        ),
        Place(
            id: "17",
            name: "Mount Fuji",
            nameJP: "富士山",
            descriptionEN: "Japan's iconic sacred peak at 3,776m — UNESCO World Heritage and tallest mountain.",
            descriptionRU: "Культовая вершина Японии (3776 м) — ЮНЕСКО, высочайшая гора страны.",
            category: .nature,
            rating: 4.9,
            latitude: 35.3606,
            longitude: 138.7274,
            address: "Fujinomiya, Shizuoka / Fujiyoshida, Yamanashi",
            addressJP: "静岡県富士宮市/山梨県富士吉田市",
            city: "Fujinomiya",
            region: "Chubu",
            imageURLs: [
                "https://images.unsplash.com/photo-1490806843957-31f4c9a91c65?w=800",
                "https://images.unsplash.com/photo-1578271887552-5ac3a72752bc?w=800"
            ],
            price: "¥1,000 (conservation fee)",
            hours: "Climbing: July-September",
            closedDays: "Trails closed Oct-June",
            website: "http://www.fujisan-climb.jp",
            phoneNumber: nil,
            nearestStation: "Kawaguchiko Station (Fujikyu Railway)",
            walkFromStation: 0,
            tipsEN: "Start climbing at night from 5th Station to catch sunrise at summit.",
            tipsRU: "Начните подъём ночью от 5-й станции ради рассвета на вершине.",
            tags: ["mountain", "iconic", "UNESCO", "sacred", "hiking"],
            seasonRecommendation: "Jul-Sep (climbing), year-round (viewing)"
        )
    ]
}

extension CategoryInfo {
    static let mock = CategoryInfo(
        id: .temples,
        nameEN: "Temples & Shrines",
        nameRU: "Храмы и святыни",
        icon: "⛩"
    )

    static let mockArray: [CategoryInfo] = [
        mock,
        CategoryInfo(id: .food, nameEN: "Food & Cafes", nameRU: "Еда и кафе", icon: "🍜"),
        CategoryInfo(id: .nature, nameEN: "Nature", nameRU: "Природа", icon: "🌿"),
        CategoryInfo(id: .entertainment, nameEN: "Entertainment", nameRU: "Развлечения", icon: "🎡"),
        CategoryInfo(id: .shopping, nameEN: "Shopping", nameRU: "Шопинг", icon: "🛍"),
        CategoryInfo(id: .culture, nameEN: "Culture", nameRU: "Культура", icon: "🏯"),
        CategoryInfo(id: .viewpoints, nameEN: "Viewpoints", nameRU: "Смотровые площадки", icon: "🌆")
    ]
}
#endif
