import Foundation
import UIKit

protocol SettingsViewInput: AnyObject {
    func setUserImage(with imageUrl: URL?)
    func setUserLogin(login: String?)
    func showAlert(alert: UIAlertController)
}

protocol SettingsViewOutput: AnyObject {
    func didImageLoaded(imageData: Data?)
    func didLoadView()
    func didChangePasswordTapped()
    func didChangeLoginTapped()
    func didLogoutTapped()
    func didMyInvitesButtonTap()
}

protocol SettingsInteractorInput: AnyObject {
    func logout()
    func saveNewUserName(with name: String)
    func saveNewUserImage(with imageData: Data?)
    func loadUserData()
    func savePassword(with password: String)
    func changeUserLogin(with login: String)
}

protocol SettingsInteractorOutput: AnyObject {
    func didAllKeysDeleted()
    func showAlert(title: String, message: String)
    func upadateImage(imageUrl: String)
    func didReceive(imageUrl: String?, userLogin: String?)
    func didSucessedUpdate(with login: String)
}

protocol SettingsRouterInput: AnyObject {
    func showMyInvites()
}
