import UIKit

final class InviteContainer {
    let viewController: UIViewController
    private(set) weak var router: InviteRouter!

    class func assemble(with context: InviteContext) -> InviteContainer {
        let router = InviteRouter()
        let interactor = InviteInteractor()
        let presenter = InvitePresenter(router: router, interactor: interactor)
        let viewController = InviteViewController()

        viewController.output = presenter
        presenter.view = viewController
        interactor.output = presenter
        router.viewController = viewController

        presenter.wardrobeId = context.wardrobeId

        return InviteContainer(view: viewController, router: router)
    }

    private init(view: UIViewController, router: InviteRouter) {
        self.viewController = view
        self.router = router
    }
}

struct InviteContext {
    let wardrobeId: Int
}
