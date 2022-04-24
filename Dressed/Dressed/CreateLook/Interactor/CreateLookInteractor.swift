import Foundation

final class CreateLookInteractor {
    weak var output: CreateLookInteractorOutput?
    private var wardrobeID: Int
    private var ownerLogin: String
    private let itemService = ItemsService()

    init(wardrobeID: Int, ownerLogin: String) {
        self.wardrobeID = wardrobeID
        self.ownerLogin = ownerLogin
    }

    private func convertToAllItemsData(model: [ItemRaw]) -> AllItemsData {
        var uniqueCategories: [String: [ItemData]] = [:]

        model.forEach { item in
            if uniqueCategories[item.category] == nil {
                uniqueCategories[item.category] = [ItemData(clothesID: item.clothesID,
                                                            category: item.category,
                                                            clothesName: item.clothesName,
                                                            imageURL: item.imageURL)]
            } else {
                uniqueCategories[item.category]?.append(ItemData(clothesID: item.clothesID,
                                                                 category: item.category,
                                                                 clothesName: item.clothesName,
                                                                 imageURL: item.imageURL))
            }
        }

        var categoriesArray: [(String, [ItemData])] = uniqueCategories.map {
            return ($0.key, $0.value)
        }

        categoriesArray.sort {
            $0.0 < $1.0
        }

        return AllItemsData(categories: categoriesArray.map { cortege in
            return CategoryData(categoryName: cortege.0, items: cortege.1)
        })
    }
}

extension CreateLookInteractor: CreateLookInteractorInput {
    func fetchAllItems() {
        itemService.getAllItems(for: ownerLogin) { [weak self] (result) in
            guard result.error == nil else {
                guard let networkError = result.error else {
                    return
                }

                switch networkError {
                case .networkNotReachable:
                    self?.output?.showAlert(title: "Ошибка", message: "Не удается подключиться")
                case .itemsNotExist:
                    self?.output?.showAlert(title: "Ошибка", message: "Вещи не найдены")
                default:
                    self?.output?.showAlert(title: "Ошибка", message: "Мы скоро все починим")
                }

                return
            }

            guard let data = result.data,
                  let self = self else {
                return
            }

            self.output?.updateModel(model: self.convertToAllItemsData(model: data.clothes))
            self.output?.allItemsSuccesfullyReceived()
        }
    }

    func getWardrobeID() -> Int {
        return wardrobeID
    }
}
