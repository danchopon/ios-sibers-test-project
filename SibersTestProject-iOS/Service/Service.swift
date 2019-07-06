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
    let urlString = "https://www.googleapis.com/youtube/v3/videos"
    
    let parameters = [
      "part": "snippet+contentDetails+statistics",
      "chart": "mostPopular",
      "regionCode": "US",
      "key":API_KEY
    ]
    
    fetchGenericJSONData(urlString: urlString, parameters: parameters, completion: completion)
  }
  
  func fetchPlaylists(completion: @escaping (TrendingResponse?, Error?) -> ()) {
    let urlString = "\(baseUrl)/playlistItems"
    
//    let testString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&maxResults=25&playlistId=PLBCF2DAC6FFB574DE&key=\(API_KEY)"
    
//    let testString = "https://www.googleapis.com/youtube/v3/playlists?part=snippet%2CcontentDetails&channelId=UC_x5XG1OV2P6uZZ5FSM9Ttw&maxResults=25&key=\(API_KEY)"
    
    let playlistId = "PLBCF2DAC6FFB574DE"
    
    let parameters = [
      "part": "snippet",
      "maxResults": "25",
      "playlistId": playlistId,
      "key": API_KEY
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
  
  func fetchGenericJSONData<T: Decodable>(urlString: String, parameters: [String: String], completion: @escaping (T?, Error?) -> ()) {
    
    var components = URLComponents(string: urlString)!
    print("components: \(components)")
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
      
      print(String(data: data, encoding: .utf8))
      
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
