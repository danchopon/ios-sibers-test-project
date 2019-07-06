//
//  BaseTabBarController.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/3/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewControllers = [
      createNavController(viewController: SearchController(), title: "Search", imageName: "search"),
      createNavController(viewController: UIViewController(), title: "Home", imageName: "home"),
      createNavController(viewController: TrendingController(), title: "Trending", imageName: "fire"),
      createNavController(viewController: ProfileController(), title: "Profile", imageName: "profile")
    ]
    
    if let fullName = UserDefaults.standard.string(forKey: "fullName") {
      print("defaults savedString: \(fullName)")
    }
  }
  
  fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
    
    let navController = UINavigationController(rootViewController: viewController)
    navController.navigationBar.prefersLargeTitles = true
    viewController.navigationItem.title = title
    viewController.view.backgroundColor = .white
    navController.tabBarItem.title = title
    navController.tabBarItem.image = UIImage(named: imageName)
    return navController
    
  }
  
}
