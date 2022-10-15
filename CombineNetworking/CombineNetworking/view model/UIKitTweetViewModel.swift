//
//  UIKitTweetViewModel.swift
//  CombineNetworking
//
//  Created by bnulo on 10/15/22.
//

import Foundation
import Combine
 
class UIKitTweetViewModel {
    // SwiftUI implementation with @Published
//     @Published var tweets = [Tweet]()
//     @Published var searchText = "Paul Hudson"

    //UIKit implementation with CurrentValueSubject
    let tweets = CurrentValueSubject<[Tweet], Never>([Tweet]())
    // Data: [Tweet], Error: Never... and because it is CurrentValueSubject
    // we hade to give it initial or current value like ([Tweet]()) with an empty array of Tweet
    let searchText = CurrentValueSubject<String, Never>("Paul Hudson")
    
    let twitterAPI = TwitterAPI()
    var subscriptions = Set<AnyCancellable>()
    
    let isTwitterConnected = CurrentValueSubject<Bool, Never>(false)
    let errorMessage = CurrentValueSubject<String?, Never>(nil)
    
    init() {
        twitterAPI.verifyCredentials().sink { [unowned self] (completion) in
            switch completion {
            case .failure(let error):
                self.errorMessage.send(error.localizedDescription)
            case .finished: break
            }
        
            } receiveValue: { [unowned self] (_, _) in
                print("success")
//            self.isTwitterConnected.send(true)
                self.setupFetchTweets()
            }.store(in: &subscriptions)
    }
    
    func setupFetchTweets() {
      searchText     // with @Published
//        searchText
            .removeDuplicates()
        // if user stops typing for 500 milli seconds then the value passes
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .map { [unowned self] text in
                self.twitterAPI.getSearchTweets(with: text)
                    .catch { _ in
                        Just([Tweet]())  // another option instead of line above is:
//                        Empty(completeImmediately: true)
                    }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink { [unowned self] tweets in
                self.tweets.send(tweets)
            }
            .store(in: &subscriptions)
          
    }
}

