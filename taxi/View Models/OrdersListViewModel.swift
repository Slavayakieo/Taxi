//
//  OrdersViewModel.swift
//  taxi
//
//  Created by Viacheslav Yakymenko on 24.05.2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol OrdersViewModelProtocol: NSObject {
    var orders: BehaviorRelay<[Order]> { get }
    var orderCount: Int { get }
    func fetchData()
    
    func cellViewModel(for row: Int) -> DetailsCellViewModelProtocol
    func detailsViewModel(for row: Int) -> OrderDetailViewModelProtocol
    
}

class OrdersListViewModel: NSObject, OrdersViewModelProtocol {
    var orders = BehaviorRelay<[Order]>(value: [])
    
    var orderCount: Int {
        orders.value.count
    }
    
    private let bag = DisposeBag()
    
    override init() {
        super.init()
    }
    
    
    func cellViewModel(for row: Int) -> DetailsCellViewModelProtocol {
        return OrderCellViewModel(order: orders.value[row])
    }
    
    func detailsViewModel(for row: Int) -> OrderDetailViewModelProtocol {
        return OrderDetailsViewModel(order: orders.value[row])
    }
    
    func fetchData() {
        NetworkRequest.shared.makeRequest(url: "https://www.roxiemobile.ru/careers/test/orders.json") { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let orders = try JSONDecoder().decode([Order].self, from: data)
                    DispatchQueue.main.async() {
                        self?.orders.accept(orders)
                    }
                } catch {
                    print("error while parsing data: \n\(error)")
                }
                
            case .failure(let error):
                print("failed to load data from server:\n\(error.localizedDescription)\n")
            }
        }
    }
    
}

