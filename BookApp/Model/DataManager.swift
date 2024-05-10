//
//  DataManager.swift
//  BookApp
//
//  Created by 서혜림 on 5/10/24.
//

import Foundation

class CartManager {
    static let shared = CartManager()
    
    private var cartItems: [BookData] = []
    
    private init() {}
    
    func addToCart(book: BookData) {
        cartItems.append(book)
    }
    
    func getCartItems() -> [BookData] {
        return cartItems.sorted(by: { $0.title > $1.title })
    }
}

class RecentBooksManager {
    static let shared = RecentBooksManager()
    private let maxCount = 10
    private let userDefaultsKey = "recentBooks"
    private var recentBooks: [BookData] = []

    init() {
        loadRecentBooks()
    }

    private func loadRecentBooks() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let books = try? JSONDecoder().decode([BookData].self, from: data) {
            recentBooks = books
        }
    }

    func addBook(book: BookData) {
        if let index = recentBooks.firstIndex(where: { $0.title == book.title }) {
            recentBooks.remove(at: index)
        }
        recentBooks.insert(book, at: 0)
        if recentBooks.count > maxCount {
            recentBooks.removeLast()
        }
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(recentBooks) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    func getRecentBooks() -> [BookData] {
        return recentBooks
    }
}
