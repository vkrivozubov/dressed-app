import Foundation

struct ResponseEditString: Decodable {
    let imageUrl: String

    private enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
    }
}
