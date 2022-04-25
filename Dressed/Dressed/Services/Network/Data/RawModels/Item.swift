import Foundation

struct ItemRaw: Decodable {
    let clothesID: Int
    let category: String
    let clothesName: String
    let imageURL: String?

    private enum CodingKeys: String, CodingKey {
        case clothesID = "clothes_id"
        case category = "category"
        case clothesName = "clothes_name"
        case imageURL = "image_url"
    }
}

struct EditItemRaw: Decodable {
    let clothesID: Int
    let clothesName: String
    let imageURL: String?
    let imageID: Int?

    private enum CodingKeys: String, CodingKey {
        case clothesID = "clothes_id"
        case clothesName = "clothes_name"
        case imageURL = "image_url"
        case imageID = "image_id"
    }
}
