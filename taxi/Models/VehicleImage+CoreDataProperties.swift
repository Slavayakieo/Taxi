//
//  VehicleImage+CoreDataProperties.swift
//  taxi
//
//  Created by Viacheslav Yakymenko on 31.05.2022.
//
//

import Foundation
import CoreData


extension VehicleImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VehicleImage> {
        return NSFetchRequest<VehicleImage>(entityName: "VehicleImage")
    }

    @NSManaged public var image: Data
    @NSManaged public var expirationDate: Date
    @NSManaged public var id: String

    
}
