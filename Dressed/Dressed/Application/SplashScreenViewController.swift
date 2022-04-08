import UIKit
import PinLayout

final class SplashScreenViewController: UIViewController {

    private weak var splashScreenImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupSubviews()
    }

    private func setupView() {
        view.backgroundColor = GlobalColors.mainBlueScreen
    }

    private func setupSubviews() {
        setupSplashScreenImageView()
    }

    private func setupSplashScreenImageView() {
        let imageView = UIImageView()

        splashScreenImageView = imageView
        view.addSubview(imageView)

        splashScreenImageView.image = UIImage(named: "wardrobe")
        splashScreenImageView.contentMode = .scaleToFill
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        layoutSplashScreenImageView()
    }

    private func layoutSplashScreenImageView() {
        splashScreenImageView.pin
            .all()
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)

        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
}
