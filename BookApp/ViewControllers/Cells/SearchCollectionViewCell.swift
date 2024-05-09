//
//  SearchCollectionViewCell.swift
//  BookApp
//
//  Created by 서혜림 on 5/9/24.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }
    
    var model: String? { didSet { bind() } }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
    }
    
    private func configure() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        backgroundColor = .placeholderText
    }
    private func bind() {
        titleLabel.text = model
    }
}
