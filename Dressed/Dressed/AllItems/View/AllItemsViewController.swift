import UIKit
import PinLayout

final class AllItemsViewController: UIViewController {
    var output: AllItemsViewOutput?

    private let backgroundView = UIView()
    private let titleLabel = UILabel()
    private let backToLookButton = UIButton()
    private let confirmButton = UIButton()
    private let allItemsTableView = UITableView()
    private let noItemsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupSubviews()

        output?.didLoadView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layoutBackgroundView()
        layoutTitleLabel()
        layoutBackToLookButton()
        layoutConfirmButton()
        layoutLookTableView()
        layoutNoItemsLabel()
    }

    private func setupView() {
        view.backgroundColor = .white
    }

    private func setupSubviews() {
        setupBackgroundView()
        setupTitleLabel()
        setupBackToLookButton()
        setupConfirmButton()
        setupLookTableView()
        setupNoItemsLabel()
    }

    private func setupBackgroundView() {
        view.addSubview(backgroundView)

        backgroundView.backgroundColor = GlobalColors.mainBlueScreen
    }

    private func setupTitleLabel() {
        backgroundView.addSubview(titleLabel)

        titleLabel.font = UIFont(name: "DMSans-Bold", size: 25)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "Мои предметы"
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.1
        titleLabel.numberOfLines = 0
    }

    private func setupBackToLookButton() {
        backgroundView.addSubview(backToLookButton)

        backToLookButton.setImage(UIImage(systemName: "chevron.backward",
                                        withConfiguration: UIImage.SymbolConfiguration(weight: .bold)),
                                        for: .normal)
        backToLookButton.tintColor = GlobalColors.backgroundColor
        backToLookButton.contentVerticalAlignment = .fill
        backToLookButton.contentHorizontalAlignment = .fill
        backToLookButton.addTarget(self, action: #selector(didTapBackToLookButton), for: .touchUpInside)
    }

    private func setupConfirmButton() {
        backgroundView.addSubview(confirmButton)

        confirmButton.setImage(
            UIImage(
                systemName: "checkmark",
                withConfiguration: UIImage.SymbolConfiguration(weight: .bold)),
                for: .normal
        )
        confirmButton.tintColor = GlobalColors.backgroundColor
        confirmButton.contentVerticalAlignment = .fill
        confirmButton.contentHorizontalAlignment = .fill
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
    }

    private func setupLookTableView() {
        view.addSubview(allItemsTableView)

        allItemsTableView.register(AllItemsTableViewCell.self, forCellReuseIdentifier: "AllItemsTableViewCell")

        allItemsTableView.delegate = self
        allItemsTableView.dataSource = self

        allItemsTableView.showsVerticalScrollIndicator = false
        allItemsTableView.showsHorizontalScrollIndicator = false
        allItemsTableView.separatorStyle = .none
        allItemsTableView.contentInset = UIEdgeInsets(
            top: 10,
            left: 0,
            bottom: 0,
            right: 0
        )
        allItemsTableView.setContentOffset(CGPoint(x: .zero, y: -10), animated: true)
        allItemsTableView.backgroundColor = .white

        let refreshControl = UIRefreshControl()

        refreshControl.addTarget(
            self,
            action: #selector(didRefreshRequested),
            for: .valueChanged
        )
        allItemsTableView.refreshControl = refreshControl
    }

    private func setupNoItemsLabel() {
        view.addSubview(noItemsLabel)

        noItemsLabel.font = UIFont(name: "DMSans-Bold", size: 25)
        noItemsLabel.textColor = GlobalColors.darkColor
        noItemsLabel.textAlignment = .center
        noItemsLabel.text = "У Вас нет доступных предметов."
        noItemsLabel.adjustsFontSizeToFitWidth = true
        noItemsLabel.minimumScaleFactor = 0.1
        noItemsLabel.numberOfLines = .zero
        noItemsLabel.isHidden = true
    }

    private func layoutBackgroundView() {
        backgroundView.pin
            .top(.zero)
            .width(100%)
            .height(Constants.screenHeight * 0.07 + 30 + 5 + 30 + 15)
    }

    private func layoutTitleLabel() {
        titleLabel.pin
            .top(50%)
            .hCenter()
            .width(40%)
            .height(30)
    }

    private func layoutBackToLookButton() {
        backToLookButton.pin
            .height(25)
            .width(20)

        backToLookButton.pin
            .top(backgroundView.bounds.height * 0.6 - backToLookButton.bounds.height / 2)
            .left(5%)
    }

    private func layoutConfirmButton() {
        confirmButton.pin
            .height(25)
            .width(25)

        confirmButton.pin
            .top(backgroundView.bounds.height * 0.6 - confirmButton.bounds.height / 2)
            .right(5%)
    }

    private func layoutLookTableView() {
        allItemsTableView.pin
            .below(of: backgroundView)
            .hCenter()
            .width(100%)
            .bottom(tabBarController?.tabBar.frame.height ?? 0)
    }

    private func layoutNoItemsLabel() {
        noItemsLabel.pin
            .hCenter()
            .vCenter()
            .width(70%)
            .height(4%)
    }

    @objc
    private func didTapBackToLookButton() {
        output?.didTapBackToLookButton()
    }

    @objc
    private func didTapConfirmButton() {
        output?.didTapConfirmButton()
    }

    @objc
    private func didRefreshRequested() {
        output?.didRefreshRequested()
    }
}

extension AllItemsViewController: AllItemsViewInput {
    func loadData() {
        allItemsTableView.refreshControl?.endRefreshing()
        allItemsTableView.reloadData()
    }

    func showNoItemsLabel() {
        allItemsTableView.isHidden = true
        noItemsLabel.isHidden = false
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)

        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
}

extension AllItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GlobalConstants.cellSize.height * 1.3
    }
}

extension AllItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output?.getRowsCount() ?? .zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllItemsTableViewCell", for: indexPath) as? AllItemsTableViewCell else {
            return UITableViewCell()
        }

        cell.selectionStyle = .none

        guard let model = output?.viewModel(index: indexPath.row) else {
            return cell
        }

        let cellPresenter = AllItemsTableViewCellPresenter(index: indexPath.row)

        cellPresenter.output = output
        cellPresenter.cell = cell
        cell.output = cellPresenter
        cell.configure(model: model)

        return cell
    }
}

extension AllItemsViewController {
    private struct Constants {
        static let screenHeight: CGFloat = UIScreen.main.bounds.height

        static let screenWidth: CGFloat = UIScreen.main.bounds.width
    }
}
