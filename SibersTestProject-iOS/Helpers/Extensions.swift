//
//  Extensions.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/5/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import UIKit

extension UILabel {
  convenience init(text: String, font: UIFont) {
    self.init(frame: .zero)
    self.text = text
    self.font = font
  }
}

extension UIImageView {
  convenience init(cornerRadius: CGFloat) {
    self.init(image: nil)
    self.layer.cornerRadius = cornerRadius
    self.clipsToBounds = true
    self.contentMode = .scaleAspectFill
  }
}
