import Alamofire
import Foundation

class NetworkService {

    private var apiKey: String!
    private var baseURL: String!

    init() {
        setApiKey()
        setBaseURL()
    }

    private func setApiKey() {
        guard
            let filePath = Bundle.main.path(
                forResource: Constants.commonPlistFilename,
                ofType: "plist"
            )
        else {
            apiKey = nil
            return
        }

        let plist = NSDictionary(contentsOfFile: filePath)

        guard let value = plist?.object(forKey: Constants.apiKey) as? String else {
            apiKey = nil
            return
        }

        apiKey = value
    }

    private func setBaseURL() {
        guard let filePath = Bundle.main.path(forResource: Constants.commonPlistFilename, ofType: "plist") else {
            baseURL = nil
            return
        }

        let plist = NSDictionary(contentsOfFile: filePath)

        guard let value = plist?.object(forKey: Constants.baseURL) as? String else {
            baseURL = nil
            return
        }

        baseURL = value
    }

    func getApiKey() -> String {
        return apiKey
    }

    func getBaseURL() -> String {
        return baseURL
    }
}

extension NetworkService: Service {
    func getImageId() -> String? {
        return UserDefaults.standard.string(forKey: Constants.imageIdKey)
    }

    func getUserLogin() -> String? {
        return UserDefaults.standard.string(forKey: Constants.loginKey)
    }

    func getUserImageURL() -> String? {
        return UserDefaults.standard.string(forKey: Constants.imageURLKey)
    }

    func dropUser() {
        UserDefaults.standard.removeObject(forKey: Constants.authKey)
        UserDefaults.standard.removeObject(forKey: Constants.loginKey)
        UserDefaults.standard.removeObject(forKey: Constants.passwordKey)
        UserDefaults.standard.removeObject(forKey: Constants.imageURLKey)
    }
}

extension NetworkService {
    struct Constants {
        static let commonPlistFilename: String = "Info"

        static let apiKey: String = "API_KEY"

        static let baseURL: String = "PROD_HOST"

        static let authKey: String = "isAuthorized"

        static let loginKey: String = "login"

        static let userNameKey: String = "username"

        static let passwordKey: String = "password"

        static let imageURLKey: String = "imageURL"

        static let imageIdKey: String = "imageId"
    }
}

enum ResponseCode {
    case success
    case error
}

extension ResponseCode {
    var code: Int {
        switch self {
        case .success:
            return Codes.successCode
        case .error:
            return Codes.errorCode
        }
    }
}

extension ResponseCode {
    private struct Codes {
        static let successCode: Int = 200

        static let errorCode: Int = 404
    }
}
