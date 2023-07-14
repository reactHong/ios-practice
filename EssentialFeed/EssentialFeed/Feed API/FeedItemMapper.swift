//
//  FeedItemMapper.swift
//  EssentialFeed
//
//  Created by Hong Shik Kim on 2023/07/12.
//

import Foundation

internal final class FeedItemsMapper {
    
    private struct Root: Decodable {
        let items: [Item]
        
        var feed: [FeedItem] { // WORD: computed var
            return items.map { $0.item }
        }
    }

    private struct Item : Decodable {
        let id: UUID
        let description: String?ç
        let location: String?
        let image: URL
        
        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: image)
        }
    }
    
    private static var OK_200: Int { return 200}
    
    internal static func map(_ response: HTTPURLResponse, _ data: Data) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(.invalidData)
        }
        
        return .success(root.feed)
    }
}
