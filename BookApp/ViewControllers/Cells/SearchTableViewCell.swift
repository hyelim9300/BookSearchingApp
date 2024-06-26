//
//  SearchTableViewCell.swift
//  BookApp
//
//  Created by 서혜림 on 5/8/24.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "SearchTableViewCell"
    
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
    
    // MARK: - LifeCycles
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with book: BookData?) {
        guard let book = book else {
            bookImg.image = nil
            bookTitle.text = nil
            bookPrice.text = nil
            bookAuthor.text = nil
            return
        }
        
        bookTitle.text = book.title
        bookPrice.text = "\(book.price)원"
        if !book.authors.isEmpty {
            bookAuthor.text = book.authors[0]
        } else {
            bookAuthor.text = "저자 미상"
        }
        
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
    
    let bookImg: UIImageView = {
        let bookImg = UIImageView()
        bookImg.translatesAutoresizingMaskIntoConstraints = false
        return bookImg
    }()
    
    let bookTitle: UILabel = {
        let bookTitle = UILabel()
        bookTitle.translatesAutoresizingMaskIntoConstraints = false
        bookTitle.font = UIFont.boldSystemFont(ofSize: 18)
        bookTitle.numberOfLines = 1
        bookTitle.lineBreakMode = .byTruncatingTail
        return bookTitle
    }()
    
    let bookPrice: UILabel = {
        let bookPrice = UILabel()
        bookPrice.translatesAutoresizingMaskIntoConstraints = false
        bookPrice.font = UIFont.boldSystemFont(ofSize: 18)
        return bookPrice
    }()
    
    let bookAuthor: UILabel = {
        let bookAuthor = UILabel()
        bookAuthor.translatesAutoresizingMaskIntoConstraints = false
        bookAuthor.font = UIFont.systemFont(ofSize: 18)
        return bookAuthor
    }()
    
    private func addContentView() {
        contentView.addSubview(bookImg)
        contentView.addSubview(bookTitle)
        contentView.addSubview(bookPrice)
        contentView.addSubview(bookAuthor)
    }
    
    private func setupViews() {
        addSubview(bookImg)
        addSubview(bookTitle)
        addSubview(bookPrice)
        addSubview(bookAuthor)
        
        NSLayoutConstraint.activate([
            bookImg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            bookImg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            bookImg.widthAnchor.constraint(equalToConstant: 60),
            bookImg.heightAnchor.constraint(equalToConstant: 90),
            
            bookTitle.leadingAnchor.constraint(equalTo: bookImg.trailingAnchor, constant: 10),
            bookTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            bookTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            bookAuthor.leadingAnchor.constraint(equalTo: bookImg.trailingAnchor, constant: 10),
            bookAuthor.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            bookAuthor.topAnchor.constraint(equalTo: bookTitle.bottomAnchor, constant: 10),
            
            bookPrice.leadingAnchor.constraint(equalTo: bookImg.trailingAnchor, constant: 10),
            bookPrice.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            bookPrice.topAnchor.constraint(equalTo: bookAuthor.bottomAnchor, constant: 10),
            
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
