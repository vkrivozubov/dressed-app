import Foundation
import UIKit

final class NewItemScreenPresenter {

    private enum Constants {
        static let emptyItemErrorTitle = "Ошибка"
        static let emptyItemErrorMessage = "Введите название предмета"
    }

	weak var view: NewItemScreenViewInput?

	private let router: NewItemScreenRouterInput
	private let interactor: NewItemScreenInteractorInput

    init(router: NewItemScreenRouterInput, interactor: NewItemScreenInteractorInput) {
        self.router = router
        self.interactor = interactor
    }
}

extension NewItemScreenPresenter: NewItemScreenViewOutput {
    func didTapBackButton() {
        router.goBack()
    }

    func didTapAddButton() {
        guard
            let itemName = view?.getItemName(),
            !itemName.isEmpty
        else {
            view?.turnOnButtonInteraction()
            router.showAlert(title: Constants.emptyItemErrorTitle, message: Constants.emptyItemErrorMessage)
            return
        }

        interactor.addItem(name: itemName, imageData: view?.getItemImage())
    }

    func didTapView() {
        view?.disableKeyboard()
    }
}

extension NewItemScreenPresenter: NewItemScreenInteractorOutput {
    func showAlert(title: String, message: String) {
        view?.turnOnButtonInteraction()
        router.showAlert(title: title, message: message)
    }

    func didItemAdded() {
        router.goBack()
    }
}
