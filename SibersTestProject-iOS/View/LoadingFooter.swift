//
//  LoadingFooter.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/7/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import UIKit

class LoadingFooter: UICollectionReusableView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let aiv = UIActivityIndicatorView(style: .whiteLarge)
    aiv.color = .darkGray
    aiv.startAnimating()
    
    let label = UILabel(text: "Loading more...", font: .systemFont(ofSize: 16))
    label.textAlignment = .center
    
    let stackView = VerticalStackView(arrangedSubviews: [
      aiv, label
      ], spacing: 8)
    
    addSubview(stackView)

    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    stackView.widthAnchor.constraint(equalToConstant: 200).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
}
