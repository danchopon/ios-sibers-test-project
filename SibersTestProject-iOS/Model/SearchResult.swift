//
//  SearchResult.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/3/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import Foundation

struct SearchResultResponse: Decodable {
  let resultCount: Int
  let results: [SearchResult]
}

struct SearchResult: Decodable {
  let trackName: String
  let primaryGenreName: String
  let averageUserRating: Float?
  let screenshotUrls: [String]
  let artworkUrl100: String
}
