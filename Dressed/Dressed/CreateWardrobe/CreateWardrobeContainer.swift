import UIKit

final class CreateWardrobeContainer {
    let viewController: UIViewController
    private(set) weak var router: CreateWardrobeRouter!

    class func assemble(with context: CreateWardrobeContext) -> CreateWardrobeContainer {
        let router = CreateWardrobeRouter()
        let interactor = CreateWardrobeInteractor()
        let presenter = CreateWardrobePresenter(router: router, interactor: interactor)
        let viewController = CreateWardrobeViewController()

        viewController.output = presenter
        presenter.view = viewController
        interactor.output = presenter
        router.viewController = viewController

        presenter.userLogin = context.login
        return CreateWardrobeContainer(view: viewController, router: router)
    }

    private init(view: UIViewController, router: CreateWardrobeRouter) {
        self.viewController = view
        self.router = router
    }
}

struct CreateWardrobeContext {
    var login: String
}
