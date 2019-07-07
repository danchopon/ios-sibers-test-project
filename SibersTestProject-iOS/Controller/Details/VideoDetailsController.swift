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
  
  private lazy var stackView: UIStackView = {
    let sv = UIStackView()
    sv.translatesAutoresizingMaskIntoConstraints = false
    return sv
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getVideoInformation()
    webView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250))
    
    webView.load(URLRequest(url: videoURL))
    videoView.addSubview(webView)
    setup()
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
    
    informationView.addSubview(titleLabel)
    informationView.addSubview(descriptionLabel)
    
    contentView.addSubview(videoView)
    contentView.addSubview(informationView)
    
    scrollView.addSubview(contentView)
    
    self.view.addSubview(scrollView)
  }
  
  private func setupConstraints() {
    
    let height = descriptionLabel.requiredHeight + titleLabel.requiredHeight + webView.frame.height + 500
        
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
      contentView.bottomAnchor.constraint(equalTo: informationView.bottomAnchor)
    ]
    NSLayoutConstraint.activate(informationViewConstraints)

    let titleLabelConstraints = [
      titleLabel.topAnchor.constraint(equalTo: informationView.topAnchor, constant: 8),
      titleLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor),
      informationView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
    ]
    NSLayoutConstraint.activate(titleLabelConstraints)

    let descriptionLabelConstraints = [
      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
      descriptionLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor),
      informationView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
      informationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ]
    NSLayoutConstraint.activate(descriptionLabelConstraints)
  }
  
  private func getVideoInformation() {
    Service.shared.fetchVideo(id: videoId) { (res, err) in
      if let err = err {
        print("Error occured: ", err)
      }
      
      DispatchQueue.main.async {
        self.titleLabel.text = res?.items[0].snippet.title
        
        let attributedString = NSMutableAttributedString(string: (res?.items[0].snippet.description)!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.descriptionLabel.attributedText = attributedString
        
        self.setupConstraints()
      }
      
    }
  }
  
}
