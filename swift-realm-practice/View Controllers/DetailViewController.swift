//
//  MainViewController.swift
//  swift-realm-practice
//
//  Created by Dawei Hao on 2025/3/27.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView()
        
    private var products: Results<Product>?
    // MARK: - 把products變成Realm的container的種類，讓Realm可以變成物件。
    /*
    `Results` is an auto-updating container type in Realm returned from object queries.
    `Results` can be queried with the same predicates as `List<Element>`, and you can
    chain queries to further filter query results.
    */
    
    private let realm = try! Realm() // 用try的寫法，串接Realm
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "庫存數據"
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 每次頁面出現時重新讀取數據
        loadData()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 添加右上角的刷新按鈕
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshData)
        )
    }
    
    // MARK: - Data Handling
    //
    private func loadData() {
        // 按照時間戳降序排列，最新的數據在前面
        products = realm.objects(Product.self).sorted(byKeyPath: "timestamp", ascending: false)
        tableView.reloadData()
    }
    
    @objc private func refreshData() {
        loadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        
        if let product = products?[indexPath.row] {
            // 設置 cell 顯示格式
            var content = cell.defaultContentConfiguration()
            content.text = "貨號: \(product.articleNumber) - 位置: \(product.location)"
            content.secondaryText = "數量: \(product.qty)"
            cell.contentConfiguration = content
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let product = products?[indexPath.row] {
                try? realm.write {
                    realm.delete(product)
                }
                loadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 可以在這裡添加點擊後的詳細資訊顯示
        if let product = products?[indexPath.row] {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: product.timestamp)
            
            let message = """
            貨號: \(product.articleNumber)
            位置: \(product.location)
            數量: \(product.qty)
            時間: \(dateString)
            """
            
            let alert = UIAlertController(title: "產品詳情", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default))
            present(alert, animated: true)
        }
    }
}

#Preview {
    UINavigationController(rootViewController: DetailViewController())
}
