//
//  VideosSearchController.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/3/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import UIKit

class SearchController: UICollectionViewController {
  
  fileprivate let cellId = "cellId"
  
  var timer: Timer?
  
  fileprivate let searchController = UISearchController(searchResultsController: nil)
  
  fileprivate let enterSearchTermLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Please enter search term above..."
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 17)
    return label
  }()
  
  init() {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
    setupSearchBar()
  }
  
  fileprivate func setupViews() {
    collectionView.backgroundColor = .white
    collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.addSubview(enterSearchTermLabel)
  }
  
  fileprivate func setupConstraints() {
    let enterSearchTermLabelConstraints = [
//      enterSearchTermLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
//      enterSearchTermLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
//      enterSearchTermLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 50)
      enterSearchTermLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      enterSearchTermLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ]
    NSLayoutConstraint.activate(enterSearchTermLabelConstraints)
  }
  
  fileprivate func setupSearchBar() {
    definesPresentationContext = true
    navigationItem.searchController = self.searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
  }

  fileprivate var results = [SearchResult]()
  
  fileprivate func fetchITunesApps() {
//    Service.shared.fetchApps(searchTerm: "twitter") { (res, err) in
//      if let err = err {
//        print("Failed to fetch apps:", err)
//        return
//      }
//      self.results = res?.results ?? []
//      DispatchQueue.main.async {
//        self.collectionView.reloadData()
//      }
//    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    enterSearchTermLabel.isHidden = results.count != 0
    return results.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
    cell.result = results[indexPath.item]
    return cell
  }
  
}

extension SearchController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 325)
  }
}

extension SearchController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
    
//    timer?.invalidate()
//    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
//      Service.shared.fetchApps(searchTerm: searchText) { (res, err) in
//        self.results = res?.results ?? []
//        DispatchQueue.main.async {
//          self.collectionView.reloadData()
//        }
//      }
//    })
  }
}
