import Foundation
import Kingfisher

final class WardrobeUsersInteractor {
	weak var output: WardrobeUsersInteractorOutput?

    private var wardrobeService: WardrobeService = .init()

    private func handleError(with error: NetworkError) {
        switch error {
        case .deletingOwner:
            self.output?.showAlert(title: "Ошибка", message: "Нельзя удалить создателя гардероба.")
        default:
            self.output?.showAlert(title: "Ошибка", message: "Мы скоро все починим")
        }
    }

    private func handleWardrobeUsers(with userRaw: [WardrobeUserRaw]) {
        let wardrobeUsers: [WardrobeUserData] = userRaw.map({ WardrobeUserData(with: $0) })
        output?.didReceive(with: wardrobeUsers)
    }
}

extension WardrobeUsersInteractor: WardrobeUsersInteractorInput {
    func cleanImageCache(for models: [WardrobeUserData]) {
        for model in models {
            if let urlString = model.imageUrl {
                let cacheKey = urlString
                KingfisherManager.shared.cache.removeImage(forKey: cacheKey)
            }
        }
    }

    func deleteUser(login: String, wardrobeId: Int) {
        wardrobeService.deleteUserFromWardrobe(wardrobeId: wardrobeId,
                                                  login: login) { [weak self](result) in
            guard let self = self else { return }
            if let error = result.error {
                self.handleError(with: error)
                return
            }

            self.output?.didDelete()
        }
    }

    func loadWardrobeUsers(with wardrobeId: Int) {
        wardrobeService.getWardroeUsers(with: wardrobeId) { [weak self](result) in
            guard let self = self else { return }

            if let error = result.error {
                self.handleError(with: error)
                return
            }

            guard let wardobeUsers = result.data else {
                return
            }

            self.handleWardrobeUsers(with: wardobeUsers)
        }
    }
}
