import Foundation

final class AllClothesInteractor {
	weak var output: AllClothesInteractorOutput?
    private let itemService = ItemsService()

    private func translateRawDataToAllClothesModel(data: AllItemsRaw) -> AllItemsData {
        var categories: [String: [ItemData]] = [:]
        for category in data.categories {
            categories[category] = []
        }

        data.clothes.forEach { item in
            let clothing = ItemData(with: item)
            categories[clothing.category]?.append(clothing)
        }

        var result = AllItemsData(categories: categories.map {
            return CategoryData(categoryName: $0.key,
                                items: $0.value)
        })
        result.categories.sort {
            $0.categoryName < $1.categoryName
        }
        return result
    }
}

extension AllClothesInteractor: AllClothesInteractorInput {
    func deleteItem(id: Int) {
        itemService.removeItem(id: id) { [weak self] (result) in
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

            guard let self = self else {
                return
            }
            self.output?.didDeletedItem()
        }
    }

    func getAllClothes() {
        guard let login = AuthService.shared.getUserLogin() else {
            return
        }

        itemService.getAllItems(for: login) { [weak self] (result) in
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

            let models = self.translateRawDataToAllClothesModel(data: data)
            self.output?.handleModel(model: models)
        }
    }
}
