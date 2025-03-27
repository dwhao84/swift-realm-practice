//
//  TabBarController.swift
//  swift-realm-practice
//
//  Created by Dawei Hao on 2025/3/27.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設置 Tab Bar 的外觀
        setupTabBarAppearance()
        // 設置兩個頁面的視圖控制器
        setupViewControllers()
    }
    
    private func setupTabBarAppearance() {
        // 自定義 Tab Bar 外觀
        tabBar.tintColor = .systemBlue       // 選中項目的顏色
        tabBar.unselectedItemTintColor = .gray   // 未選中項目的顏色
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupViewControllers() {
        // 創建第一個視圖控制器 (FirstViewController)
        let firstVC = FirstViewController()
        let firstNavController = UINavigationController(rootViewController: firstVC)
        firstNavController.tabBarItem = UITabBarItem(
            title: "輸入",
            image: UIImage(systemName: "square.and.pencil"),
            selectedImage: UIImage(systemName: "square.and.pencil.fill")
        )
        
        // 創建第二個視圖控制器 (DataViewController)
        // 假設你已經有 DataViewController 類，如果沒有請自行創建
        let dataVC = DetailViewController()
        let dataNavController = UINavigationController(rootViewController: dataVC)
        dataNavController.tabBarItem = UITabBarItem(
            title: "數據",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet.fill")
        )
        
        // 設置視圖控制器到 TabBarController
        self.viewControllers = [firstNavController, dataNavController]
    }
}
