//
//  SearchViewController.swift
//  BookApp
//
//  Created by 서혜림 on 5/8/24.
//

import SwiftUI

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var products: [RemoteProduct] = [] // 여러 제품을 저장할 배열
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubView()
        autoLayout()
        configure()
        fetchRemoteProducts()
    }
    
    private func configure() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
    }
    
    
    private func addSubView() {
        view.addSubview(tableView)
    }
    
    private func autoLayout() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: guide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }
    
    private func fetchRemoteProducts() {
        // 예시로 ID 범위를 지정하여 무작위 제품 정보를 가져오는 부분입니다.
        // 실제 앱에서는 페이징 또는 전체 제품 목록을 가져오는 방식을 사용할 수 있습니다.
        let productIDs = 1...10 // 예시로 10개의 제품 ID를 가져옵니다.
        productIDs.forEach { id in
            fetchRemoteProduct(id: id)
        }
    }
    
    private func fetchRemoteProduct(id: Int) {
        if let url = URL(string: "https://dummyjson.com/products/\(id)") {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    do {
                        let product = try JSONDecoder().decode(RemoteProduct.self, from: data)
                        DispatchQueue.main.async {
                            self.products.append(product)
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("Decode Error: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        let product = products[indexPath.row]
        cell.configure(with: product)
        return cell
    }
}

#Preview {
    SearchViewController()
}
