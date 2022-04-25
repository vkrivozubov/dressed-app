import Foundation

struct WardrobeUserRaw: Decodable {
    let login: String
    let imageUrl: String?
    let imageId: Int?

    private enum CodingKeys: String, CodingKey {
        case login = "login"
        case imageUrl = "image_url"
        case imageId = "image_id"
    }
}
