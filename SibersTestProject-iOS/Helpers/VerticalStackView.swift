//
//  VerticalStackView.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/5/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import UIKit

class VerticalStackView: UIStackView {
  
  init(arrangedSubviews: [UIView], spacing: CGFloat = 0) {
    super.init(frame: .zero)
    
    arrangedSubviews.forEach({addArrangedSubview($0)})
    
    self.spacing = spacing
    self.axis = .vertical
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
