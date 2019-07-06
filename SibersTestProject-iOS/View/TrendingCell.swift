//
//  TrendingCell.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/6/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import UIKit

class TrendingCell: UICollectionViewCell {
  
  var result: TrendingItem! {
    didSet {
      let imageUrl = result.snippet.thumbnails.medium.url
      
      thumbnailImageView.loadImageUsingCache(withUrl: imageUrl)
      
      titleLabel.text = result.snippet.title
      channelNameLabel.text = result.snippet.channelTitle
      guard let viewCount = Double(result.statistics.viewCount) else { return }
      viewsLabel.text = "\(viewCount.kmFormatted) views"
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
    iv.clipsToBounds = true
    iv.contentMode = .scaleAspectFill
    return iv
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
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
    label.font = UIFont.systemFont(ofSize: 15)
    label.textColor = .darkGray
    return label
  }()
  
  let dotLabel: UILabel = {
    let label = UILabel()
    label.text = "•"
    label.font = UIFont.systemFont(ofSize: 12)
    label.textColor = .darkGray
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let stackView = VerticalStackView(arrangedSubviews: [
      thumbnailImageView,
      titleLabel,
      HorizontalStackView(arrangedSubviews: [
        viewsLabel, dotLabel, channelNameLabel
        ], spacing: 4, alignment: .center)
      ], spacing: 8)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(stackView)
    stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    
    thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
    thumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
