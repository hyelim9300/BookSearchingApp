//
//  RemoteProduct.swift
//  BookApp
//
//  Created by 서혜림 on 5/8/24.
//

import Foundation

struct RemoteProduct: Decodable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let thumbnail: URL
}
