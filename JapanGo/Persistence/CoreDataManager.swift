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

    let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        container.viewContext
    }

    init() {
        container = NSPersistentContainer(name: "JapanGo")

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
        context.automaticallyMergesChangesFromParent = true
    }

    func save() {
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
        _ = place.toEntity(context: context)
        save()
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
            return entities.compactMap { $0.toPlace() }
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
    func toPlace() -> Place? {
        guard
            let id,
            let name,
            let nameJP,
            let descriptionEN,
            let descriptionRU,
            let category,
            let address,
            let addressJP,
            let city,
            let region,
            let imageURLs = imageURLs,
            let price,
            let hours,
            let nearestStation,
            let tipsEN,
            let tipsRU,
            let tags = tags
        else {
            return nil
        }

        return Place(
            id: id,
            name: name,
            nameJP: nameJP,
            descriptionEN: descriptionEN,
            descriptionRU: descriptionRU,
            category: category,
            rating: rating,
            latitude: latitude,
            longitude: longitude,
            address: address,
            addressJP: addressJP,
            city: city,
            region: region,
            imageURLs: imageURLs,
            price: price,
            hours: hours,
            closedDays: closedDays,
            website: website,
            phoneNumber: phoneNumber,
            nearestStation: nearestStation,
            walkFromStation: Int(walkFromStation),
            tipsEN: tipsEN,
            tipsRU: tipsRU,
            tags: tags,
            seasonRecommendation: seasonRecommendation
        )
    }
}
