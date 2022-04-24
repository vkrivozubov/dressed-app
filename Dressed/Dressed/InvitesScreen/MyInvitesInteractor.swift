import Foundation

enum InviteWardrobeResponse: Int {
    case deny = 0, accept = 1
}

final class MyInvitesInteractor {
	weak var output: MyInvitesInteractorOutput?

    private var inviteService: InviteService = InviteService()

    private func handleError(with error: NetworkError) {
        switch error {
        case .networkNotReachable:
            self.output?.showAlert(title: "Ошибка", message: "Не удается подключиться")
        default:
            self.output?.showAlert(title: "Ошибка", message: "Мы скоро все починим")
        }
    }

    private func handleInvites(with invitesRaw: [InviteRaw]) {
        let invites: [MyInvitesData] = invitesRaw.map({ MyInvitesData(with: $0) })
        output?.didReceive(with: invites)
    }
}

extension MyInvitesInteractor: MyInvitesInteractorInput {
    func loadInvites() {
        inviteService.getUserInvites { [weak self](result) in
            guard let self = self else { return }

            if let error = result.error {
                self.handleError(with: error)
                return
            }

            guard let invites = result.data else {
                return
            }

            self.handleInvites(with: invites)
        }
    }

    func didUserAcceptWardrobe(with id: Int) {
        inviteService.wardrobeResponseInvite(inviteId: id,
                                                  response: .accept) { [weak self](result) in
            guard let self = self else { return }

            if let error = result.error {
                self.handleError(with: error)
                return
            }
            self.output?.removeWardrobe()
        }
    }

    func didUserDenyWardrobe(with id: Int) {
        inviteService.wardrobeResponseInvite(inviteId: id,
                                                  response: .deny) { [weak self](result) in
            guard let self = self else { return }

            if let error = result.error {
                self.handleError(with: error)
                return
            }
            self.output?.removeWardrobe()
        }
    }
}
