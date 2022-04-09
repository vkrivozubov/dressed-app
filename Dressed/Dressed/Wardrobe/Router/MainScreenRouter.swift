import UIKit

final class MainScreenRouter {
    weak var viewController: MainScreenViewController?
}

extension MainScreenRouter: MainScreenRouterInput {
    func showEditWardrobe(with wardrobeId: Int) {
        // TODO: Add edit wardrobe creeation
//        let lookVc = EditWardrobeContainer.assemble(with: EditWardrobeContext(wardrobeID: wardrobeId)).viewController

//        viewController?.navigationController?.pushViewController(lookVc, animated: true)
    }

    func showDetailWardrope(id: Int, name: String, creatorLogin: String) {
        // TODO: Add show detail wardrobe creeation
//        let vc = WardrobeDetailContainer.assemble(with: WardrobeDetailContext(
//                                                    wardrobeId: id,
//                                                    wardrobeName: name,
//                                                    creatorLogin: creatorLogin)).viewController
//        viewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func showSettings(login: String, name: String, imageUrl: String) {
        // TODO: Add show settings creeation
//        let vc = SettingsContainer.assemble(with: SettingsContext(login: login,
//                                                                  name: name,
//                                                                  imageUrl: imageUrl)).viewController
//        viewController?.navigationController?.pushViewController(vc, animated: true)
    }

    func showAddWardobeScreen(for user: String) {
        // TODO: Add wardrobe screen creeation
//        let vc = CreateWardrobeContainer.assemble(with: CreateWardrobeContext(login: user)).viewController
//        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
