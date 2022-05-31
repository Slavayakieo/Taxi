//
//  OrderDetailRepository.swift
//  taxi
//
//  Created by Viacheslav Yakymenko on 24.05.2022.
//

import UIKit
import CoreData


protocol ImagesRepositoryProtocol {
    func getImage(named: String, completion: @escaping (UIImage) -> Void) -> URLSessionDataTask?
}

class ImagesRepository: ImagesRepositoryProtocol {
    static let shared = ImagesRepository()
    
    private init() {}
    
    func getImage(named imageName: String, completion: @escaping (UIImage) -> Void) -> URLSessionDataTask? {

        if let image = lookupInStorage(imageName: imageName) {
            completion(image)
            return nil
        }
        
        let dataTask = NetworkRequest.shared.makeRequest(url: "https://www.roxiemobile.ru/careers/test/images/\(imageName)") { [weak self] result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(image)
                    DispatchQueue.main.async {
                        self?.saveToStorage(image: image, named: imageName)
                    }
                }
                
            case .failure(let error):
                print("failed to load data from server:\n\(error.localizedDescription)\n")
            }
        }
        return dataTask
    }
    
    func lookupInStorage(imageName: String) -> UIImage? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<VehicleImage> = VehicleImage.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", imageName)
        fetchRequest.predicate = predicate
        do {
            let results = try managedContext.fetch(fetchRequest)
            if let cachedImage = results.first {
                if cachedImage.expirationDate > Date() {
                    return UIImage(data: cachedImage.image)
                } else {
                    for object in results {
                        managedContext.delete(object)
                    }
                    appDelegate.saveContext()
                }
            }
        } catch let error as NSError {
            print("Error while fetching data. \(error), \(error.userInfo)")
        }
        return nil

    }
    
    func saveToStorage(image: UIImage, named imageName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        VehicleImage(context: managedContext, image: image, named: imageName)
        appDelegate.saveContext()
        
    }
}


