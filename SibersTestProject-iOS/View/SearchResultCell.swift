//
//  SearchResultCell.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/3/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
  
  var result: SearchItem! {
    didSet {
      let imageUrl = result.snippet?.thumbnails.medium.url
      
      thumbnailImageView.loadImageUsingCache(withUrl: imageUrl!)
      
      titleLabel.text = result.snippet?.title
      channelNameLabel.text = result.snippet?.channelTitle
      viewsLabel.text = "1000 views"
    }
  }
  
  func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
  }
  
  func downloadImage(from url: URL) {
    print("Download Started")
    getData(from: url) { data, response, error in
      guard let data = data, error == nil else { return }
      print(response?.suggestedFilename ?? url.lastPathComponent)
      print("Download Finished")
      DispatchQueue.main.async() {
        self.thumbnailImageView.image = UIImage(data: data)
      }
    }
  }
  
  let thumbnailImageView: UIImageView = {
    let iv = UIImageView()
    iv.widthAnchor.constraint(equalToConstant: 120).isActive = true
    iv.heightAnchor.constraint(equalToConstant: 90).isActive = true
    iv.clipsToBounds = true
    iv.contentMode = .scaleAspectFit
    return iv
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 3
    return label
  }()
  
  let channelNameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 15)
    label.textColor = .darkGray
    return label
  }()
  
  let viewsLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = .darkGray
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
        
    let stackView = UIStackView(arrangedSubviews: [
      thumbnailImageView,
      VerticalStackView(arrangedSubviews: [
        titleLabel,
        HorizontalStackView(arrangedSubviews: [
          channelNameLabel,
          viewsLabel
          ], spacing: 0, alignment: .leading)
        ], spacing: 4)])
    stackView.spacing = 8
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(stackView)
    stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
    stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
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
