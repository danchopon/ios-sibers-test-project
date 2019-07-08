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
  fileprivate let footerId = "footerId"
  
  fileprivate var nextPageToken: String = "token"
  
  fileprivate var results = [SearchItem]()
  
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
    collectionView.register(LoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
    collectionView.addSubview(enterSearchTermLabel)
  }
  
  fileprivate func setupConstraints() {
    let enterSearchTermLabelConstraints = [
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
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    enterSearchTermLabel.isHidden = results.count != 0
    return results.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
    return footer
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return .init(width: view.frame.width, height: 100)
  }
  
  var isPaginating = false
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
    cell.result = results[indexPath.item]
    
    if indexPath.item == results.count - 1 && !isPaginating {
      
      isPaginating = true
      
      Service.shared.fetchNextFoundVideos(nextPageToken: nextPageToken) { (res, err) in
        if let err = err {
          print("Cannot fetch next videos: ", err)
        }
        
        sleep(2)
        if let nextPageToken = res?.nextPageToken {
          self.nextPageToken = nextPageToken
          self.results += res!.items
          DispatchQueue.main.async {
            self.collectionView.reloadData()
          }
          self.isPaginating = false
        }
        
      }
      
    }
    
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let videoId = results[indexPath.item].id?.videoId {
      let detailsVC = VideoDetailsController(id: videoId)
      self.navigationController?.pushViewController(detailsVC, animated: true)
    }
  }
  
}

extension SearchController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 80)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 0, left: 0, bottom: 0, right: 0)
  }
}

extension SearchController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    Service.shared.fetchFoundVideos(searchTerm: searchBar.text!) { (res, err) in
      self.results = res?.items ?? []
      
      if let nextPageToken = res?.nextPageToken {
        self.nextPageToken = nextPageToken
      }
      
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
}
