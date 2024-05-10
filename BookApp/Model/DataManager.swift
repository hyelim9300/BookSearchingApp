//
//  DataManager.swift
//  BookApp
//
//  Created by 서혜림 on 5/10/24.
//

import Foundation

class CartManager {
    static let shared = CartManager()
    private let userDefaultsKey = "cartItems"
    private var cartItems: [BookData] = []
    
    private init() {
        loadCartItems()
    }
    
    func addToCart(book: BookData) {
        cartItems.append(book)
        saveCartItems()
    }

    func getCartItems() -> [BookData] {
        return cartItems
    }
    
    private func saveCartItems() {
        if let data = try? JSONEncoder().encode(cartItems) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    private func loadCartItems() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let books = try? JSONDecoder().decode([BookData].self, from: data) {
            cartItems = books
        }
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
        resentBookSave()
    }

    private func resentBookSave() {
        if let data = try? JSONEncoder().encode(recentBooks) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    func getRecentBooks() -> [BookData] {
        return recentBooks
    }
}
