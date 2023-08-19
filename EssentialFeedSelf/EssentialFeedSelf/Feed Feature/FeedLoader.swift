//
//  FeedLoader.swift
//  EssentialFeedSelf
//
//  Created by Hong Shik Kim on 2023/08/19.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case failed(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult)->Void)
}
