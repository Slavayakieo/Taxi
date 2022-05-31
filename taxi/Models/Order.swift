//
//  Order.swift
//  taxi
//
//  Created by Viacheslav Yakymenko on 23.05.2022.
//

import Foundation

struct Order: Decodable {
    let id: Int
    let startAddress: Address
    let endAddress: Address
    let price: Price
    let orderTime: String
    let vehicle: Vehicle
}

struct Address: Decodable {
    let city: String
    let address: String
}

struct Price: Decodable {
    let amount: Int
    let currency: String
}

struct Vehicle: Decodable {
    let regNumber: String
    let modelName: String
    let photo: String
    let driverName: String
}

class OrderList: Decodable {
    var orders: [Order]
}
