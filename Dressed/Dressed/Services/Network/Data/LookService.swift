import Foundation
import Alamofire

/// Network service, provides metheods to work with look entity
final class LookService: NetworkService {

    /// request look info from server
    /// - Parameters:
    ///   - id: raw id of look
    ///   - completion: called on `.main` queue, when network request completes
    func getAllLookClothes(
        with id: Int,
        completion: @escaping (Result<LookRaw, NetworkError>) -> Void
    ) {
        let request = AF.request(getBaseURL() + "getLook?" + "look_id=\(id)" + "&apikey=\(getApiKey())")
        var result = Result<LookRaw, NetworkError>()

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        request.responseDecodable(of: [LookRaw].self) { (response) in
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
            }

            completion(result)
        }
    }

    /// send request to server to remove some item from look
    /// - Parameters:
    ///   - lookID: raw id of look, you delete item from
    ///   - itemID: raw id of item, you're deleting
    ///   - completion: called on `.main` queue, when network request completes. Response contains optional error, represents the network error, if something went wrong
    func deleteItemFromLook(
        lookID: Int,
        itemID: Int,
        completion: @escaping (SingleResult<NetworkError>) -> Void
    ) {
        var result = SingleResult<NetworkError>()

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        let request = AF.request("\(getBaseURL())" + "deleteItemFromLook?look_id=\(lookID)&item_id=\(itemID)&apikey=\(getApiKey())")

        request.response { (response) in
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
        }
    }

    /// Edit some look data, except item content
    /// - Parameters:
    ///   - lookID: raw id of look, you're editing
    ///   - name: new name of this look
    ///   - imageData: blob, representong new image
    ///   - completion: called on `.main` queue, when network request completes. Response contains optional error, represents the network error, if something went wrong
    func updateLookMetadata(
        lookID: Int,
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
            "look_id": "\(lookID)",
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
        }, to: getBaseURL() + "updateLook").response { (response) in
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

    /// Get some look metadata, to make UI representation of look card
    /// - Parameters:
    ///   - lookID: raw id of look
    ///   - completion: called on `.main` queue, when network request completes. Represents look metadata or reason caused request failure
    func getLookMetadata(
        lookID: Int,
        completion: @escaping (Result<LookMetadataRaw, NetworkError>) -> Void
    ) {
        let request = AF.request(getBaseURL() + "getLookById?" + "look_id=\(lookID)" + "&apikey=\(getApiKey())")
        var result = Result<LookMetadataRaw, NetworkError>()

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        request.responseDecodable(of: [LookMetadataRaw].self) { (response) in
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

    /// update look with new items
    /// - Parameters:
    ///   - lookID: raw id of look you updateing
    ///   - itemIDs: array of raw item id's, that new look consists of
    ///   - completion: called on `.main` queue, when network request completes. Response contains optional error, represents the network error, if something went wrong
    func updateLook(
        lookID: Int,
        itemIDs: [Int],
        completion: @escaping (SingleResult<NetworkError>) -> Void
    ) {
        var result = SingleResult<NetworkError>()

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        let parameters: [String: String] = [
            "items_ids": "\(itemIDs)",
            "look_id": "\(lookID)",
            "apikey": "\(getApiKey())"
        ]

        let request = AF.request("\(getBaseURL())" + "updateLookItems", method: .post, parameters: parameters)

        request.response { (response) in
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
        }
    }

    /// send request to server to delete look
    /// - Parameters:
    ///   - lookId: raw id of look you deleting
    ///   - completion: called on `.main` queue, when network request completes. Response contains optional error, represents the network error, if something went wrong
    func deleteLook(
        lookId: Int,
        completion: @escaping (SingleResult<NetworkError>) -> Void
    ) {
        let url = getBaseURL() + "removeLook?look_id=\(lookId)&apikey=\(getApiKey())"

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

    /// get looks stored in wardrobe
    /// - Parameters:
    ///   - wardrobeId: raw id of wardrobe you're searching looks for
    ///   - completion: called on `.main` queue, when network request completes. Represents looks stored in wardrobe or reason caused request failure
    func getLooks(
        for wardrobeId: Int,
        completion: @escaping (Result<[WardrobeDetailLookRaw], NetworkError>) -> Void
    ) {
        let request = AF.request(getBaseURL() + "getLookByWardrobe?" + "wardrobe_id=\(wardrobeId)" + "&apikey=\(getApiKey())")
        var result = Result<[WardrobeDetailLookRaw], NetworkError>()

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        request.responseDecodable(of: [WardrobeDetailLookRaw].self) { (response) in
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

    /// send request to create new look
    /// - Parameters:
    ///   - wardrobeID: raw id of wardrobe, you creating look in
    ///   - name: name of new look
    ///   - imageData: blob representing image of look preview card
    ///   - choosedItems: items that stored in this look
    ///   - completion: called on `.main` queue, when network request completes. Response contains optional error, represents the network error, if something went wrong
    func createLook(
        wardrobeID: Int,
        name: String,
        imageData: Data?,
        choosedItems: [Int],
        completion: @escaping (SingleResult<NetworkError>) -> Void
    ) {
        var result = SingleResult<NetworkError>()

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        let parameters: [String: String] = [
            "look_name": name,
            "wardrobe_id": "\(wardrobeID)",
            "items_ids": "\(choosedItems)",
            "apikey": "\(getApiKey())"
        ]

        let request = AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let valueData = value.data(using: String.Encoding.utf8) {
                        multipartFormData.append(valueData, withName: key)

                    }

                }
                if let data = imageData {
                    multipartFormData.append(data, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")

                }

            },
            to: "\(getBaseURL())" + "createLook"
        )

        request.response { (response) in
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

            completion(result)
        }
    }
}
