import Foundation
import UIKit

protocol CreateWardrobeViewInput: AnyObject {
    func showALert(title: String, message: String)
    func popView()
    func disableAddButtonInteraction()
    func enableAddButtonInteraction()
}

protocol CreateWardrobeViewOutput: AnyObject {
    func didImageLoaded(image: Data)
    func addWardrobe(name: String)
}

protocol CreateWardrobeInteractorInput: AnyObject {
    func addWardrobe(with wardobe: CreateWardobeData, for user: String)
}

protocol CreateWardrobeInteractorOutput: AnyObject {
    func showAlert(title: String, message: String)
    func successLoadWardobe()
}

protocol CreateWardrobeRouterInput: AnyObject {
}
