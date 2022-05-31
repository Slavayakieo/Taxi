//
//  DetailsCellViewModel.swift
//  taxi
//
//  Created by Viacheslav Yakymenko on 24.05.2022.
//

import Foundation

protocol DetailsCellViewModelProtocol {
    var startAddress: String { get }
    var endAddress: String { get }
    var date: String { get }
    var price: String { get }
}

class OrderCellViewModel: DetailsCellViewModelProtocol {
    private var order: Order
    
    var startAddress: String {
        let start = order.startAddress
        return "\(start.address), \(start.city)"
    }
    
    var endAddress: String {
        let end = order.endAddress
        return "\(end.address), \(end.city)"
    }
    
    var date: String {
        return formatDate(input: order.orderTime)
    }

    var price: String {
        return formatPrice(input: order.price)
    }
    
    init(order: Order) {
        self.order = order
    }
    
    private func formatDate(input: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let date = inputDateFormatter.date(from: input) else {
            return ""
        }
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.timeZone = .current
        outputDateFormatter.dateFormat = "dd.MM.yyyy"
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
}

