//
//  DetailViewController.swift
//  BookApp
//
//  Created by 서혜림 on 5/9/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    var bookData: BookData?
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        guard let book = bookData else { return }
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = book.title
        titleLabel.textAlignment = .center
        
        let authorsLabel = UILabel()
        authorsLabel.translatesAutoresizingMaskIntoConstraints = false
        authorsLabel.text = "Authors: \(book.authors.joined(separator: ", "))"
        
        let contentsLabel = UILabel()
        contentsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentsLabel.text = book.contents
        contentsLabel.numberOfLines = 0
        contentsLabel.lineBreakMode = .byWordWrapping
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        if let url = URL(string: book.thumbnail) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        
        let cartButton = UIButton()
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        cartButton.setTitle("담기", for: .normal)
        cartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        cartButton.backgroundColor = .systemBlue

        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("X", for: .normal)
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        closeButton.backgroundColor = .systemGray

        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(authorsLabel)
        contentView.addSubview(contentsLabel)
        contentView.addSubview(imageView)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        view.addSubview(cartButton)
        view.addSubview(closeButton)
        view.addSubview(spacer)

        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            
            spacer.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor),
            spacer.widthAnchor.constraint(equalToConstant: 10),
            
            cartButton.leadingAnchor.constraint(equalTo: spacer.trailingAnchor),
            cartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            cartButton.heightAnchor.constraint(equalToConstant: 50),
      
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 400),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            authorsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            authorsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            authorsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            contentsLabel.topAnchor.constraint(equalTo: authorsLabel.bottomAnchor, constant: 10),
            contentsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        view.bringSubviewToFront(cartButton)
        view.bringSubviewToFront(closeButton)
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 55, right: 0)

    }
    
    @objc private func addToCart() {
        guard let selectedBook = bookData else {
            return
        }
        CartManager.shared.addToCart(book: selectedBook)
        
        NotificationCenter.default.post(name: Notification.Name("DidAddToCart"), object: nil, userInfo: ["book": selectedBook])
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func closeModal() {
        // "X" 버튼 액션
        dismiss(animated: true, completion: nil)
    }
}
