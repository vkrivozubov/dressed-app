import Foundation
import UIKit

final class CreateWardrobePresenter {
    weak var view: CreateWardrobeViewInput?

    private let router: CreateWardrobeRouter
    private let interactor: CreateWardrobeInteractorInput

    private var imgData: Data?

    var userLogin: String?

    init(router: CreateWardrobeRouter, interactor: CreateWardrobeInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension CreateWardrobePresenter: CreateWardrobeViewOutput {
    func addWardrobe(name: String) {
        view?.disableAddButtonInteraction()
        interactor.addWardrobe(with:
                                CreateWardobeData(name: name,
                                                  imageData: imgData),
                               for: userLogin ?? "")
    }

    func didImageLoaded(image: Data) {
        imgData = image
    }

}

extension CreateWardrobePresenter: CreateWardrobeInteractorOutput {
    func successLoadWardobe() {
        view?.popView()
    }

    func showAlert(title: String, message: String) {
        view?.showALert(title: title, message: message)
        view?.enableAddButtonInteraction()
    }

}
