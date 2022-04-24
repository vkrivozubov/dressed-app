import Foundation

struct InviteRaw: Decodable {
    let inviteId: Int
    let login: String
    let wardrobeName: String
    let imageUrl: String?

    private enum CodingKeys: String, CodingKey {
        case inviteId = "invite_id"
        case login = "login_that_invites"
        case wardrobeName = "wardrobe_name"
        case imageUrl = "image_url"
    }
}
