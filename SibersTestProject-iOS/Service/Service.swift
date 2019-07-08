//
//  Service.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/3/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import Foundation
import GoogleSignIn

class Service {
  static let shared = Service()
  private let API_KEY = "AIzaSyDsOlURUNY-IEyhfvHxlXVH8PMTCAZ7x60"
  static let scopes = [
    "https://www.googleapis.com/auth/youtube.force-ssl",
    "https://www.googleapis.com/auth/youtube",
    "https://www.googleapis.com/auth/youtube.readonly"
  ]
  private let baseUrl = "https://www.googleapis.com/youtube/v3"
  
  func fetchTrendingVideos(completion: @escaping (TrendingResponse?, Error?) -> ()) {
    let urlString = "\(baseUrl)/videos"
    
    let parameters = [
      "part": "snippet+contentDetails+statistics",
      "chart": "mostPopular",
      "regionCode": "US",
      "key":API_KEY
    ]
    
    fetchGenericJSONData(urlString: urlString, parameters: parameters, completion: completion)
  }
  
  func fetchFoundVideos(searchTerm: String, completion: @escaping (SearchResultResponse?, Error?) -> ()) {
    let urlString = "\(baseUrl)/search"
    
    let parameters = [
      "part": "snippet",
      "maxResults": "15",
      "q": searchTerm.replacingOccurrences(of: " ", with: "%20"),
      "key": API_KEY
    ]
    
    fetchGenericJSONData(urlString: urlString, parameters: parameters, completion: completion)
    
  }
  
  func fetchNextFoundVideos(nextPageToken: String, completion: @escaping (SearchResultResponse?, Error?) -> ()) {
    let urlString = "\(baseUrl)/search"
    
    let parameters = [
      "pageToken": nextPageToken,
      "part": "snippet",
      "maxResults": "15",
      "key": API_KEY
    ]
    
    fetchGenericJSONData(urlString: urlString, parameters: parameters, completion: completion)
  }
  
  func fetchNextTrendingVideos(nextPageToken: String, completion: @escaping (TrendingResponse?, Error?) -> ()) {
    let urlString = "\(baseUrl)/videos"

    let parameters = [
      "part": "snippet+contentDetails+statistics",
      "chart": "mostPopular",
      "regionCode": "US",
      "pageToken": nextPageToken,
      "key":API_KEY
    ]
    
    fetchGenericJSONData(urlString: urlString, parameters: parameters, completion: completion)
  }
  
  func fetchVideoComments(id: String, completion: @escaping (CommentResponse?, Error?) -> ()) {
    let urlString = "\(baseUrl)/commentThreads"
    
    let parameters = [
      "part": "snippet+replies",
      "videoId": id,
      "key":API_KEY
    ]
    
    fetchGenericJSONData(urlString: urlString, parameters: parameters, completion: completion)
  }
  
  func fetchNextVideoComments(id: String, nextPageToken: String, completion: @escaping (CommentResponse?, Error?) -> ()) {
    let urlString = "\(baseUrl)/commentThreads"
    
    let parameters = [
      "part": "snippet+replies",
      "videoId": id,
      "pageToken": nextPageToken,
      "key":API_KEY
    ]
    
    fetchGenericJSONData(urlString: urlString, parameters: parameters, completion: completion)
  }
  
  func fetchVideo(id: String, completion: @escaping (TrendingResponse?, Error?) -> ()) {
    let urlString = "\(baseUrl)/videos"
    
    let parameters = [
      "part": "snippet+contentDetails+statistics",
      "id": id,
      "key": API_KEY
    ]
    
    fetchGenericJSONData(urlString: urlString, parameters: parameters, completion: completion)
  }
  
  func fetchGenericJSONData<T: Decodable>(urlString: String, parameters: [String: String], completion: @escaping (T?, Error?) -> ()) {
    
    var components = URLComponents(string: urlString)!
    components.queryItems = [URLQueryItem]()
    
    for (key, value) in parameters {
      let queryItem = URLQueryItem(name: key, value: value)
      components.queryItems?.append(queryItem)
    }
    components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2C")
    
    guard let url = URL(string: urlString) else { return }
    var request = URLRequest(url: url)
    
    request.url = components.url
    
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    guard let accessToken = GIDSignIn.sharedInstance()?.currentUser.authentication.accessToken else { return }
    
    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    
    URLSession.shared.dataTask(with: request) { (data, resp, err) in
      
      if let err = err {
        completion(nil, err)
        return
      }
      
      guard let data = data else { return }
      
      do {
        let objects = try JSONDecoder().decode(T.self, from: data)
        completion(objects, nil)
      } catch let jsonError {
        completion(nil, err)
        print("Failed to decode: ", jsonError)
      }
      }.resume()
  }
}
