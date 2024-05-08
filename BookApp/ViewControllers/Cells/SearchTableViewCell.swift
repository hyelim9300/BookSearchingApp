//
//  SearchTableViewCell.swift
//  BookApp
//
//  Created by 서혜림 on 5/8/24.
//

import UIKit


class SearchTableViewCell: UITableViewCell {
    
    static let identifier = "SearchTableViewCell"
    
    let bookImg: UIImageView = {
        let bookImg = UIImageView()
        bookImg.translatesAutoresizingMaskIntoConstraints = false
        return bookImg
    }()
    
    let bookTitle: UILabel = {
        let bookTitle = UILabel()
        bookTitle.translatesAutoresizingMaskIntoConstraints = false
        bookTitle.font = UIFont.boldSystemFont(ofSize: 20)
        return bookTitle
    }()
    
    let bookPrice: UILabel = {
        let bookPrice = UILabel()
        bookPrice.translatesAutoresizingMaskIntoConstraints = false
        bookPrice.font = UIFont.boldSystemFont(ofSize: 20)
        return bookPrice
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupViews()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func configure(with product: RemoteProduct?) {
        guard let product = product else {
            bookImg.image = nil
            bookTitle.text = nil
            bookPrice.text = nil
            return
        }
        
        bookTitle.text = product.title
        bookPrice.text = "\(product.price)$"
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: product.thumbnail), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.bookImg.image = image
                }
            }
        }
    }
    
    private func addContentView() {
        contentView.addSubview(bookImg)
        contentView.addSubview(bookTitle)
        contentView.addSubview(bookPrice)
    }

    private func setupViews() {
        addSubview(bookImg)
        addSubview(bookTitle)
        addSubview(bookPrice)
        
        // Autolayout 설정 예제
        NSLayoutConstraint.activate([
            bookImg.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            bookImg.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            bookImg.widthAnchor.constraint(equalToConstant: 100),
            bookImg.heightAnchor.constraint(equalToConstant: 100),
            
            bookTitle.leadingAnchor.constraint(equalTo: bookImg.trailingAnchor, constant: 10),
            bookTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            bookTitle.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            bookPrice.leadingAnchor.constraint(equalTo: bookImg.trailingAnchor, constant: 10),
            bookPrice.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            bookPrice.topAnchor.constraint(equalTo: bookTitle.bottomAnchor, constant: 10)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

