//
//  BaseTabBarViewController.swift
//  SearchRepositoryApp
//
//  Created by 이아연 on 2021/07/27.
//

import UIKit

class BaseTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setTabbarVC()
    }
}

extension BaseTabBarViewController {
    func setTabbarVC () {
        let searchTab = SearchViewController()
        self.viewControllers = [UINavigationController(rootViewController: searchTab)]
    }
}
