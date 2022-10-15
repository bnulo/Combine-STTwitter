//
//  TwitterAPI.swift
//  CombineNetworking
//
//  Created by bnulo on 1/18/1400 AP.
//

import Foundation
import STTwitter
import Combine
 
struct TwitterAPI {
    
    let key = "xxxxxxxxxxxxxx" // use your own key here
    let secret = "xxxxxxxxxxxxxx" // use your own secrete here
    var api: STTwitterAPI
    
    init() {
        api = STTwitterAPI(appOnlyWithConsumerKey: key, consumerSecret: secret)
    }
    
    func verifyCredentials() -> Future<(String?, String?), Error> {
        Future { promise in
            api.verifyCredentials(userSuccessBlock: { (username, userId) in
                promise(.success((username, userId)))
            }, errorBlock: { (err) in
                promise(Result.failure(err!))
            })
        }
    }
    
    func getSearchTweets(with query: String) -> AnyPublisher<[Tweet], Error> {
        Future { promise in
            api.getSearchTweets(withQuery: query,
                                successBlock: { (data, res) in
                promise(.success(res))
            }, errorBlock: { (err) in
                promise(.failure(err!))
            })
        }
        .compactMap({ $0 })  // ignores if it is nil
        .tryMap {
            try JSONSerialization.data(withJSONObject: $0,
                                      options: .prettyPrinted)
        }
        .decode(type: [Tweet].self, decoder: jsonDecoder)
        .eraseToAnyPublisher()
    }
    
    var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
