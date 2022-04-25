import Foundation

struct WardrobeRaw: Decodable {
    let id: Int
    let wardrobeDescription: String?
    let imageUrl: String?
    let name: String?
    let wardrobeOwner: String?

    private enum CodingKeys: String, CodingKey {
        case id = "wardrobe_id"
        case wardrobeDescription = "wardrobe_description"
        case imageUrl = "wardrobe_image"
        case name = "wardrobe_name"
        case wardrobeOwner = "wardrobe_owner"
    }
}

struct WardrobeMetadataRaw: Decodable {
    let name: String
    let imageURL: String?

    private enum CodingKeys: String, CodingKey {
        case name = "wardrobe_name"
        case imageURL = "image_url"
    }
}
