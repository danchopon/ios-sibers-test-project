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

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
  convenience init(cornerRadius: CGFloat) {
    self.init(image: nil)
    self.layer.cornerRadius = cornerRadius
    self.clipsToBounds = true
    self.contentMode = .scaleAspectFill
  }
  
  func loadImageUsingCache(withUrl urlString : String) {
    let url = URL(string: urlString)
    if url == nil {return}
    self.image = nil
    
    // check cached image
    if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
      self.image = cachedImage
      return
    }
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
    addSubview(activityIndicator)
    activityIndicator.startAnimating()
    activityIndicator.center = self.center
    
    // if not, download image from url
    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
      if error != nil {
        print(error!)
        return
      }
      
      DispatchQueue.main.async {
        if let image = UIImage(data: data!) {
          imageCache.setObject(image, forKey: urlString as NSString)
          self.image = image
          activityIndicator.removeFromSuperview()
        }
      }
      
    }).resume()
  }
}

extension Double {
  var kmFormatted: String {
    
    if self >= 10000, self <= 999999 {
      return String(format: "%.1fK", locale: Locale.current,self/1000).replacingOccurrences(of: ".0", with: "")
    }
    
    if self > 999999 {
      return String(format: "%.1fM", locale: Locale.current,self/1000000).replacingOccurrences(of: ".0", with: "")
    }
    
    return String(format: "%.0f", locale: Locale.current,self)
  }
}
