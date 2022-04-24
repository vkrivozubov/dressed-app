import Foundation

class WardrobeDetailData {
    let id: Int
    let name: String
    let imageUrl: String?
    let imageId: Int?

    init(with look: WardrobeDetailLookRaw) {
        self.id = look.id
        if let rawUrl = look.imageUrl {
            self.imageUrl = rawUrl + "&apikey=" + AuthService.shared.getApiKey()
        } else {
            imageUrl = nil
        }
        self.name = look.name

        self.imageId = look.imageId
    }
}
