//
//  CartTableViewCell.swift
//  BookApp
//
//  Created by 서혜림 on 5/8/24.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    static let identifier = "CartTableViewCell"
    
    class ImageCache {
        static let shared = ImageCache()
        
        private let cache = NSCache<NSString, UIImage>()
        
        private init() {}
        
        func setImage(_ image: UIImage, forKey key: String) {
            cache.setObject(image, forKey: key as NSString)
        }
        
        func getImage(forKey key: String) -> UIImage? {
            return cache.object(forKey: key as NSString)
        }
    }
    
    private let bookImg: UIImageView = {
        let bookImg = UIImageView()
        bookImg.translatesAutoresizingMaskIntoConstraints = false
        return bookImg
    }()
    
    private let bookTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let bookAuthor: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    private let bookPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(bookImg)
        contentView.addSubview(bookTitle)
        contentView.addSubview(bookAuthor)
        contentView.addSubview(bookPrice)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bookImg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            bookImg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            bookImg.widthAnchor.constraint(equalToConstant: 60),
            bookImg.heightAnchor.constraint(equalToConstant: 90),
            
            bookTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bookTitle.leadingAnchor.constraint(equalTo: bookImg.trailingAnchor, constant: 10),
            bookTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            bookAuthor.topAnchor.constraint(equalTo: bookTitle.bottomAnchor, constant: 5),
            bookAuthor.leadingAnchor.constraint(equalTo: bookImg.trailingAnchor, constant: 10),
            bookAuthor.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            bookPrice.topAnchor.constraint(equalTo: bookAuthor.bottomAnchor, constant: 5),
            bookPrice.leadingAnchor.constraint(equalTo: bookImg.trailingAnchor, constant: 10),
            bookPrice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            bookPrice.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with book: BookData) {
        bookTitle.text = book.title
        if !book.authors.isEmpty {
            bookAuthor.text = "\(book.authors.joined(separator: ", "))"
        } else {
            bookAuthor.text = "저자 미상"
        }
        bookPrice.text = "\(book.price)원"
        if let cachedImage = ImageCache.shared.getImage(forKey: book.thumbnail) {
            bookImg.image = cachedImage
        } else {
            DispatchQueue.global().async { [weak self] in
                if let url = URL(string: book.thumbnail),
                   let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    ImageCache.shared.setImage(image, forKey: book.thumbnail)
                    
                    DispatchQueue.main.async {
                        self?.bookImg.image = image
                    }
                }
            }
        }
    }
}

