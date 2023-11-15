//
//  FeedLoader.swift
//  EssentialFeedEx4
//
//  Created by Hong Shik Kim on 2023/10/25.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case failed(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult)->Void)
}
