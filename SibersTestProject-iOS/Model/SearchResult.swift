//
//  SearchResult.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/3/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import Foundation

struct SearchResultResponse: Decodable {
  let kind, etag, nextPageToken, regionCode: String
  let pageInfo: PageInfo
  let items: [SearchItem]
}

struct SearchItem: Decodable {
  let etag: String
  let id: ID?
  let snippet: Snippet?
}

struct ID: Decodable {
  let kind: IDKind
  let channelId: String?
  let videoId: String?
}

enum IDKind: String, Codable {
  case youtubeChannel = "youtube#channel"
  case youtubeVideo = "youtube#video"
}
