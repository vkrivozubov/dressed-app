import Foundation

struct LookRaw: Decodable {
    let lookID: Int
    let lookName: String
    let categories: [String]
    let items: [ItemRaw]

    private enum CodingKeys: String, CodingKey {
        case lookID = "look_id"
        case lookName = "look_name"
        case categories = "categories"
        case items = "items"
    }
}

struct LookMetadataRaw: Decodable {
    let name: String
    let imageURL: String?

    private enum CodingKeys: String, CodingKey {
        case name = "look_name"
        case imageURL = "image_url"
    }
}
