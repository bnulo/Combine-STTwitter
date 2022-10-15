//
//  TweetRow.swift
//  CombineNetworking
//
//  Created by bnulo on 1/18/1400 AP.
//

import SwiftUI

struct TweetRow: View {
    let tweet:  Tweet
    var body: some View {
        HStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading) {
                Text(tweet.user.name).bold()
                Text(tweet.text).foregroundColor(.gray)
            }
        }
        
    }
}
