import UIKit
import PinLayout

final class MyInvitesViewController: UIViewController {
	var output: MyInvitesViewOutput?

    private var headerView: UIView = UIView()
    private var titleLabel: UILabel = UILabel()
    private var backButton: UIButton = UIButton()
    private var inviteTableView: UITableView = UITableView()
    private var noInvitesLabel: UILabel = UILabel()
    private let refreshControl = UIRefreshControl()

    private let screenBounds = UIScreen.main.bounds

    // MARK: VC lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

        setupViews()
	}

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        output?.didLoadView()
    }

    private func setupViews() {
        setupMainView()
        setupHeaderView()
        setupTitleLabel()
        setupBackButton()
        setupTableView()
        setupNoInvitesLabel()
    }

    private func setupLayout() {
        setupHeaderViewLayout()
        setupTitleLableLayout()
        setupBackButtonLayout()
        setupTitleLableLayout()
        setupTableViewLayout()
        setupNoInvitesLabelLayout()
    }

    // MARK: Setup views

    private func setupMainView() {
        view.backgroundColor = GlobalColors.backgroundColor
    }

    private func setupHeaderView() {
        headerView.backgroundColor = GlobalColors.mainBlueScreen
        view.addSubview(headerView)
    }

    private func setupTitleLabel() {
        titleLabel.text = Constants.titleLabel
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "DMSans-Bold", size: 25)
        titleLabel.textColor = GlobalColors.backgroundColor
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.1
        titleLabel.numberOfLines = 1
        titleLabel.sizeToFit()
        headerView.addSubview(titleLabel)
    }

    private func setupTableView() {
        inviteTableView.delegate = self
        inviteTableView.dataSource = self
        inviteTableView.backgroundColor = GlobalColors.backgroundColor
        inviteTableView.separatorStyle = .none
        inviteTableView.register(MyInvitesCell.self,
                                 forCellReuseIdentifier: MyInvitesCell.identifier)
        inviteTableView.tableFooterView = UIView(frame: .zero)

        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        inviteTableView.refreshControl = refreshControl
        inviteTableView.separatorColor = GlobalColors.backgroundColor
        view.addSubview(inviteTableView)
    }

    private func setupBackButton() {
        backButton.setImage(UIImage(systemName: "chevron.backward",
                                        withConfiguration: UIImage.SymbolConfiguration(weight: .bold)),
                                        for: .normal)
        backButton.tintColor = GlobalColors.backgroundColor
        backButton.contentVerticalAlignment = .fill
        backButton.contentHorizontalAlignment = .fill
        backButton.addTarget(self, action: #selector(didBackButtonTapped(_:)),
                             for: .touchUpInside)
        headerView.addSubview(backButton)
    }

    private func setupNoInvitesLabel() {
        noInvitesLabel.text = Constants.noDataLabel
        noInvitesLabel.textAlignment = .center
        noInvitesLabel.font = UIFont(name: "DMSans-Bold", size: 20)
        noInvitesLabel.textColor = GlobalColors.darkColor
        noInvitesLabel.adjustsFontSizeToFitWidth = true
        noInvitesLabel.minimumScaleFactor = 0.1
        noInvitesLabel.numberOfLines = 0
        noInvitesLabel.sizeToFit()
        noInvitesLabel.isHidden = true
        view.addSubview(noInvitesLabel)
    }

    // MARK: Setup layout

    private func setupHeaderViewLayout() {
        headerView.pin
            .top(.zero)
            .width(100%)
            .height(16%)
    }

    private func setupTitleLableLayout() {
        titleLabel.pin
            .hCenter()
            .top(38%)
            .height(50%)
    }

    private func setupBackButtonLayout() {
        backButton.pin
            .height(25)
            .width(20)

        backButton.pin
            .top(titleLabel.frame.midY - backButton.bounds.height / 2)
            .left(3%)
    }

    private func setupTableViewLayout() {
        inviteTableView.pin
            .below(of: headerView)
            .marginTop(5)
            .left()
            .right()
            .bottom()
    }

    private func setupNoInvitesLabelLayout() {
        noInvitesLabel.pin
            .center()
            .height(20%)
            .width(90%)
    }

    // MARK: Actions
    @objc func didBackButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func refreshData(_ sender: Any) {
        output?.refreshData()
    }
}

extension MyInvitesViewController: MyInvitesViewInput {
    func hideNoDataLabel() {
        noInvitesLabel.isHidden = true
    }

    func showNoDataLabel() {
        noInvitesLabel.isHidden = false
    }

    func showAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }

    func reloadData() {
        inviteTableView.reloadData()
        refreshControl.endRefreshing()
    }

}

extension MyInvitesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output?.getNumberOfInvites() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyInvitesCell.identifier, for: indexPath) as? MyInvitesCell
        else {
            return UITableViewCell()
        }
        guard let inviteData = output?.getInvite(at: indexPath) else { return UITableViewCell() }
        cell.configureCell(with: inviteData)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenBounds.height * 0.156
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.didInviteButtonTapped(at: indexPath)
    }
}
extension MyInvitesViewController {
    struct Constants {
        static let titleLabel: String = "Мои приглашения"
        static let noDataLabel: String = "Здесь появятся приглашения в гардероб от других пользователей приложения. Если вы хотите пригласить кого-то к себе, это можно сделать через меню гардероба"
    }
}
