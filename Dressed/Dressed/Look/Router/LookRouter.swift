import UIKit

final class LookRouter {
    weak var viewController: UIViewController?
}

extension LookRouter: LookRouterInput {
    func showWardrobeScreen() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    func showAllItemsScreen(lookID: Int, ownerLogin: String) {
        // FIXME: - Implement this after completing All Itmes View
    }
}
