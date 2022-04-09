import UIKit
import PinLayout

final class RegisterViewController: UIViewController {
    var output: RegisterViewOutput?

    private var backgroundView: UIView!

    private var welcomeLabel: UILabel!

    private var loginTextField: UITextField!

    private var fioTextField: UITextField!

    private var passwordTextField: UITextField!

    private var repeatPasswordTextField: UITextField!

    private var addPhotoButton: UIButton!

    private var userPhotoImageView: UIImageView!

    private var checkBoxImageView: UIImageView!

    private var conditionsLabel: UILabel!

    private var registerButton: UIButton!

    private var registeredQuestionLabel: UILabel!

    private var loginLabel: UILabel!

    private var underscoreView: UIView!

    private var imagePickerController: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupSubviews()
        setupImagePicker()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layoutBackgroundView()
        layoutWelcomeLabel()
        layoutLoginTextField()
        layoutFioTextField()
        layoutPasswordTextField()
        layoutRepeatPasswordTextField()
        layoutAddPhotoButton()
        layoutUserPhotoImageView()
        layoutCheckBoxImageView()
        layoutConditionsLabel()
        layoutRegisterButton()
        layoutRegisteredQuestionLabel()
        layoutLoginLabel()
        layoutUnderscoreView()
    }

    private func setupView() {
        view.backgroundColor = .white

        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(didTapView))

        tapRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer)
    }

    private func setupImagePicker() {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }

    private func setupSubviews() {
        setupBackgroundView()
        setupWelcomeLabel()
        setupLoginTextField()
        setupFioTextField()
        setupPasswordTextField()
        setupRepeatPasswordTextField()
        setupAddPhotoButton()
        setupUserPhotoImageView()
        setupCheckBoxImageView()
        setupConditionsLabel()
        setupRegisterButton()
        setupRegisteredQuestionLabel()
        setupLoginLabel()
        setupUnderscoreView()
    }

    private func setupBackgroundView() {
        let subview = UIView()

        backgroundView = subview
        view.addSubview(backgroundView)

        backgroundView.backgroundColor = GlobalColors.mainBlueScreen
        backgroundView.dropShadow()
        backgroundView.roundLowerCorners(35)
    }

    private func setupWelcomeLabel() {
        let label = UILabel()

        welcomeLabel = label
        backgroundView.addSubview(welcomeLabel)

        welcomeLabel.font = UIFont(name: "DMSans-Bold", size: 30)
        welcomeLabel.textColor = .white
        welcomeLabel.textAlignment = .center
        welcomeLabel.text = Constants.WelcomeLabel.text
    }

    private func setupLoginTextField() {
        let textField = UITextField.customTextField(placeholder: "Логин (обязательно)")

        loginTextField = textField
        backgroundView.addSubview(loginTextField)
    }

    private func setupFioTextField() {
        let textField = UITextField.customTextField(placeholder: "ФИО (обязательно)")

        fioTextField = textField
        backgroundView.addSubview(fioTextField)
    }

    private func setupPasswordTextField() {
        let textField = UITextField.customTextField(placeholder: "Пароль (обязательно)")

        passwordTextField = textField
        backgroundView.addSubview(passwordTextField)

        passwordTextField.isSecureTextEntry = true
    }

    private func setupRepeatPasswordTextField() {
        let textField = UITextField.customTextField(placeholder: "Повторите пароль (обязательно)")

        repeatPasswordTextField = textField
        backgroundView.addSubview(repeatPasswordTextField)

        repeatPasswordTextField.isSecureTextEntry = true
    }

    private func setupAddPhotoButton() {
        let button = UIButton()

        addPhotoButton = button
        view.addSubview(addPhotoButton)

        addPhotoButton.backgroundColor = .white
        addPhotoButton.layer.cornerRadius = 20

        addPhotoButton.titleLabel?.font = UIFont(name: "DMSans-Medium", size: 15)
        addPhotoButton.setTitleColor(GlobalColors.darkColor, for: .normal)
        addPhotoButton.setTitle("Выбрать фото", for: .normal)

        addPhotoButton.addTarget(self, action: #selector(didTapAddPhotoButton), for: .touchUpInside)
    }

    private func setupUserPhotoImageView() {
        let imageView = UIImageView()

        userPhotoImageView = imageView
        backgroundView.addSubview(userPhotoImageView)

        userPhotoImageView.layer.cornerRadius = 30
        userPhotoImageView.backgroundColor = .white
        userPhotoImageView.image = UIImage(systemName: "camera.fill")
        userPhotoImageView.contentMode = .center
        userPhotoImageView.clipsToBounds = true
        userPhotoImageView.tintColor = .gray
    }

    private func setupCheckBoxImageView() {
        let imageView = UIImageView()

        checkBoxImageView = imageView
        view.addSubview(checkBoxImageView)

        checkBoxImageView.image = UIImage(named: "checkBoxNotChecked")

        let boxTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCheckBox))

        boxTapRecognizer.numberOfTapsRequired = 1
        checkBoxImageView.addGestureRecognizer(boxTapRecognizer)
        checkBoxImageView.isUserInteractionEnabled = true
    }

    private func setupConditionsLabel() {
        let label = UILabel()

        conditionsLabel = label
        view.addSubview(conditionsLabel)

        conditionsLabel.lineBreakMode = .byWordWrapping
        conditionsLabel.font = UIFont(name: "DMSans-Regular", size: 13)
        conditionsLabel.text = "Создавая аккаунт, вы соглашаетесь с правилами использования."
        conditionsLabel.textColor = GlobalColors.darkColor
        conditionsLabel.textAlignment = .left
        conditionsLabel.numberOfLines = .zero
    }

    private func setupRegisterButton() {
        let button = UIButton()

        registerButton = button
        view.addSubview(registerButton)

        registerButton.backgroundColor = GlobalColors.mainBlueScreen
        registerButton.layer.cornerRadius = 20
        registerButton.dropShadow()

        registerButton.titleLabel?.font = UIFont(name: "DMSans-Bold", size: 17)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.setTitle("Зарегистироваться", for: .normal)

        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
    }

    private func setupRegisteredQuestionLabel() {
        let label = UILabel()

        registeredQuestionLabel = label
        view.addSubview(registeredQuestionLabel)

        registeredQuestionLabel.textAlignment = .right
        registeredQuestionLabel.text = "Уже зарегистрированы?"
        registeredQuestionLabel.font = UIFont(name: "DMSans-Regular", size: 12)
        registeredQuestionLabel.textColor = GlobalColors.darkColor
    }

    private func setupLoginLabel() {
        let label = UILabel()

        loginLabel = label
        view.addSubview(loginLabel)

        loginLabel.textAlignment = .left
        loginLabel.text = "Войти"
        loginLabel.font = UIFont(name: "DMSans-Regular", size: 12)
        loginLabel.textColor = GlobalColors.darkColor

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapLoginLabel))

        recognizer.numberOfTapsRequired = 1
        label.addGestureRecognizer(recognizer)
        label.isUserInteractionEnabled = true
    }

    private func setupUnderscoreView() {
        let underscore = UIView()

        underscoreView = underscore
        view.addSubview(underscoreView)

        underscoreView.backgroundColor = GlobalColors.darkColor
    }

    private func layoutBackgroundView() {
        backgroundView.pin
            .top(.zero)
            .width(100%)
            .height(34%.of(Constants.screenHeight) + 15 + 15 + 50 + 15 + 50 + 25 + 36 + 30)
    }

    private func layoutWelcomeLabel() {
        welcomeLabel.pin
            .top(Constants.screenHeight * 0.10)
            .hCenter()
            .width(80%)
            .height(50)
    }

    private func layoutLoginTextField() {
        loginTextField.pin
            .top(welcomeLabel.frame.maxY + 50)
            .hCenter()
            .width(90%)
            .height(6%.of(Constants.screenHeight))
    }

    private func layoutFioTextField() {
        fioTextField.pin
            .top(loginTextField.frame.maxY + 15)
            .hCenter()
            .width(90%)
            .height(6%.of(Constants.screenHeight))
    }

    private func layoutPasswordTextField() {
        passwordTextField.pin
            .top(fioTextField.frame.maxY + 15)
            .hCenter()
            .width(90%)
            .height(6%.of(Constants.screenHeight))
    }

    private func layoutRepeatPasswordTextField() {
        repeatPasswordTextField.pin
            .top(passwordTextField.frame.maxY + 15)
            .hCenter()
            .width(90%)
            .height(6%.of(Constants.screenHeight))
    }

    private func layoutAddPhotoButton() {
        addPhotoButton.pin
            .top(repeatPasswordTextField.frame.maxY + 25)
            .width(65%)
            .right(5%)
            .height(36)
    }

    private func layoutUserPhotoImageView() {
        userPhotoImageView.pin
            .height(60)
            .width(60)

        userPhotoImageView.pin
            .top(addPhotoButton.frame.midY - userPhotoImageView.bounds.height / 2)
            .left(5%)
    }

    private func layoutCheckBoxImageView() {
        checkBoxImageView.pin
            .height(20)
            .width(20)

        checkBoxImageView.pin
            .top(backgroundView.frame.maxY + 25)
            .left(5%)
    }

    private func layoutConditionsLabel() {
        conditionsLabel.pin
            .height(40)

        conditionsLabel.pin
            .top(checkBoxImageView.frame.midY - conditionsLabel.bounds.height / 2)
            .left(checkBoxImageView.frame.maxX + 20)
            .right(5%)
    }

    private func layoutRegisterButton() {
        registerButton.pin
            .top(conditionsLabel.frame.maxY + 15)
            .width(90%)
            .hCenter()
            .height(6%.of(Constants.screenHeight))
    }

    private func layoutRegisteredQuestionLabel() {
        registeredQuestionLabel.pin
            .top(registerButton.frame.maxY + 10)
            .left(.zero)
            .width(65%)
            .height(20)
    }

    private func layoutLoginLabel() {
        loginLabel.pin
            .sizeToFit()

        loginLabel.pin
            .top(registerButton.frame.maxY + 10)
            .left(registeredQuestionLabel.frame.maxX + 5)
            .height(20)
    }

    private func layoutUnderscoreView() {
        underscoreView.pin
            .top(loginLabel.frame.maxY - 3)
            .height(1)
            .left(loginLabel.frame.minX)
            .right(Constants.screenWidth - loginLabel.frame.maxX)
    }

    @objc
    private func didTapLoginLabel() {
        output?.didTapLoginLabel()
    }

    @objc
    private func didTapCheckBox() {
        output?.didTapCheckBox()
    }

    @objc
    private func didTapRegisterButton() {
        output?.didTapRegisterButton()
    }

    @objc
    private func didTapAddPhotoButton() {
        output?.didTapAddPhotoButton()
    }

    @objc
    private func didTapView() {
        output?.didTapView()
    }
}

extension RegisterViewController: RegisterViewInput {
    func showPickPhotoAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = alertAction(type: .camera, title: "Камера") {
            alertController.addAction(action)
        }

        if let action = alertAction(type: .savedPhotosAlbum, title: "Галерея") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alertController.modalPresentationStyle = .automatic
        present(alertController, animated: true, completion: nil)
    }

    func setUserImage(imageData: Data) {
        guard let image = UIImage(data: imageData) else {
            return
        }

        userPhotoImageView.contentMode = .scaleToFill
        userPhotoImageView.image = image
    }

    func getNewUserCredentials() -> [String: String?] {
        var credentials: [String: String?] = [:]

        credentials["login"] = loginTextField.text
        credentials["fio"] = fioTextField.text
        credentials["password"] = passwordTextField.text
        credentials["repeatPassword"] = repeatPasswordTextField.text

        return credentials
    }

    func getUserImage() -> Data? {
        return userPhotoImageView.image?.jpegData(compressionQuality: 1)
    }

    func setCheckBoxChecked() {
        checkBoxImageView.image = UIImage(named: "checkBoxChecked")
    }

    func setCheckBoxUnchecked() {
        checkBoxImageView.image = UIImage(named: "checkBoxNotChecked")
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)

        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }

    func disableKeyboard() {
        view.endEditing(true)
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func alertAction(type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            imagePickerController.sourceType = type
            present(self.imagePickerController, animated: true)
        }
    }

    private func imagePickerController(_ controller: UIImagePickerController, selectedImage: UIImage?) {
        controller.dismiss(animated: true, completion: nil)

        guard let image = selectedImage else {
            return
        }

        output?.userDidSetImage(imageData: image.jpegData(compressionQuality: Constants.UserPhotoImageView.compression))
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            imagePickerController(picker, selectedImage: nil)
            return
        }

        imagePickerController(picker, selectedImage: image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController(picker, selectedImage: nil)
    }
}

extension RegisterViewController {
    private struct Constants {
        static let screenHeight = UIScreen.main.bounds.height

        static let screenWidth = UIScreen.main.bounds.width

        struct WelcomeLabel {
            static let text: String = "Регистрация"
        }

        struct UserPhotoImageView {
            static let compression: CGFloat = 0.1
        }
    }
}
