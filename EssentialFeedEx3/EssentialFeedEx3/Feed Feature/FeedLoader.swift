//
//  FeedLoader.swift
//  EssentialFeedEx3
//
//  Created by Hong Shik Kim on 2023/10/10.
//

import Foundation

protocol FeedLoader {
    func load(completion: ([FeedItem]) -> Void)
}
