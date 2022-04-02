import UIKit

struct WardrobeData {
    let id: Int
    let imageUrl: String?
    let name: String
    let wardrobeDescription: String?
    let wardrobeOwner: String

    init(with wardrobeRaw: WardrobeRaw) {
        self.id = wardrobeRaw.id
        if let rawUrl = wardrobeRaw.imageUrl {
            self.imageUrl = rawUrl + "&apikey=" + DataService.shared.getApiKey()
        } else {
            imageUrl = nil
        }
        self.name = wardrobeRaw.name ?? ""
        self.wardrobeDescription = wardrobeRaw.wardrobeDescription
        self.wardrobeOwner = wardrobeRaw.wardrobeOwner ?? ""
    }
}
