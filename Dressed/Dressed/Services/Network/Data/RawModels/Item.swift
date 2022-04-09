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
