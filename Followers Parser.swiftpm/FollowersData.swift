
import Foundation

// The structure mirrors Instagram's JSON format
// for followers data.
//
// If the Instagram JSON format changes, update
// accordingly.

struct FollowerData {
    let title: String
    let mediaList: [String]
    let stringList: [FollowerAttributes]
    
    struct FollowerAttributes {
        let link: String
        let username: String
        let timestamp: Int
    }
}

extension FollowerData: Decodable {
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case mediaList = "media_list_data"
        case stringList = "string_list_data"
    }
}

extension FollowerData.FollowerAttributes: Decodable {
    enum CodingKeys: String, CodingKey {
        case link = "href"
        case username = "value"
        case timestamp
    }
}

func followersList(from jsonData: Data) throws -> String {
    let decodedData = try JSONDecoder()
        .decode([FollowerData].self, from: jsonData)
    
    let results = decodedData
        .map { $0.stringList[0].username }
        .joined(separator: "\n")
    
    return results
}
