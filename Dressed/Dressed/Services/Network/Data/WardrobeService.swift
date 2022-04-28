import Foundation
import Alamofire

final class WardrobeService: NetworkService {
    
    /// send request to delete wardrobe
    /// - Parameters:
    ///   - id: raw id of wardrobe you deleting
    ///   - completion: - completion: called on `.main` queue, when network request completes. Response contains optional error, represents the network error, if something went wrong
    func deleteWardrobe(
        with id: Int,
        completion: @escaping (SingleResult<NetworkError>) -> Void)
    {
        guard let login = getUserLogin() else { return }
        let url = getBaseURL()
            + "deleteWardrobe?wardrobe_id=\(id)&apikey=\(getApiKey())&login=\(login)"

        var result = SingleResult<NetworkError>()

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        let request = AF.request(url)
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

    
    /// send request to get all user wadrobes
    /// - Parameter completion: called on `.main` queue, when network request completes. Represents list of raw wardrobe data or reason caused request failure

    func getUserWardrobes(
        completion: @escaping (Result<[WardrobeRaw], NetworkError>) -> Void)
    {
        guard let login = getUserLogin() else { return }
        let url = getBaseURL() + "getWardrobes?login=\(login)&apikey=\(getApiKey())"

        let request = AF.request(url)

        var result = Result<[WardrobeRaw], NetworkError>()

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        request.responseDecodable(of: [WardrobeRaw].self) { response in
            switch response.result {
            case .success(let wardrobe):
                result.data = wardrobe
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

    
    /// send request to some user to join wardrobe
    /// - Parameters:
    ///   - login: login of user you inviting
    ///   - wardobeId: raw id of wardrobe
    ///   - completion: - completion: called on `.main` queue, when network request completes. Response contains optional error, represents the network error, if something went wrong
    func addUserToWardrobe(
            with login: String,
            wardobeId: Int,
            completion: @escaping (SingleResult<NetworkError>) -> Void
        ) {
            guard let userLogin = getUserLogin() else { return }

            let url = getBaseURL() + "sendInvite" +
                "?my_login=\(userLogin)" +
                "&login_to_invite=\(login)" +
                "&wardrobe_id=\(wardobeId)" +
                "&apikey=\(getApiKey())"

            var result = SingleResult<NetworkError>()

            let request = AF.request(url)
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
                    case ResponseCode.userAlreadyInvite.code:
                        result.error = .userAlreadyInvite
                        completion(result)
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

    
    /// send request to delete user from wardrobe
    /// - Parameters:
    ///   - wardrobeId: raw id of wardrobe
    ///   - login: login of user you deleting from wadrobe
    ///   - completion: - completion: called on `.main` queue, when network request completes. Response contains optional error, represents the network error, if something went wrong
    func deleteUserFromWardrobe(
        wardrobeId: Int,
        login: String,
        completion: @escaping (SingleResult<NetworkError>) -> Void
    ) {
        let url = getBaseURL() + "removeUserFromWardrobe"
        + "?wardrobe_id=\(wardrobeId)"
        + "&remove_login=\(login)"
        + "&apikey=\(getApiKey())"

        var result = SingleResult<NetworkError>()

        let request = AF.request(url)

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
                    result.error = .deletingOwner
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

    
    /// send request to get all users that could edit this wadrobe
    /// - Parameters:
    ///   - wardrobeId: raw id of wadrobe
    ///   - completion: - completion: called on `.main` queue, when network request completes. Represents list of raw wardrobe users or reason caused request failure
    func getWardroeUsers(
        with wardrobeId: Int,
        completion: @escaping (Result<[WardrobeUserRaw], NetworkError>) -> Void)
    {
        let url = getBaseURL() + "getWardrobeUsers"
        + "?wardrobe_id=" + "\(wardrobeId)"
        + "&apikey=\(getApiKey())"

        var result = Result<[WardrobeUserRaw], NetworkError>()

        let request = AF.request(url)
        request.responseDecodable(of: [WardrobeUserRaw].self) { (response) in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else {
                    result.error = .unknownError
                    completion(result)
                    return
                }

                switch statusCode {
                case ResponseCode.success.code:
                    result.data = data
                case ResponseCode.error.code:
                    result.error = .lookNotExist
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

            completion(result)
        }
    }

    
    /// send request to create new wardrobe
    /// - Parameters:
    ///   - name: wardrobe name
    ///   - description: wardrobe description `beta`
    ///   - imageData: blob image represents image will be displayed on wardrobe preview card
    ///   - completion: - completion: called on `.main` queue, when network request completes. Response contains optional error, represents the network error, if something went wrong
    func addWardrobe(
        name: String,
        description: String,
        imageData: Data?,
        completion: @escaping (SingleResult<NetworkError>) -> Void
    ) {
        guard let login = getUserLogin() else { return }

        let parameters: [String: String] = [
            "login": "\(login)",
            "wardrobe_name": "\(name)",
            "wardrobe_description": "\(description)",
            "apikey": "\(getApiKey())"
        ]

        let url = getBaseURL() + "createWardrobe"
        var result = SingleResult<NetworkError>()

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        _ = AF.upload(multipartFormData: { multipartFormData in
            if let data = imageData {
                multipartFormData.append(data, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
            }
                for (key, value) in parameters {
                     if let valueData = value.data(using: String.Encoding.utf8) {
                         multipartFormData.append(valueData, withName: key)
                     }
                }
        }, to: url).response(completionHandler: { (response) in
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

                completion(result)
            }
        })
    }

    
    /// send request to get wardrobe meta
    /// - Parameters:
    ///   - wardrobeID: raw id of wardrobe
    ///   - completion: - completion: called on `.main` queue, when network request completes. Represents  raw wardrobe metadata(name, image, description) or reason caused request failure
    func getWardrobeMetadata(
        wardrobeID: Int,
        completion: @escaping (Result<WardrobeMetadataRaw, NetworkError>) -> Void
    ) {
        let request = AF.request(getBaseURL() + "getWardrobeById?" + "wardrobe_id=\(wardrobeID)" + "&apikey=\(getApiKey())")
        var result = Result<WardrobeMetadataRaw, NetworkError>()

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        request.responseDecodable(of: [WardrobeMetadataRaw].self) { (response) in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else {
                    result.error = .unknownError
                    completion(result)
                    return
                }

                switch statusCode {
                case ResponseCode.success.code:
                    result.data = data.first
                case ResponseCode.error.code:
                    result.error = .lookNotExist
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

            completion(result)
        }
    }

    
    /// send request to edit wadrobe meta(image, name)
    /// - Parameters:
    ///   - wardrobeID: raw id of wardrobe you editing
    ///   - name: new wardrobe name
    ///   - imageData: blob image represents image will be displayed on wardrobe preview card
    ///   - completion: - completion: called on `.main` queue, when network request completes. Response contains optional error, represents the network error, if something went wrong
    func updateWardrobeMetadata(
        wardrobeID: Int,
        name: String?,
        imageData: Data?,
        completion: @escaping (SingleResult<NetworkError>) -> Void
    ) {
        var result = SingleResult<NetworkError>()

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        let parameters: [String: String] = [
            "wardrobe_id": "\(wardrobeID)",
            "apikey": "\(getApiKey())"
        ]

        _ = AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                if let valueData = value.data(using: String.Encoding.utf8) {
                    multipartFormData.append(valueData, withName: key)
                }
            }

            if let newName = name,
               let nameData = newName.data(using: String.Encoding.utf8) {
                multipartFormData.append(nameData, withName: "new_name")
            }

            if let data = imageData {
                multipartFormData.append(data, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
            }
        }, to: getBaseURL() + "updateWardrobe").response { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else {
                    result.error = .unknownError
                    completion(result)
                    return
                }

                switch statusCode {
                case ResponseCode.success.code:
                    ()
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

            completion(result)
        }
    }
}
