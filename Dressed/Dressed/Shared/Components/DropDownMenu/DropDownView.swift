import UIKit

protocol DropDownViewDelegate: AnyObject {
    func didFirstTap()
    func didSecondTap()

    var topTitle: String { get }
    var topImage: UIImage { get }
    var bottomTitle: String { get }
    var bottomImage: UIImage { get }
}

enum DropDownMenuSections: Int, CaseIterable {
    case first = 0, second = 1
}

class DropDownView: UIView {
    private var dropTable: UITableView!
    weak var delegate: DropDownViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setupDropTableLayout()
    }

    private func setupViews() {
        setupMainView()
        setupDropTable()
    }

    private func setupLayout() {
        setupDropTableLayout()
    }

    // MARK: Setup views

    private func setupMainView() {
        isUserInteractionEnabled = true
    }

    private func setupDropTable() {
        let tbl = UITableView()
        dropTable = tbl
        dropTable.layer.cornerRadius = UIScreen.main.bounds.height * 0.022
        dropTable.delegate = self
        dropTable.dataSource = self
        dropTable.separatorStyle = .none
        dropTable.isScrollEnabled = false
        dropTable.register(DropTableCell.self, forCellReuseIdentifier: DropTableCell.identifier)
        dropTable.backgroundColor = GlobalColors.backgroundColor
        self.addSubview(tbl)
    }

    // MARK: Layout

    private func setupDropTableLayout() {
        dropTable.pin
            .all()
    }
}

extension DropDownView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropTableCell.identifier,
                                                       for: indexPath) as? DropTableCell
        else { return UITableViewCell() }

        guard let delegate = delegate else {
            return cell
        }

        switch indexPath.row {
        case 0:
            cell.configureCell(icon: delegate.topImage, label: delegate.topTitle)
        case 1:
            cell.configureCell(icon: delegate.bottomImage, label: delegate.bottomTitle)
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return frame.height / CGFloat(DropDownMenuSections.allCases.count)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch DropDownMenuSections(rawValue: indexPath.row) {
        case .first:
            delegate?.didFirstTap()
        case .second:
            delegate?.didSecondTap()
        default:
            break
        }
    }
}

extension DropDownView {
    struct Constants {
        static let cellHeight: CGFloat = 60
    }
}
