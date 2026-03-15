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

struct CategoryInfo: Decodable, Identifiable {
    let id: String
    let nameEN: String
    let nameRU: String
    let icon: String
}

struct RegionInfo: Decodable, Identifiable {
    let id: String
    let nameEN: String
    let nameRU: String
}

struct Place: Decodable, Identifiable {
    let id: String
    let name: String
    let nameJP: String
    let descriptionEN: String
    let descriptionRU: String
    let category: String
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
        category: "temples",
        rating: 4.8,
        latitude: 34.9671,
        longitude: 135.7727,
        address: "68 Fukakusa Yabunouchicho, Fushimi-ku, Kyoto",
        addressJP: "京都市伏見区深草藪之内町68",
        city: "Kyoto",
        region: "Kansai",
        imageURLs: ["https://images.unsplash.com/photo-1478436127897-769e1b3f0f36?w=800"],
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
            category: "temples",
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
        )
    ]
}

extension CategoryInfo {
    static let mock = CategoryInfo(
        id: "temples",
        nameEN: "Temples & Shrines",
        nameRU: "Храмы и святыни",
        icon: "⛩"
    )

    static let mockArray: [CategoryInfo] = [
        mock,
        CategoryInfo(id: "food", nameEN: "Food & Cafes", nameRU: "Еда и кафе", icon: "🍜"),
        CategoryInfo(id: "nature", nameEN: "Nature", nameRU: "Природа", icon: "🌿"),
        CategoryInfo(id: "nature1", nameEN: "Nature", nameRU: "Природа", icon: "🌿"),
        CategoryInfo(id: "nature2", nameEN: "Nature", nameRU: "Природа", icon: "🌿"),
        CategoryInfo(id: "nature3", nameEN: "Nature", nameRU: "Природа", icon: "🌿")
    ]
}
#endif
