//
//  CommentCell.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/8/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
  
  var result: CommentItem! {
    didSet {
      
      let topLevelCommentSnippet = result.snippet.topLevelComment.snippet
      
      let imageUrl = topLevelCommentSnippet.authorProfileImageUrl
      
      authorProfileImageUrl.loadImageUsingCache(withUrl: imageUrl)
      
      authorName.text = topLevelCommentSnippet.authorDisplayName
      
      let attributedString = NSMutableAttributedString(string: topLevelCommentSnippet.textOriginal)
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineSpacing = 3
      attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
      textOriginal.attributedText = attributedString
      
      var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
      dateFormatter.calendar = Calendar(identifier: .iso8601)
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      let date = dateFormatter.date(from: topLevelCommentSnippet.publishedAt)!
      dateFormatter.dateFormat = "MM.dd.yyyy HH:mm"
      publishedAt.text = dateFormatter.string(from: date)
      
    }
  }
  
  private lazy var authorProfileImageUrl: UIImageView = {
    let imageView = UIImageView()
    imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
    imageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    imageView.layer.cornerRadius = 5
    imageView.layer.masksToBounds = true
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.image = UIImage(named: "rose")
    return imageView
  }()
  
  private lazy var authorName: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    return label
  }()
  
  private lazy var publishedAt: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .darkGray
    return label
  }()
  
  private lazy var textOriginal: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let stackView = VerticalStackView(arrangedSubviews: [
      HorizontalStackView(arrangedSubviews: [
        
        VerticalStackView(arrangedSubviews: [
          authorName, publishedAt
          ], spacing: 4),
        authorProfileImageUrl,
        
        ], spacing: 8, alignment: .center),
      textOriginal
      ])
    stackView.spacing = 4
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(stackView)
    
    stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
    stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
