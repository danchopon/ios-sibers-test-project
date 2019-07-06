//
//  Trending.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/5/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import Foundation

struct TrendingResponse: Decodable {
  let kind: String
  let etag: String
  let nextPageToken: String?
  let pageInfo: PageInfo
  let items: [Item]
}

struct PageInfo: Decodable {
  let totalResults, resultsPerPage: Int
}

struct Item: Decodable {
  let id: String
  let snippet: Snippet
  let statistics: Statistics
}

struct Snippet: Decodable {
  let publishedAt, channelId, title, description: String
  let channelTitle, categoryId: String?
  let thumbnails: Thumbnails
}

struct Thumbnails: Codable {
  let thumbnailsDefault, medium, high: Default
  
  enum CodingKeys: String, CodingKey {
    case thumbnailsDefault = "default"
    case medium, high
  }
}

struct Default: Codable {
  let url: String
  let width, height: Int?
}

struct Statistics: Decodable {
  let viewCount, likeCount, dislikeCount, favoriteCount: String
  let commentCount: String
}
