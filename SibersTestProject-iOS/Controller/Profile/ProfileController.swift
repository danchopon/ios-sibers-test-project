//
//  ProfileController.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/3/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import UIKit
import GoogleSignIn

class ProfileController: UIViewController {
  
  private lazy var userName: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var signOutButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Sign Out", for: .normal)
    button.backgroundColor = .red
    button.layer.cornerRadius = 10
    button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    button.addTarget(self, action: #selector(handleSignOut), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    
    if let fullName = UserDefaults.standard.string(forKey: "fullName") {
      userName.text = "Hello, \(fullName)"
    }
    
  }
  
  @objc func handleSignOut(_ sender: UIButton) {
    print("signOut button tap")
    GIDSignIn.sharedInstance().signOut()
    let alert = UIAlertController(title: "Sign Out", message: "Are you sure? Do you really want to sign out?", preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
      let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
      appDel.window?.rootViewController = SignInController()
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
    
    DispatchQueue.main.async(execute: {
      self.present(alert, animated: true, completion: nil)
    })
  }
  
  private func setup() {
    setupViews()
    setupConstraints()
  }
  
  private func setupViews() {
    view.addSubview(userName)
    view.addSubview(signOutButton)
  }
  
  private func setupConstraints() {
    let userNameConstraints = [
      userName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      userName.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ]
    NSLayoutConstraint.activate(userNameConstraints)
    
    let signOutButtonConstraints = [
      signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      signOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
    ]
    NSLayoutConstraint.activate(signOutButtonConstraints)
  }
  
}
