import Foundation
import UIKit

protocol WardrobeDetailViewInput: AnyObject {
    func reloadDataWithAnimation()
    func showAlert(alert: UIAlertController)
    func reloadData()
    func setWardrobeName(with name: String)
    func changeEditButton(state: EditButtonState)
    func hideDropMenu()
}

protocol WardrobeDetailViewOutput: AnyObject {
    func didPersonTap()
    func didTapLook(at indexPath: IndexPath)
    func didTapCreateLookCell()
    func didLoadView()
    func getNumberOfLooks() -> Int
    func look(at indexPath: IndexPath) -> WardrobeDetailData
    func didEditButtonTap()
    func isEditButtonTapped() -> Bool
    func refreshData()
    func didDeleteLookTap(with lookData: WardrobeDetailData)
    func didEditLookTap(at indexPath: IndexPath)
}

protocol WardrobeDetailInteractorInput: AnyObject {
    func loadLooks(with wardrobeId: Int)
    func deleteLook(lookId: Int)
    func cleanImageCache(for models: [WardrobeDetailData])
}

protocol WardrobeDetailInteractorOutput: AnyObject {
    func didReceive(with: [WardrobeDetailData])
    func showAlert(title: String, message: String)
    func didDelete()
}

protocol WardrobeDetailRouterInput: AnyObject {
    func showPersons(wardrobeId: Int, wardrobeName: String, loginOfCreator: String)
    func showLookScreen(with lookId: Int, creatorLogin: String)
    func showCreateLookScreen(wardrobeId: Int, creatorLogin: String)
    func showEditLook(with lookId: Int)
}
