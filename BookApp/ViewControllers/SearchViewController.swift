//
//  SearchViewController.swift
//  BookApp
//
//  Created by 서혜림 on 5/8/24.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Properties
    
    struct SearchResponse: Codable {
        let documents: [BookData]
    }
    
    private var bookList: [BookData] = []
    var pageCnt = 1
    var isEnd = false
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        return tableView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var presentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "최근 본 도서"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "도서 검색 결과"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        addSubView()
        autoLayout()
        setSearchBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // MARK: - Methods
    private func configure() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
    }
    
    private func addSubView() {
        view.addSubview(presentLabel)
        view.addSubview(resultLabel)
        view.addSubview(collectionView)
        view.addSubview(tableView)
    }
    
    private func autoLayout() {
        NSLayoutConstraint.activate([
            presentLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            presentLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            presentLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: presentLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 100),
            
            resultLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.sendSubviewToBack(tableView)
    }
    
    func callRequest(_ query: String) {
        
        guard let txt = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let urlString = "https://dapi.kakao.com/v3/search/book?query=\(txt)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.addValue("KakaoAK 18fe3985150a4172574ff6d767cd9d08", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(SearchResponse.self, from: data)
                DispatchQueue.main.async {
                    self.bookList = response.documents
                    self.tableView.reloadData()
                }
            } catch {
                print("Failed to decode response: \(error)")
            }
        }
        task.resume()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            self.tableView.contentInset.bottom = keyboardFrame.height
            self.tableView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.contentInset.bottom = 0
            self.tableView.verticalScrollIndicatorInsets.bottom = 0
        }
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < bookList.count {
            let selectedBook = bookList[indexPath.item]
            let detailVC = DetailViewController()
            detailVC.bookData = selectedBook
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RecentBooksManager.shared.getRecentBooks().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        let book = RecentBooksManager.shared.getRecentBooks()[indexPath.row]
        cell.configure(with: book)
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func setSearchBar() { //searchBar 외형
        let searchBar = UISearchBar()
        searchBar.placeholder = "도서 검색"
        searchBar.setImage(UIImage(named: "icSearchNonW"), for: .search, state: .normal)
        searchBar.setImage(UIImage(named: "icCancel"), for: .clear, state: .normal)
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = .lightGray
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            textfield.textColor = .white
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = .white
            }
            if let rightView = textfield.rightView as? UIImageView {
                rightView.image = rightView.image?.withRenderingMode(.alwaysTemplate)
                rightView.tintColor = .white
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        callRequest(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            callRequest(searchText)
            searchBar.resignFirstResponder()
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.isEmpty ? 1 : bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if bookList.isEmpty {
            let emptyCell = UITableViewCell()
            emptyCell.textLabel?.text = "상단 검색 바를 이용해보세요."
            emptyCell.textLabel?.textColor = .gray
            return emptyCell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
                fatalError("Cannot dequeue SearchTableViewCell")
            }
            let documents = bookList[indexPath.row]
            cell.configure(with: documents)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !bookList.isEmpty {
            let selectedBook = bookList[indexPath.row]
            RecentBooksManager.shared.addBook(book: selectedBook)
            let detailVC = DetailViewController()
            detailVC.bookData = selectedBook
            present(detailVC, animated: true, completion: nil)
        }
    }
}

#Preview {
    SearchViewController()
}

