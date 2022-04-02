import UIKit

protocol Service {
    func getUserLogin() -> String?

    func getUserName() -> String?

    func getUserImageURL() -> String?

    func dropUser()

    func getImageId() -> String?
}
