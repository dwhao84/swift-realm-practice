//
//  FirstViewController.swift
//  swift-realm-practice
//
//  Created by Dawei Hao on 2025/3/27.
//

import UIKit
import RealmSwift

class FirstViewController: UIViewController {
    
    // MARK: - Properties
    private let productNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "貨號 (Product Number)"
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let productLocationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "位置 (Location)"
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let quantityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "數量 (Quantity)"
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .numberPad
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("送出", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.navigationItem.title = "輸入資料"
        view.backgroundColor = .systemBackground
        
        // Add subviews
        view.addSubview(productNumberTextField)
        view.addSubview(productLocationTextField)
        view.addSubview(quantityTextField)
        view.addSubview(submitButton)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Product number text field
            productNumberTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            productNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            productNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            productNumberTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Product location text field
            productLocationTextField.topAnchor.constraint(equalTo: productNumberTextField.bottomAnchor, constant: 20),
            productLocationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            productLocationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            productLocationTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Quantity text field
            quantityTextField.topAnchor.constraint(equalTo: productLocationTextField.bottomAnchor, constant: 20),
            quantityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            quantityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            quantityTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Submit button
            submitButton.topAnchor.constraint(equalTo: quantityTextField.bottomAnchor, constant: 40),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    private func setupActions() {
        // Add target action to submit button
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        // Setup gesture to dismiss keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Set delegates for text fields
        productNumberTextField.delegate = self
        quantityTextField.delegate = self
    }
    
    @objc private func submitButtonTapped() {
        guard let productNumber = productNumberTextField.text, !productNumber.isEmpty else {
            showAlert(message: "請輸入貨號")
            return
        }
        
        guard let productLocation = productLocationTextField.text, !productLocation.isEmpty else {
            showAlert(message: "請輸入位置")
            return
        }
        
        guard let quantityText = quantityTextField.text, !quantityText.isEmpty,
              let quantity = Int(quantityText) else {
            showAlert(message: "請輸入正確的數量")
            return
        }
        
        // 創建新的產品對象
        let product = Product(articleNumber: productNumber, location: productLocation, qty: quantity)
        
        // 保存到 Realm 數據庫
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(product)
            }
            
            // 清空輸入欄位
            productNumberTextField.text = ""
            productLocationTextField.text = ""
            quantityTextField.text = ""
            
            // 將焦點設定到第一個輸入欄位
            productNumberTextField.becomeFirstResponder()
            
            // 顯示成功訊息
            showAlert(message: "已成功保存! 貨號: \(productNumber), 位置: \(productLocation), 數量: \(quantity)")
        } catch {
            showAlert(message: "保存失敗: \(error.localizedDescription)")
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension FirstViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == productNumberTextField {
            productLocationTextField.becomeFirstResponder()
        } else if textField == productLocationTextField {
            quantityTextField.becomeFirstResponder()
        } else if textField == quantityTextField {
            textField.resignFirstResponder()
            submitButtonTapped()
        }
        return true
    }
}

#Preview {
    UINavigationController(rootViewController: FirstViewController())
}
