//
//  UserEntity+CoreDataProperties.swift
//  ValidateUser
//
//  Created by MACM72 on 24/12/25.
//
//

public import Foundation
public import CoreData


public typealias UserEntityCoreDataPropertiesSet = NSSet

extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var dob: String?
    @NSManaged public var linkedinUrl: String?
    @NSManaged public var userDescription: String?
    @NSManaged public var userImage: String?

}

extension UserEntity : Identifiable {

}
