//
//  AppDelegate.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/3/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    window?.rootViewController = UINavigationController(rootViewController: ViewController())
    
    return true
    
  }

}

