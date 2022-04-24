import Foundation
import Kingfisher

final class WardrobeDetailInteractor {
	weak var output: WardrobeDetailInteractorOutput?

    private let lookService = LookService()
    
    private func handleLook(with lookRaw: [WardrobeDetailLookRaw]) {
        let wardobes: [WardrobeDetailData] = lookRaw.map({ WardrobeDetailData(with: $0) })
        output?.didReceive(with: wardobes)
    }

    private func handleError(with error: NetworkError) {
        switch error {
        case .networkNotReachable:
            self.output?.showAlert(title: "Ошибка", message: "Не удается подключиться")
        default:
            self.output?.showAlert(title: "Ошибка", message: "Мы скоро все починим")
        }
    }
}

extension WardrobeDetailInteractor: WardrobeDetailInteractorInput {
    func deleteLook(lookId: Int) {
        lookService.deleteLook(lookId: lookId) { [weak self](result) in
            guard let self = self else { return }

            if let error = result.error {
                self.handleError(with: error)
                return
            }

            self.output?.didDelete()
        }
    }

    func loadLooks(with wardrobeId: Int) {
        lookService.getLooks(for: wardrobeId, completion: { [weak self](result) in
            guard let self = self else { return }

            if let error = result.error {
                self.handleError(with: error)
                return
            }

            guard let wardobes = result.data else {
                return
            }

            self.handleLook(with: wardobes)
        })
    }

    func cleanImageCache(for models: [WardrobeDetailData]) {
        for model in models {
            if let urlString = model.imageUrl {
                let cacheKey = urlString
                KingfisherManager.shared.cache.removeImage(forKey: cacheKey)
            }
        }
    }
}
