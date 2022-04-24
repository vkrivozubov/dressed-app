import Foundation

protocol AllClothesViewInput: AnyObject {
    func reloadData()
    func toggleEditMode()
    func showDropMenu()
    func hideDropMenu()
    func changeEditButton(state: EditButtonState)
    func tableViewScrollTo(row: Int)
    func getEditMode() -> Bool
    func hideEmptyLabel()
    func showEmptyLable()
}

protocol AllClothesViewOutput: AnyObject {
    func didLoadView()
    func getCategoriesCount() -> Int
    func getTitle(for index: Int) -> String
    func getCategory(for index: Int) -> CategoryData?
    func didTapItem(itemId: Int)
    func didTapAddItem(category: String)
    func didTapMoreMenuButton()
    func didTapEditButton()
    func didTapNewCategoryButton()
    func deleteItem(id: Int)
    func didRefreshRequested()
    func forceHideDropView()
}

protocol AllClothesInteractorInput: AnyObject {
    func getAllClothes()
    func deleteItem(id: Int)
}

protocol AllClothesInteractorOutput: AnyObject {
    func showAlert(title: String, message: String)
    func handleModel(model: AllItemsData)
    func didDeletedItem()
}

protocol AllClothesRouterInput: AnyObject {
    func showAlert(title: String, message: String)
    func showEditItemScreen(itemId: Int)
    func showAddItemScreen(category: String)
    func showNewCategoryAlert(complition: @escaping (String) -> Void)
}
