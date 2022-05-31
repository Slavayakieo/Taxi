//
//  VehicleImage+CoreDataClass.swift
//  taxi
//
//  Created by Viacheslav Yakymenko on 31.05.2022.
//
//

import Foundation
import CoreData
import UIKit

@objc(VehicleImage)
public class VehicleImage: NSManagedObject {
    convenience init(context: NSManagedObjectContext, image: UIImage, named imageName: String) {
        self.init(context: context)
        self.id = imageName
        let jpegImageData = image.jpegData(compressionQuality: 1.0)
        self.image = jpegImageData!
        self.expirationDate = Date() + 10 * 60
    }
}
