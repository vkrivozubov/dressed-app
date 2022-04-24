import Foundation

struct WardrobeDetailLookRaw: Decodable {
    let id: Int
    let name: String
    let imageUrl: String?
    let imageId: Int?

    private enum CodingKeys: String, CodingKey {
        case id = "look_id"
        case name = "look_name"
        case imageUrl = "image_url"
        case imageId = "image_id"
    }
}
