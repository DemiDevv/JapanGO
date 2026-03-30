//
//  CoreDataManager.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 29.03.2026.
//

import Foundation
import CoreData

protocol PlaceRepositoryProtocol {
    func addToFavorite(place: Place)
    func removeFromFavorite(id: String)
    func fetchFavorite() -> [Place]
    func isFavorite(id: String) -> Bool
}

final class CoreDataManager {

    private let container: NSPersistentContainer

    private var context: NSManagedObjectContext {
        container.viewContext
    }

    init() {
        container = NSPersistentContainer(name: "JapanGO")

        container.loadPersistentStores { [weak container] _, error in
            if let error {
                print("CoreData error: \(error.localizedDescription)")

                guard let storeURL = container?.persistentStoreDescriptions.first?.url else { return }

                try? FileManager.default.removeItem(at: storeURL)

                container?.loadPersistentStores { _, retryError in
                    if let retryError {
                        print("Core Data fatal: \(retryError.localizedDescription)")
                    }
                }
            }
        }

        context.automaticallyMergesChangesFromParent = true
    }

    private func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения \(error)")
        }
    }
}

extension CoreDataManager: PlaceRepositoryProtocol {
    func addToFavorite(place: Place) {
        if isFavorite(id: place.id) {
            print("Уже есть в избранном")
            return
        } else {
            _ = place.toEntity(context: context)
            save()
        }
    }
    
    func removeFromFavorite(id: String) {
        let request = NSFetchRequest<PlaceEntity>(entityName: "PlaceEntity")
        request.predicate = NSPredicate(format: "id == %@", id)

        do {
            let entities = try context.fetch(request)
            guard let entityToDelete = entities.first else { return }
            context.delete(entityToDelete)
            save()
        } catch {
            print("Ошибка удаления: \(error)")
        }
    }
    
    func fetchFavorite() -> [Place] {
        let request = NSFetchRequest<PlaceEntity>(entityName: "PlaceEntity")

        do {
            let entities = try context.fetch(request)
            return entities.map { $0.toPlace() }
        } catch {
            print("Ошибка загрузки: \(error)")
            return []
        }
    }
    
    func isFavorite(id: String) -> Bool {
        let request = NSFetchRequest<PlaceEntity>(entityName: "PlaceEntity")
        request.predicate = NSPredicate(format: "id == %@", id)

        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Ошибка загрузки: \(error)")
            return false
        }
    }
}

// MARK: - Place → PlaceEntity

extension Place {
    func toEntity(context: NSManagedObjectContext) -> PlaceEntity {
        let entity = PlaceEntity(context: context)
        entity.id = id
        entity.name = name
        entity.nameJP = nameJP
        entity.descriptionEN = descriptionEN
        entity.descriptionRU = descriptionRU
        entity.category = category
        entity.rating = rating
        entity.latitude = latitude
        entity.longitude = longitude
        entity.address = address
        entity.addressJP = addressJP
        entity.city = city
        entity.region = region
        entity.imageURLs = imageURLs as [String]
        entity.price = price
        entity.hours = hours
        entity.closedDays = closedDays
        entity.website = website
        entity.phoneNumber = phoneNumber
        entity.nearestStation = nearestStation
        entity.walkFromStation = Int16(walkFromStation)
        entity.tipsEN = tipsEN
        entity.tipsRU = tipsRU
        entity.tags = tags as [String]
        entity.seasonRecommendation = seasonRecommendation
        return entity
    }
}

// MARK: - PlaceEntity → Place

extension PlaceEntity {
    func toPlace() -> Place {
        return Place(
            id: id ?? "",
            name: name ?? "",
            nameJP: nameJP ?? "",
            descriptionEN: descriptionEN ?? "",
            descriptionRU: descriptionRU ?? "",
            category: category ?? "",
            rating: rating,
            latitude: latitude,
            longitude: longitude,
            address: address ?? "",
            addressJP: addressJP ?? "",
            city: city ?? "",
            region: region ?? "",
            imageURLs: imageURLs ?? [],
            price: price ?? "",
            hours: hours ?? "",
            closedDays: closedDays ?? "",
            website: website ?? "",
            phoneNumber: phoneNumber ?? "",
            nearestStation: nearestStation ?? "",
            walkFromStation: Int(walkFromStation),
            tipsEN: tipsEN ?? "",
            tipsRU: tipsRU ?? "",
            tags: tags ?? [],
            seasonRecommendation: seasonRecommendation ?? ""
        )
    }
}
