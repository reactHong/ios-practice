//
//  RemoteFeedLoader.swift
//  EssentialFeedSelf
//
//  Created by Hong Shik Kim on 2023/08/19.
//

import Foundation

class RemoteFeedLoaderTemp {
    
    func load(completion: @escaping (LoadFeedResult)->Void) {
        guard let url = URL(string: "https://essentialdeveloper.com/feed-case-study/test-api/feed") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            print(data)
            print(response)
            print(error)
            completion(.success([]))
        }
        task.resume()
    }
    
}
