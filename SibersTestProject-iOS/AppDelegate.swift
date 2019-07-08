//
//  AppDelegate.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/3/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import UIKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    window?.rootViewController = UINavigationController(rootViewController: SignInController())
    
    GIDSignIn.sharedInstance().clientID = "770009251770-p64a59vvh1ust1biq27citgvl4gcplgb.apps.googleusercontent.com"
    GIDSignIn.sharedInstance().delegate = self
    
    return true
    
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return GIDSignIn.sharedInstance().handle(url as URL?,
                                              sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String,
                                              annotation: options[UIApplication.OpenURLOptionsKey.annotation])
  }
  
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    if let error = error {
      print("\(error.localizedDescription)")
    } else {
      // Perform any operations on signed in user here.
      let userId = user.userID                  // For client-side use only!
      let idToken = user.authentication.idToken // Safe to send to the server
      let fullName = user.profile.name
      let givenName = user.profile.givenName
      let familyName = user.profile.familyName
      let email = user.profile.email
      let accessToken = user.authentication.accessToken
      
      UserDefaults.standard.set(fullName, forKey: "fullName")
      
      window?.rootViewController = BaseTabBarController()
    }
  }
  
  func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    print("User has disconnected")
  }
  

}

