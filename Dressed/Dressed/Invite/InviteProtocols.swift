import Foundation
import UIKit

protocol InviteViewInput: AnyObject {
    func showAlert(alert: UIAlertController)
}

protocol InviteViewOutput: AnyObject {
    func didUserTapInviteButton(with login: String)
}

protocol InviteInteractorInput: AnyObject {
    func inviteUser(login: String, wardrobeId: Int)
}

protocol InviteInteractorOutput: AnyObject {
    func showAlert(title: String, message: String)
}
