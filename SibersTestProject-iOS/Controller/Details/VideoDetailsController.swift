//
//  VideoDetailsController.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/7/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import UIKit
import WebKit

class VideoDetailsController: UIViewController, WKNavigationDelegate {
  
  private var webView: WKWebView!
  
  let videoURL: URL
  
  private var videoId: String!
  private let cellId = "cellId"
  private let footerId = "footerId"
  
  fileprivate var results = [CommentItem]()
  fileprivate var nextPageToken: String = "token"
  
  init(id: String) {
    videoURL = URL(string: "https://www.youtube.com/embed/\(id)")!
    videoId = id
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  private lazy var scrollView: UIScrollView = {
    let sv = UIScrollView()
    sv.translatesAutoresizingMaskIntoConstraints = false
    return sv
  }()
  
  private lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var videoView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var informationView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.font = UIFont.boldSystemFont(ofSize: 22)
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    return label
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .darkGray
    label.font = UIFont.systemFont(ofSize: 14)
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    return label
  }()
  
  private lazy var publishedAt: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .darkGray
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  
  private lazy var viewsCount: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .darkGray
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  
  private lazy var likesCount: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .darkGray
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  
  private lazy var dislikesCount: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .darkGray
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  
  private let commentsLabel = UILabel(text: "Comments", font: .systemFont(ofSize: 22, weight: .bold))
  
  private lazy var collectionView: UICollectionView = {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 10
    
    let cv = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.backgroundColor = .white
    return cv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getVideoInformation()
    webView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250))
    
    webView.load(URLRequest(url: videoURL))
    videoView.addSubview(webView)
    setup()
    getVideoComments()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationController?.navigationBar.isTranslucent = false
    tabBarController?.tabBar.isHidden = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    tabBarController?.tabBar.isHidden = false
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func setup() {
    setupViews()
  }
  
  private func setupViews() {
    view.backgroundColor = .white
    informationView.addSubview(publishedAt)
    informationView.addSubview(viewsCount)
    informationView.addSubview(likesCount)
    informationView.addSubview(dislikesCount)
    informationView.addSubview(titleLabel)
    informationView.addSubview(descriptionLabel)
    
    contentView.addSubview(videoView)
    contentView.addSubview(informationView)
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.register(LoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
    
    commentsLabel.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(commentsLabel)
    contentView.addSubview(collectionView)
    
    scrollView.addSubview(contentView)
    
    self.view.addSubview(scrollView)
  }
  
  private func setupConstraints() {
    
    let height = descriptionLabel.requiredHeight + titleLabel.requiredHeight + webView.frame.height + collectionView.frame.height + 500
        
    let scrollViewConstraints = [
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
    ]
    NSLayoutConstraint.activate(scrollViewConstraints)
    
    let contentViewConstraints = [
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 30),
      contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
      contentView.heightAnchor.constraint(equalToConstant: height)
    ]
    NSLayoutConstraint.activate(contentViewConstraints)
    
    let videoViewConstraints = [
      videoView.topAnchor.constraint(equalTo: contentView.topAnchor),
      videoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      videoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      videoView.heightAnchor.constraint(equalToConstant: webView.frame.height)
    ]
    NSLayoutConstraint.activate(videoViewConstraints)
    
    let informationViewConstraints = [
      informationView.topAnchor.constraint(equalTo: videoView.bottomAnchor),
      informationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      contentView.trailingAnchor.constraint(equalTo: informationView.trailingAnchor, constant: 10),
//      contentView.bottomAnchor.constraint(equalTo: informationView.bottomAnchor)
    ]
    NSLayoutConstraint.activate(informationViewConstraints)
    
    let publishedAtConstraints = [
      publishedAt.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 8),
      publishedAt.leadingAnchor.constraint(equalTo: informationView.leadingAnchor),
      informationView.trailingAnchor.constraint(equalTo: publishedAt.trailingAnchor),
    ]
    NSLayoutConstraint.activate(publishedAtConstraints)

    let viewsCountConstraints = [
      viewsCount.topAnchor.constraint(equalTo: publishedAt.bottomAnchor, constant: 8),
      viewsCount.leadingAnchor.constraint(equalTo: informationView.leadingAnchor),
      informationView.trailingAnchor.constraint(equalTo: viewsCount.trailingAnchor),
    ]
    NSLayoutConstraint.activate(viewsCountConstraints)
    
    let likesCountConstraints = [
      likesCount.topAnchor.constraint(equalTo: viewsCount.bottomAnchor, constant: 8),
      likesCount.leadingAnchor.constraint(equalTo: informationView.leadingAnchor),
      informationView.trailingAnchor.constraint(equalTo: likesCount.trailingAnchor),
    ]
    NSLayoutConstraint.activate(likesCountConstraints)
    
    let dislikesCountConstraints = [
      dislikesCount.topAnchor.constraint(equalTo: likesCount.bottomAnchor, constant: 8),
      dislikesCount.leadingAnchor.constraint(equalTo: informationView.leadingAnchor),
      informationView.trailingAnchor.constraint(equalTo: dislikesCount.trailingAnchor),
    ]
    NSLayoutConstraint.activate(dislikesCountConstraints)

    let titleLabelConstraints = [
      titleLabel.topAnchor.constraint(equalTo: dislikesCount.bottomAnchor, constant: 8),
      titleLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor),
      informationView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
    ]
    NSLayoutConstraint.activate(titleLabelConstraints)
    
    let descriptionLabelConstraints = [
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
      descriptionLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor),
      informationView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
      informationView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor)
//      informationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ]
    NSLayoutConstraint.activate(descriptionLabelConstraints)
    
    let commentsLabelConstraints = [
      commentsLabel.topAnchor.constraint(equalTo: informationView.bottomAnchor, constant: 24),
      commentsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      contentView.trailingAnchor.constraint(equalTo: commentsLabel.trailingAnchor, constant: -8)
    ]
    NSLayoutConstraint.activate(commentsLabelConstraints)
    
    let collectionViewConstraints = [
      collectionView.topAnchor.constraint(equalTo: commentsLabel.bottomAnchor, constant: 8),
      collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
      
    ]
    NSLayoutConstraint.activate(collectionViewConstraints)
  }
  
  private func getVideoInformation() {
    Service.shared.fetchVideo(id: videoId) { (res, err) in
      if let err = err {
        print("Error occured: ", err)
      }
      
      DispatchQueue.main.async {
        self.titleLabel.text = res?.items[0].snippet.title
        
        guard let viewCount = Double(res!.items[0].statistics.viewCount) else { return }
        guard let likesCount = Double(res!.items[0].statistics.likeCount) else { return }
        guard let dislikesCount = Double(res!.items[0].statistics.dislikeCount) else { return }
        
        var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: res!.items[0].snippet.publishedAt)!
        dateFormatter.dateFormat = "MMM d, yyyy"
        self.publishedAt.text = "Published on \(dateFormatter.string(from: date))"
        
        self.viewsCount.text = "Views: \(viewCount.kmFormatted)"
        self.likesCount.text = "Likes: \(likesCount.kmFormatted)"
        self.dislikesCount.text = "Dislikes: \(dislikesCount.kmFormatted)"
        
        let attributedString = NSMutableAttributedString(string: (res?.items[0].snippet.description)!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.descriptionLabel.attributedText = attributedString
        
        self.titleLabel.layoutIfNeeded()
        self.descriptionLabel.layoutIfNeeded()
        
        self.setupConstraints()
      }
      
    }
  }
  
  private func getVideoComments() {
    Service.shared.fetchVideoComments(id: videoId) { (res, err) in
      if let err = err {
        print("Cannot fetch comments: ", err)
      }
      
      if let res = res {
        self.results = res.items
        self.nextPageToken = res.nextPageToken
      }
      
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
      
    }
  }
  
  var isPaginating = false

  
}

extension VideoDetailsController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
    let referenceHeight: CGFloat = 140
    let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
      - sectionInset.left
      - sectionInset.right
      - collectionView.contentInset.left
      - collectionView.contentInset.right
    return CGSize(width: referenceWidth, height: referenceHeight)
  }
  
}

extension VideoDetailsController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
    return footer
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return .init(width: view.frame.width, height: 100)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return results.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
    cell.result = results[indexPath.item]
    
    if indexPath.item == results.count - 1 && !isPaginating {
      
      isPaginating = true
      
      Service.shared.fetchNextVideoComments(id: videoId, nextPageToken: nextPageToken) { (res, err) in
        if let err = err {
          print("Cannot fetch next videos: ", err)
        }
        
        sleep(2)
        if let nextPageToken = res?.nextPageToken {
          self.nextPageToken = nextPageToken
          self.results += res!.items
          DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.layoutIfNeeded()
            self.contentView.layoutIfNeeded()
            self.view.layoutIfNeeded()
            self.scrollView.layoutIfNeeded()
          }
          self.isPaginating = false
        }
        
      }
      
    }

    
    return cell
  }
}
