//
//  ContentView.swift
//  CombineNetworking
//
//  Created by bnulo on 1/18/1400 AP.
//

import SwiftUI
 
struct ContentView: View {
    @StateObject var tweetViewModel = TweetViewModel()
    let grayColor = Color(hue: 0, saturation: 0, brightness: 0.9)
 
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Search Tweets").font(.title)
            HStack(spacing: 20) {
                HStack {
                    Image(systemName: "magnifyingglass")
                           .foregroundColor(Color(.lightGray))
                    TextField("Search", text: $tweetViewModel.searchText)
                }.padding(5)
                 .background(RoundedRectangle(cornerRadius: 5).fill(grayColor))
               Button(action: {
                  tweetViewModel.searchText = ""
                }, label: { Text("Cancel")  })
            }
                              
            List(tweetViewModel.tweets) { tweet  in
               TweetRow(tweet: tweet)
            }.animation(.easeInOut)
        }.padding()
    }
}
