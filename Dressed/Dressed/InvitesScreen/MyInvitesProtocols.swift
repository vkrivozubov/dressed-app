import Foundation
import UIKit

protocol MyInvitesViewInput: AnyObject {
    func showAlert(alert: UIAlertController)
    func reloadData()
    func showNoDataLabel()
    func hideNoDataLabel()
}

protocol MyInvitesViewOutput: AnyObject {
    func didLoadView()
    func didInviteButtonTapped(at indexPath: IndexPath)
    func getInvite(at indexPath: IndexPath) -> MyInvitesData?
    func getNumberOfInvites() -> Int
    func refreshData()
}

protocol MyInvitesInteractorInput: AnyObject {
    func loadInvites()
    func didUserAcceptWardrobe(with id: Int)
    func didUserDenyWardrobe(with id: Int)
}

protocol MyInvitesInteractorOutput: AnyObject {
    func showAlert(title: String, message: String)
    func didReceive(with invites: [MyInvitesData])
    func removeWardrobe()
}
