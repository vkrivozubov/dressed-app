import Alamofire
import Foundation

final class SettingsService: NetworkService {
    
    /// send request to change user login
    /// - Parameters:
    ///   - newLogin: new user login
    ///   - completion: - completion: called on `.main` queue, when network request completes. Response contains optional error, represents the network error, if something went wrong
    func changeUserLogin(
        with newLogin: String,
        completion: @escaping (SingleResult<NetworkError>) -> Void
    ) {
        guard let lastLogin = getUserLogin() else { return }
        let url = getBaseURL() + "changeLoginTimeBomb"

        var result = SingleResult<NetworkError>()

        let parametrs: [String: String] =
            ["last_login": lastLogin,
             "new_login": newLogin,
             "apikey": getApiKey()]

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        let request = AF.request(url, method: .post, parameters: parametrs)

        request.response { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    result.error = .unknownError
                    completion(result)
                    return
                }

                switch statusCode {
                case ResponseCode.success.code:
                    completion(result)
                case ResponseCode.error.code:
                    result.error = .userAlreadyExist
                    completion(result)
                    return
                default:
                    result.error = .unknownError
                    completion(result)
                    return
                }
            case .failure(let error):
                if error.isInvalidURLError {
                    result.error = .connectionToServerError
                } else {
                    result.error = .unknownError
                }
                completion(result)
            }
        }
    }

    
    /// send request to update user password
    /// - Parameters:
    ///   - password: user password
    ///   - completion: - completion: called on `.main` queue, when network request completes. Response contains optional error, represents the network error, if something went wrong
    func changePassword(
        password: String,
        completion: @escaping (SingleResult<NetworkError>) -> Void
    ) {
        guard  let login = getUserLogin() else { return }

        let url = getBaseURL() + "changePassword"

        var result = SingleResult<NetworkError>()

        let parametrs: [String: String] =
            ["login": login,
             "new_password": password,
             "apikey": getApiKey()]

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        let request = AF.request(url, method: .post, parameters: parametrs)

        request.response { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    result.error = .unknownError
                    completion(result)
                    return
                }

                switch statusCode {
                case ResponseCode.success.code:
                    completion(result)
                case ResponseCode.error.code:
                    result.error = .networkNotReachable
                    completion(result)
                    return
                default:
                    result.error = .unknownError
                    completion(result)
                    return
                }
            case .failure(let error):
                if error.isInvalidURLError {
                    result.error = .connectionToServerError
                } else {
                    result.error = .unknownError
                }
            }
        }
    }

    
    /// send request to update user avatar photo
    /// - Parameters:
    ///   - newPhotoData: blob representing new image
    ///   - completion: called on `.main` queue, when network request completes. Represents new image url or reason caused request failure
    func changePhoto(
        newPhotoData: Data,
        completion: @escaping (Result<ResponseEditString, NetworkError>) -> Void
    ) {
        guard let user = getUserLogin() else { return }

        let parameters: [String: String] = [
            "login": "\(user)",
            "apikey": getApiKey()
        ]

        var result = Result<ResponseEditString, NetworkError>()
        let url = getBaseURL() + "changeAvatar"

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        _ = AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(newPhotoData, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
                for (key, value) in parameters {
                     if let valueData = value.data(using: String.Encoding.utf8) {
                         multipartFormData.append(valueData, withName: key)
                     }
                }
        },
        to: url).responseDecodable(of: [ResponseEditString].self) { response in
            switch response.result {
            case .success(let url):
                result.data = url.first
            case .failure(let error):
                if error.isInvalidURLError {
                    result.error = .connectionToServerError
                } else {
                    result.error = .unknownError
                }
            }
            completion(result)
        }
    }

    
    /// send request to change username
    /// - Parameters:
    ///   - newName: new username
    ///   - completion: - completion: called on `.main` queue, when network request completes. Response contains optional error, represents the network error, if something went wrong
    func changeName(
        newName: String,
        completion: @escaping (SingleResult<NetworkError>) -> Void
    ) {
        guard let login = getUserLogin() else { return }

        let parametrs: [String: String] =
            ["login": login,
             "new_name": newName,
             "apikey": getApiKey()]

        let url = getBaseURL() + "changeName"

        var result = SingleResult<NetworkError>()
        let request = AF.request(url, method: .post, parameters: parametrs)

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        request.response { response in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    result.error = .unknownError
                    completion(result)
                    return
                }

                switch statusCode {
                case ResponseCode.success.code:
                    completion(result)
                case ResponseCode.error.code:
                    result.error = .userAlreadyExist
                    completion(result)
                    return
                default:
                    result.error = .unknownError
                    completion(result)
                    return
                }
            case .failure(let error):
                if error.isInvalidURLError {
                    result.error = .connectionToServerError
                } else {
                    result.error = .unknownError
                }
                completion(result)
            }
        }
    }

    
    /// update username in userdefaults
    /// - Parameter newName: new username
    func setNewUserName(newName: String) {
        UserDefaults.standard.setValue(newName, forKey: Constants.userNameKey)
    }
}
