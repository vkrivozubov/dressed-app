import UIKit
import PinLayout

class WardrobeCell: UICollectionViewCell {
    static let identifier = "WardrobeCell"

    // MARK: - Public properties
    var imageView = UIImageView()
    var titleLable = UILabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    override func layoutSubviews() {
        super.layoutSubviews()

        setupImageViewLayout()
        setupTitleLabelLayout()
    }

    // MARK: - Private methods
    private func setupViews() {
        setupMainView()
        setupImageView()
        setupTitleLabel()
    }

    private func setupMainView() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        dropShadow()
        contentView.backgroundColor = GlobalColors.backgroundColor
    }

    private func setupImageView() {
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        contentView.addSubview(imageView)
    }

    private func setupTitleLabel() {
        titleLable.textColor = GlobalColors.darkColor
        titleLable.font = UIFont(name: "DMSans-Bold", size: 15)
        titleLable.adjustsFontSizeToFitWidth = true
        titleLable.minimumScaleFactor = 0.1
        titleLable.numberOfLines = 0
        titleLable.sizeToFit()
        titleLable.textAlignment = .center
        contentView.addSubview(titleLable)
    }

    private func setupImageViewLayout() {
        imageView.pin
            .top()
            .left()
            .right()
            .height(66%)
    }

    private func setupTitleLabelLayout() {
        titleLable.pin
            .below(of: imageView)
            .left()
            .right()
            .margin(5%)
            .bottom()
    }
}
