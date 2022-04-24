import UIKit

final class NewItemScreenRouter {
    weak var viewController: UIViewController?
}

extension NewItemScreenRouter: NewItemScreenRouterInput {
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)

        alert.addAction(okAction)

        viewController?.present(alert, animated: true, completion: nil)
    }
}
