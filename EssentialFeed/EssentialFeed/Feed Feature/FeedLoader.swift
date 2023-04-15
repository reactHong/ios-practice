//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Hong Shik Kim on 2023/04/15.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}

