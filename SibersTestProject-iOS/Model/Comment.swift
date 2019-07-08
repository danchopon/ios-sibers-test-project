//
//  Comment.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/8/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import Foundation

struct CommentResponse: Codable {
  let kind, etag, nextPageToken: String
  let items: [CommentItem]
}

struct CommentItem: Codable {
  let id: String
  let snippet: CommentSnippet
}

struct CommentSnippet: Codable {
  let topLevelComment: TopLevelComment
}

struct TopLevelComment: Codable {
  let snippet: TopLevelCommentSnippet
}

struct TopLevelCommentSnippet: Codable {
  let authorDisplayName: String
  let authorProfileImageUrl: String
  let authorChannelUrl: String
  let textDisplay, textOriginal: String
  let likeCount: Int
  let publishedAt: String
}
