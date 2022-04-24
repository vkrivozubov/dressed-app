import Foundation
import PinLayout
import UIKit

class AddUserCell: UICollectionViewCell {
    static let identifier = "AddUserCell"

    private var outerView: UIView = UIView()
    private var imageView: UIImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setupLayout()
    }

    private func setupViews() {
        setupMainView()
        setupOuterView()
        setupImageView()
    }

    private func setupLayout() {
        setupImageViewLayout()
    }

    // MARK: Setupping views

    private func setupMainView() {
        contentView.layer.masksToBounds = true
    }

    private func setupOuterView() {
        outerView.dropShadow()
        outerView.clipsToBounds = false
        outerView.backgroundColor = GlobalColors.tintColor
        contentView.addSubview(outerView)
    }

    private func setupImageView() {
        imageView.image = UIImage(systemName: "plus")
        imageView.tintColor = GlobalColors.darkColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        outerView.addSubview(imageView)
    }

    // MARK: Setup layout

    private func setupImageViewLayout() {
        let imgRadius = contentView.frame.height * 0.27
        outerView.pin
            .top(5%)
            .hCenter()
            .height(imgRadius * 2)
            .width(imgRadius * 2)

        imageView.pin
            .center()
            .width(50%)
            .height(50%)
        outerView.layer.cornerRadius = outerView.frame.height / 2
        imageView.layer.cornerRadius = outerView.frame.height / 2
    }
}
