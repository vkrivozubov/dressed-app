import UIKit

protocol Service {
    func getUserLogin() -> String?
    func getUserImageURL() -> String?
    func dropUser()
    func getImageId() -> String?
}

protocol AuthServiceInput {
    func register(
        login: String,
        password: String,
        imageData: Data?,
        completion: @escaping (Result<LoginResponse, NetworkError>) -> Void
    )

    func login(
        login: String,
        password: String,
        completion: @escaping (Result<LoginResponse, NetworkError>) -> Void
    )

    func isAuthorized(completion: @escaping (Result<Bool, NetworkError>) -> Void)
}
