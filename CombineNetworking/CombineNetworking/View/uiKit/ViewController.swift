//
//  ViewController.swift
//  CombineNetworking
//
//  Created by bnulo on 10/15/22.
//

import UIKit
import STTwitter
import SDWebImage
import LBTATools
import Combine

class ViewController: UITableViewController {
    
    let viewModel = UIKitTweetViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBarListeners()
        
//        listenForSearchTextChanges()
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search Tweets"
        
        searchController.obscuresBackgroundDuringPresentation = false
        viewModel.tweets.sink { [unowned self] _ in
            self.tableView.reloadData()
        }.store(in: &subscriptions)
    }
    
    fileprivate func setupSearchBarListeners() {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
        publisher
            .compactMap {
            ($0.object as? UISearchTextField)?.text
            }
            .sink { [weak self] (str) in
                self?.viewModel.searchText.send(str)
//                self.searchTweets(query: str ?? "")
//                print(str ?? "")
        
            }
            .store(in: &subscriptions)
//        publisher.sink { (notification) in
//            guard let searchTextField = (notification.object as? UISearchTextField) else { return }
//            print(searchTextField.text!)
//        }
    }
    /*
    fileprivate func searchTweets(query: String) {
        api?.getSearchTweets(withQuery: query, successBlock: { (data, res) in
            
            guard let res = res else { return }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: res, options: .prettyPrinted) else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.tweets = try decoder.decode([Tweet].self, from: jsonData)
                self.tableView.reloadData()
            } catch {
                print("Failed to decode:", error)
            }
            
        }, errorBlock: { (err) in
            if let err = err {
                print("Failed to search tweets:", err)
            }
        })
    }
    
    */
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // tweets is the subject, and we want the value of this subject to get the count
        return viewModel.tweets.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TweetCell(style: .subtitle, reuseIdentifier: nil)
        let tweet = viewModel.tweets.value[indexPath.row]
        cell.tweetTextLabel.text = tweet.text
        cell.nameLabel.text = tweet.user.name
        cell.profileImageView.sd_setImage(with: URL(string: tweet.user.profileImageUrl.replacingOccurrences(of: "http", with: "https")))
        return cell
    }
}
