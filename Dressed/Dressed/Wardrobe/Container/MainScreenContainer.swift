import UIKit

final class MainScreenContainer {
	let viewController: UIViewController
	private(set) weak var router: MainScreenRouterInput!

	class func assemble(with context: MainScreenContext) -> MainScreenContainer {
        let router = MainScreenRouter()
        let interactor = MainScreenInteractor()
        let presenter = MainScreenPresenter(router: router, interactor: interactor)
		let viewController = MainScreenViewController()

        viewController.output = presenter
		presenter.view = viewController
		interactor.output = presenter
        router.viewController = viewController

        presenter.userLogin = context.login
        presenter.userName = context.userName
        presenter.imageUrlString = (context.umageURL ?? "") + "&apikey=" + DataService.shared.getApiKey()
        return MainScreenContainer(view: viewController, router: router)
	}

    private init(view: UIViewController, router: MainScreenRouterInput) {
		self.viewController = view
		self.router = router
	}
}

struct MainScreenContext {
    var login: String

    var userName: String

    var umageURL: String?
}
