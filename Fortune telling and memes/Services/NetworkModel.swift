import Foundation

struct Meme: Decodable {
    let id: String
    let name: String
    let url: String
    let width: Int
    let height: Int
    let boxCount: Int

    enum CodingKeys: String, CodingKey {
        case id, name, url, width, height
        case boxCount = "box_count"
    }
}

struct MemeDataResponse: Decodable {
    let memes: [Meme]
}

struct MemeResponse: Decodable {
    let success: Bool
    let data: MemeDataResponse
}
