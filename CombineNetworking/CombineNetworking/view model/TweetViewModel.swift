//
//  TweetViewModel.swift
//  CombineNetworking
//
//  Created by bnulo on 1/18/1400 AP.
//

import Foundation
import Combine
 
class TweetViewModel: ObservableObject {
    // SwiftUI implementation with @Published
     @Published var tweets = [Tweet]()
     @Published var searchText = "Paul Hudson"

    //UIKit implementation with CurrentValueSubject
//    let tweets = CurrentValueSubject<[Tweet], Never>([Tweet]())
    // Data: [Tweet], Error: Never... and because it is CurrentValueSubject
    // we hade to give it initial or current value like ([Tweet]()) with an empty array of Tweet
//    let searchText = CurrentValueSubject<String, Never>("Paul Hudson")
    
    let twitterAPI = TwitterAPI()
    var subscriptions = Set<AnyCancellable>()
    
    let isTwitterConnected = CurrentValueSubject<Bool, Never>(false)
    let errorMessage = CurrentValueSubject<String?, Never>(nil)
    
    init() {
        twitterAPI.verifyCredentials()
            .sink { [unowned self] (completion) in
            switch completion {
            case .failure(let error):
                self.errorMessage.send(error.localizedDescription)
            case .finished: return
            }
        } receiveValue: { [unowned self] (username, id) in
            print("success")
            self.isTwitterConnected.send(true)
            self.setupSearch()
        }.store(in: &subscriptions)
    }
    
    func setupSearch() {
      $searchText     // with @Published
            .removeDuplicates()
        // if user stops typing for 500 milli seconds then the value passes
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .map { [unowned self] (searchText) -> AnyPublisher<[Tweet], Never> in
                
                if searchText.count > 2 {
                    return self.twitterAPI.getSearchTweets(with: searchText)
                        .catch { (error) in
                            Just([Tweet]())
                        }
                        .eraseToAnyPublisher()
                } else {
                    return Just([Tweet]())
                        .eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .assign(to: &$tweets)
        
//            .sink { [unowned self] (tweets) in
//                self.tweets.send(tweets)
//            }.store(in: &subscriptions)
    }
}
