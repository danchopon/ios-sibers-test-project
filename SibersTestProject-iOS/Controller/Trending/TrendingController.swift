//
//  TrendingController.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/4/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import UIKit

class TrendingController: UICollectionViewController {
  
  fileprivate let cellId = "cellId"
  fileprivate let footerId = "footerId"
  
  fileprivate var results = [TrendingItem]()
  fileprivate var nextPageToken: String = "token"
  
  init() {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    fetchTrendings()
  }
  
  fileprivate func fetchTrendings() {
    Service.shared.fetchTrendingVideos { (res, err) in
      if let err = err {
        print("Trending videos err: ", err)
      }
      self.results = res?.items ?? []

      if let nextPageToken = res?.nextPageToken {
        self.nextPageToken = nextPageToken
      }
      
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
  
  fileprivate func setupViews() {
    collectionView.backgroundColor = .white
    collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: cellId)
    collectionView.register(LoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
    return footer
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return .init(width: view.frame.width, height: 100)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return results.count
  }
  
  var isPaginating = false
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TrendingCell
    cell.result = results[indexPath.item]
    
    if indexPath.item == results.count - 1 && !isPaginating {
      
      isPaginating = true

      Service.shared.fetchNextTrendingVideos(nextPageToken: nextPageToken) { (res, err) in
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
    let detailsVC = VideoDetailsController(id: results[indexPath.item].id)
    self.navigationController?.pushViewController(detailsVC, animated: true)
  }
  
}

extension TrendingController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 250)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 0, left: 0, bottom: 0, right: 0)
  }
}
