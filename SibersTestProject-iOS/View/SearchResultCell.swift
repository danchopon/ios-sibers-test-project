//
//  SearchResultCell.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/3/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
  
  var result: SearchResult! {
    didSet {
      nameLabel.text = result.trackName
      categoryLabel.text = result.primaryGenreName
      ratingsLabel.text = "Rating: \(result.averageUserRating ?? 0)"
    }
  }
  
  let thumbnailImageView: UIImageView = {
    let iv = UIImageView()
    iv.widthAnchor.constraint(equalToConstant: 64).isActive = true
    iv.heightAnchor.constraint(equalToConstant: 64).isActive = true
    iv.layer.cornerRadius = 12
    iv.clipsToBounds = true
    return iv
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "APP NAME"
    return label
  }()
  
  let categoryLabel: UILabel = {
    let label = UILabel()
    label.text = "Photos & Video"
    return label
  }()
  
  let ratingsLabel: UILabel = {
    let label = UILabel()
    label.text = "9.26M"
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
