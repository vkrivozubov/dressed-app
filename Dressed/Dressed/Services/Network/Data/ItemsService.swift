import Alamofire
import Foundation

final class ItemsService: NetworkService {
    
    /// send request to get info about all items, user uploaded
    /// - Parameters:
    ///   - login: user login
    ///   - completion: called on `.main` queue, when network request completes. Represents all items of user or reason caused request failure
    func getAllItems(
        for login: String,
        completion: @escaping (Result<AllItemsRaw, NetworkError>) -> Void) {
        let request = AF.request(getBaseURL() + "getAllItems?login=\(login)&apikey=\(getApiKey())")
        var result = Result<AllItemsRaw, NetworkError>()

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        request.responseDecodable(of: [AllItemsRaw].self) { (response) in
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
                    result.error = .itemsNotExist
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

    
    /// send request to remove item from wardrobe
    /// - Parameters:
    ///   - id: raw id of item, you deleting
    ///   - completion: - completion: called on `.main` queue, when network request completes. Response contains optional error, represents the network error, if something went wrong
    func removeItem(
         id: Int,
         completion: @escaping (SingleResult<NetworkError>) -> Void) {
         let request = AF.request(getBaseURL() + "removeItem?item_id=\(id)&apikey=\(getApiKey())")
         var result = SingleResult<NetworkError>()

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

    
    /// send request to get editable info about item
    /// - Parameters:
    ///   - id: raw id of item, you searching for
    ///   - completion: called on `.main` queue, when network request completes. Represents editable item data or reason caused request failure
    func getItem(
        id: Int,
        completion: @escaping (Result<EditItemRaw, NetworkError>) -> Void
    ) {
        let request = AF.request(getBaseURL() + "getItemById?item_id=\(id)&apikey=\(getApiKey())")
        var result = Result<EditItemRaw, NetworkError>()

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        request.responseDecodable(of: [EditItemRaw].self) { (response) in
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

    
    /// send request to update item name or image.
    /// - Parameters:
    ///   - id: raw id of item you updating
    ///   - name: new name of item you updateing
    ///   - imageData: new image data of item you updateing
    ///   - completion: - completion: called on `.main` queue, when network request completes. Response contains optional error, represents the network error, if something went wrong
    func updateItem(
        id: Int,
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
            "item_id": "\(id)",
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
        }, to: getBaseURL() + "updateItem").response { (response) in
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
