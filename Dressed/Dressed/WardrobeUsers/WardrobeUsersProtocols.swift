import Foundation
import UIKit

protocol WardrobeUsersViewInput: AnyObject {
    func reloadDataWithAnimation()
    func reloadData()
    func changeEditButton(state: EditButtonState)
    func showAlert(alert: UIAlertController)
    func setWardrobeName(with name: String)
}

protocol WardrobeUsersViewOutput: AnyObject {
    func didLoadView()
    func didEditButtonTap()
    func isEditButtonTapped() -> Bool
    func didInivteUserButtonTapped()
    func getNumberOfUsers() -> Int
    func getWardrobeUser(at indexPath: IndexPath) -> WardrobeUserData
    func didDeleteUserTap(login: String)
    func refreshData()
    func isCreator(with login: String) -> Bool
    func isLoadedView() -> Bool
}

protocol WardrobeUsersInteractorInput: AnyObject {
    func loadWardrobeUsers(with wardrobeId: Int)
    func deleteUser(login: String, wardrobeId: Int)
    func cleanImageCache(for models: [WardrobeUserData])
}

protocol WardrobeUsersInteractorOutput: AnyObject {
    func showAlert(title: String, message: String)
    func didReceive(with wardrobeUsers: [WardrobeUserData])
    func didDelete()
}

protocol WardrobeUsersRouterInput: AnyObject {
    func showInviteUser(with wardrobeId: Int)
}
