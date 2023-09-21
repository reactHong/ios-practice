//
//  FeedLoader.swift
//  EssentialFeedEx2
//
//  Created by Hong Shik Kim on 2023/09/19.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case failed(Error)
}

protocol FeedLoader {
    func load(completion: (LoadFeedResult)->Void)
}
