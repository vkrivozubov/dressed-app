import Foundation
import Alamofire

final class UploadService: NetworkService {

    
    /// send request to upload new item
    /// - Parameters:
    ///   - userLogin: login of user, adding item
    ///   - name: name of new item
    ///   - category: category of new item
    ///   - imageData: blob representing image of uploading item
    ///   - completion: - completion: called on `.main` queue, when network request completes. Response contains optional error, represents the network error, if something went wrong
    func newItem(
        userLogin: String,
        name: String,
        category: String,
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
            "new_name": "\(name)",
            "login": "\(userLogin)",
            "type": "\(category)",
            "apikey": "\(getApiKey())"
        ]

        let upload = AF.upload(
            multipartFormData: { multipartFormData in for (key, value) in parameters {
                if let valueData = value.data(using: String.Encoding.utf8) {
                    multipartFormData.append(valueData, withName: key)
                }
            }

                if let data = imageData {
                    multipartFormData.append(data, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
                }
            }, to: getBaseURL() + "addItem")

        upload.response { (response) in
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
