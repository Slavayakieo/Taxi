//
//  NetworkError.swift
//  taxi
//
//  Created by Viacheslav Yakymenko on 23.05.2022.
//

import Foundation

enum NetworkError: Error {
    case response(Int)
    case data(String)
    case unknown
}
