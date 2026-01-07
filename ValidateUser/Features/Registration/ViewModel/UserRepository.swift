//
//  UserRepository.swift
//  ValidateUser
//
//  Created by MACM72 on 07/01/26.
//

import Foundation
import CoreData

final class UserRepository {

    private let context = CoreDataManager.shared.context

    func fetchUser(by email: String) -> UserEntity? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)
        return try? context.fetch(request).first
    }

    func userExists(name: String, email: String) -> Bool {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@ OR email == %@", name, email)
        return (try? context.count(for: request)) ?? 0 > 0
    }

    func save(user: Registration) {
        let entity = UserEntity(context: context)
        entity.name = user.name
        entity.email = user.email
        entity.phone = user.phone
        entity.dob = user.dob
        entity.linkedinUrl = user.linkedinUrl
        entity.userDescription = user.description
        entity.userImage = user.userImage
        CoreDataManager.shared.saveContext()
    }
}
