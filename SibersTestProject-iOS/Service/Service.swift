//
//  Service.swift
//  SibersTestProject-iOS
//
//  Created by Daniyar Erkinov on 7/3/19.
//  Copyright © 2019 Daniyar Erkinov. All rights reserved.
//

import Foundation

class Service {
  static let shared = Service()
  private static let API_KEY = "AIzaSyDsOlURUNY-IEyhfvHxlXVH8PMTCAZ7x60"
  
  func fetchVideos(completion: @escaping (SearchResult?, Error?) -> ()) {
    fetchGenericJSONData(urlString: "test", completion: completion)
  }

  func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
    
    guard let url = URL(string: urlString) else { return }
    URLSession.shared.dataTask(with: url) { (data, resp, err) in
      
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
