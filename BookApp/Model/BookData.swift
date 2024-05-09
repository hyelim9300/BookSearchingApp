//
//  RemoteProduct.swift
//  BookApp
//
//  Created by 서혜림 on 5/8/24.
//

import Foundation

struct BookData: Codable {
    let title: String
    let price: Int
    let thumbnail: String
    let authors: [String]
    let contents: String
}
