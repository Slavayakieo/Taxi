//
//  OrderDetailsViewModel.swift
//  taxi
//
//  Created by Viacheslav Yakymenko on 24.05.2022.
//

import UIKit

protocol OrderDetailViewModelProtocol {
    var departureSpot: NSAttributedString { get }
    var destination: NSAttributedString { get }
    var time: String { get }
    var price: String { get }
    var vehicle: NSAttributedString { get }
    var driver: String { get }
    func fetchImage(completion: @escaping (UIImage) -> Void) 
}

class OrderDetailsViewModel: OrderDetailViewModelProtocol {
    
    private var order: Order
    
    var imageLoadingTask: URLSessionDataTask?
    
    var departureSpot: NSAttributedString {
        let start = order.startAddress
        let value = NSMutableAttributedString()
            .append(boldText: "От: ")
            .append(normalText: "\(start.address), \(start.city)")
        return value
    }
    
    var destination: NSAttributedString {
        let end = order.endAddress
        let value = NSMutableAttributedString()
            .append(boldText: "До: ")
            .append(normalText: "\(end.address), \(end.city)")
        return value
    }
    
    var time: String {
        return formatTime(input: order.orderTime)
    }

    var price: String {
        return formatPrice(input: order.price)
    }
    
    var vehicle: NSAttributedString {
        let value = NSMutableAttributedString()
            .append(normalText: "\(order.vehicle.modelName) \t")
            .append(boldText: order.vehicle.regNumber)
        return value
    }
    
    var driver: String {
        return order.vehicle.driverName
    }
    
    init(order: Order) {
        self.order = order
    }
    
    deinit {
        imageLoadingTask?.cancel()
    }
    
    private func formatTime(input: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let date = inputDateFormatter.date(from: input) else {
            return ""
        }
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.timeZone = .current
        outputDateFormatter.dateFormat = "HH:mm  dd.MM.yyyy"
        return  outputDateFormatter.string(from: date)
    }
    
    private func formatPrice(input: Price) -> String {
        let value = Double(input.amount) / 100
        let formattedValue = String(format: "%.2f", value)
        let curr = getSymbol(forCurrencyCode: input.currency)
        return "\(formattedValue) \(curr)"
    }
    
    private func getSymbol(forCurrencyCode code: String) -> String {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code) ?? code
        }
        return locale.displayName(forKey: .currencySymbol, value: code) ?? code
    }
    
    func fetchImage(completion: @escaping (UIImage) -> Void) {
        imageLoadingTask = ImagesRepository.shared.getImage(named: order.vehicle.photo, completion: { [weak self] image in
            completion(image)
        })
    }
}

extension NSMutableAttributedString {
    func append(boldText: String) -> NSMutableAttributedString {
        let boldAttributedText = NSMutableAttributedString(string: boldText, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)])
        
        self.append(boldAttributedText)
        return self
    }
    
    func append(normalText: String) -> NSMutableAttributedString {
        let normalAttributedText = NSMutableAttributedString(string: normalText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)])
        
        self.append(normalAttributedText)
        return self
    }
}
