//
//  InviteService.swift
//  Dressed
//
//  Created by  Alexandr Zakharov on 24.04.2022.
//

import Foundation
import Alamofire

final class InviteService: NetworkService {
    
    func getUserInvites(completion: @escaping (Result<[InviteRaw], NetworkError>) -> Void) {
        guard let login = getUserLogin() else { return }
        let url = getBaseURL() +
            "whoInvitesMe" +
            "?login=\(login)&apikey=\(getApiKey())"
        let request = AF.request(url)
        var result = Result<[InviteRaw], NetworkError>()

        guard NetworkReachabilityManager()?.isReachable ?? false else {
            result.error = .networkNotReachable
            completion(result)
            return
        }

        request.responseDecodable(of: [InviteRaw].self) { response in
            switch response.result {
            case .success(let invites):
                result.data = invites
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
    
    func wardrobeResponseInvite(inviteId: Int,
                                response: InviteWardrobeResponse,
                                completion: @escaping (SingleResult<NetworkError>) -> Void) {
        let url = getBaseURL() + "handleInvite"
        + "?inviteId=\(inviteId)"
        + "&accepted=\(response.rawValue)"
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
}
