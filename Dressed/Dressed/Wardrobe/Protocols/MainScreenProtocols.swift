import Foundation
import UIKit

protocol MainScreenViewInput: AnyObject {
    func reloadDataWithAnimation()
    func reloadData()
    func startActivity()
    func endActivity()
    func showAlert(alert: UIAlertController)
    func changeEditButton(state: EditButtonState)
}

protocol MainScreenViewOutput: AnyObject {
    func showDetailDidTap(at indexPath: IndexPath)
    func addWardrobeDidTap()
    func settingsButtonDidTap()
    func didLoadView()
    func getNumberOfWardrobes() -> Int
    func wardrobe(at indexPath: IndexPath) -> WardrobeData?
    func didEditButtonTap()
    func isEditButtonTapped() -> Bool
    func didDeleteWardrobeTap(with wardrobe: WardrobeData)
    func refreshData()
    func didEditWardrobeTap(at indexPath: IndexPath)
}

protocol MainScreenInteractorInput: AnyObject {
    func loadUserWardobes()
    func deleteWardrobe(with id: Int)
    func cleanImageCache(for models: [WardrobeData])
    func getUserLogin() -> String
}

protocol MainScreenInteractorOutput: AnyObject {
    func didReceive(with wardrobes: [WardrobeData])
    func showAlert(title: String, message: String)
    func didDelete()
}

protocol MainScreenRouterInput: AnyObject {
    func showDetailWardrope(id: Int, name: String, creatorLogin: String)
    func showSettings(login: String, name: String, imageUrl: String)
    func showAddWardobeScreen(for user: String)
    func showEditWardrobe(with wardrobeId: Int)
}
