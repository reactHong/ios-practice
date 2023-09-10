//
//  FeedLoader.swift
//  EssentialFeedEx1
//
//  Created by Hong Shik Kim on 2023/09/05.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case failed(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}


//class FeedLoaderSample {
//    func test() {
//        self.load { result in
//            switch (result) {
//            case .success(let items):
//                print(items)
//                break
//            case .failed(let error):
//                print(error)
//                break
//            }
//        }
//    }
//
//    func load(completion: @escaping (Result) -> Void) {
//        completion(.success([]))
//        completion(.failed(NSError()))
//    }
//}

