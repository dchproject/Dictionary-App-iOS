//
//  RegistrationViewController.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 14.08.2021.

import UIKit

final class RegistrationViewController: MDBaseLargeTitledBackViewControllerWithBackgroundImage {
    
    fileprivate let presenter: RegistrationPresenterInputProtocol
    
    fileprivate let scrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        scrollView.keyboardDismissMode = .interactive
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    fileprivate let contentView: UIView = {
        let view: UIView = .init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate var keyboardHandler: KeyboardHandler!
    
    fileprivate static let nicknameTextFieldHeight: CGFloat = 48
    fileprivate static let nicknameTextFieldTopOffset: CGFloat = 28
    fileprivate static let nicknameTextFieldLeftOffset: CGFloat = 16
    fileprivate static let nicknameTextFieldRightOffset: CGFloat = 16
    fileprivate let nicknameTextField: MDCounterTextFieldWithToolBar = {
        let textField: MDCounterTextFieldWithToolBar = .init(rectInset: MDConstants.Rect.defaultInset,
                                                             keyboardToolbar: .init())
        textField.placeholder = MDLocalizedText.nickname.localized
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.textAlignment = .left
        textField.clearButtonMode = .whileEditing
        textField.font = MDUIResources.Font.MyriadProItalic.font()
        textField.textColor = MDUIResources.Color.md_3C3C3C.color()
        textField.returnKeyType = .next
        textField.tag = RegistrationTextFieldTag.nickname.rawValue
        textField.backgroundColor = MDUIResources.Color.md_FFFFFF.color()
        textField.updateCounter(currentCount: .zero,
                                maxCount: MDConstants.Text.MaxCountCharacters.nicknameTextField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate static let passwordTextFieldHeight: CGFloat = 48
    fileprivate static let passwordTextFieldTopOffset: CGFloat = 20
    fileprivate static let passwordTextFieldLeftOffset: CGFloat = 16
    fileprivate static let passwordTextFieldRightOffset: CGFloat = 16
    fileprivate let passwordTextField: MDCounterPasswordTextFieldWithToolBar = {
        let textField: MDCounterPasswordTextFieldWithToolBar = .init(height: passwordTextFieldHeight,
                                                                     rectInset: MDConstants.Rect.passwordInset,
                                                                     keyboardToolbar: .init())
        textField.placeholder = MDLocalizedText.password.localized
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.textAlignment = .left
        textField.font = MDUIResources.Font.MyriadProItalic.font()
        textField.textColor = MDUIResources.Color.md_3C3C3C.color()
        textField.returnKeyType = .next
        textField.isSecureTextEntry = true
        textField.tag = RegistrationTextFieldTag.password.rawValue
        textField.backgroundColor = MDUIResources.Color.md_FFFFFF.color()
        textField.updateCounter(currentCount: .zero,
                                maxCount: MDConstants.Text.MaxCountCharacters.passwordTextField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate static let confirmPasswordTextFieldHeight: CGFloat = 48
    fileprivate static let confirmPasswordTextFieldTopOffset: CGFloat = 20
    fileprivate static let confirmPasswordTextFieldLeftOffset: CGFloat = 16
    fileprivate static let confirmPasswordTextFieldRightOffset: CGFloat = 16
    fileprivate let confirmPasswordTextField: MDCounterPasswordTextFieldWithToolBar = {
        let textField: MDCounterPasswordTextFieldWithToolBar = .init(height: confirmPasswordTextFieldHeight,
                                                                     rectInset: MDConstants.Rect.passwordInset,
                                                                     keyboardToolbar: .init())
        textField.placeholder = MDLocalizedText.confirmPassword.localized
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.textAlignment = .left
        textField.font = MDUIResources.Font.MyriadProItalic.font()
        textField.textColor = MDUIResources.Color.md_3C3C3C.color()
        textField.returnKeyType = .go
        textField.isSecureTextEntry = true
        textField.tag = RegistrationTextFieldTag.confirmPassword.rawValue
        textField.backgroundColor = MDUIResources.Color.md_FFFFFF.color()
        textField.updateCounter(currentCount: .zero,
                                maxCount: MDConstants.Text.MaxCountCharacters.passwordTextField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate static let registerButtonHeight: CGFloat = 48
    fileprivate static let registerButtonTopOffset: CGFloat = 20
    fileprivate static let registerButtonLeftOffset: CGFloat = 16
    fileprivate static let registerButtonRightOffset: CGFloat = 16
    fileprivate let registerButton: UIButton = {
        let button: UIButton = .init()
        button.backgroundColor = MDUIResources.Color.md_4400D4.color()
        button.setTitle(MDLocalizedText.register.localized, for: .normal)
        button.setTitleColor(MDUIResources.Color.md_FFFFFF.color(), for: .normal)
        button.titleLabel?.font = MDUIResources.Font.MyriadProRegular.font()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let hud: MDProgressHUDHelperProtocol = {
        return MDProgressHUDHelper.init()
    }()
    
    init(presenter: RegistrationPresenterInputProtocol) {
        self.presenter = presenter
        super.init(title: MDLocalizedText.registration.localized,
                   navigationBarBackgroundImage: MDUIResources.Image.background_navigation_bar_0.image,
                   backgroundImage: MDUIResources.Image.background_typography_2.image)
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        addViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addConstraints()
        roundOffEdges()
        dropShadow()
    }
    
}

// MARK: - RegistrationPresenterOutputProtocol
extension RegistrationViewController: RegistrationPresenterOutputProtocol {
    
    func updateNicknameFieldCounter(_ count: Int) {
        nicknameTextField.updateCounter(currentCount: count,
                                        maxCount: MDConstants.Text.MaxCountCharacters.nicknameTextField)
    }
    
    func updatePasswordFieldCounter(_ count: Int) {
        passwordTextField.updateCounter(currentCount: count,
                                        maxCount: MDConstants.Text.MaxCountCharacters.passwordTextField)
    }
    
    func updateConfirmPasswordFieldCounter(_ count: Int) {
        confirmPasswordTextField.updateCounter(currentCount: count,
                                               maxCount: MDConstants.Text.MaxCountCharacters.passwordTextField)
    }
    
    func nicknameTextFieldShouldClearAction() {
        nicknameTextField.updateCounter(currentCount: .zero,
                                        maxCount: MDConstants.Text.MaxCountCharacters.nicknameTextField)
    }
    
    func makePasswordFieldActive() {
        passwordTextField.becomeFirstResponder()
    }
    
    func makeConfirmPasswordFieldActive() {
        confirmPasswordTextField.becomeFirstResponder()
    }
    
    func hideKeyboard() {
        MDConstants.Keyboard.hideKeyboard(rootView: self.view)        
    }
    
    func showError(_ error: Error) {
        UIAlertController.showAlertWithOkAction(title: MDLocalizedText.error.localized,
                                                message: error.localizedDescription,
                                                presenter: self)        
    }
    
    func showProgressHUD() {
        
        self.hud.showProgressHUD(withConfiguration: .init(view: self.view,
                                                          animated: true,
                                                          mode: .annularDeterminate,
                                                          labelText: MDLocalizedText.pleaseWaitForDataSync.localized,
                                                          labelFont: MDUIResources.Font.MyriadProRegular.font(),
                                                          labelTextColor: MDUIResources.Color.md_3C3C3C.color()))
        
        
    }
    
    func hideProgressHUD() {
        self.hud.hideProgressHUD(animated: true)
    }
    
    func updateHUDProgress(_ progress: Float) {
        self.hud.updateHUDProgress(progress)
    }
    
}

// MARK: - Add Views
fileprivate extension RegistrationViewController {
    
    func addViews() {
        addScrollView()
        addContentView()
        bringSubviewsToFront()
        createKeyboardHandler()
        addNicknameTextField()
        addPasswordTextField()
        addConfirmPasswordTextField()
        addRegisterButton()
    }
    
    func bringSubviewsToFront() {
        view.bringSubviewToFront(navigationBarView)
        view.bringSubviewToFront(navigationBarBackgroundImageView)
        view.bringSubviewToFront(backButton)
        view.bringSubviewToFront(titleLabel)
    }
    
    func addScrollView() {
        view.addSubview(scrollView)
    }
    
    func addContentView() {
        scrollView.addSubview(contentView)
    }
    
    func createKeyboardHandler() {
        self.keyboardHandler = KeyboardHandler.createKeyboardHandler(scrollView: self.scrollView)
    }
    
    func addNicknameTextField() {
        nicknameTextField.delegate = presenter.textFieldDelegate
        nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldEditingDidChangeAction), for: .editingChanged)
        contentView.addSubview(nicknameTextField)
    }
    
    func addPasswordTextField() {
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldEditingDidChangeAction), for: .editingChanged)
        passwordTextField.delegate = presenter.textFieldDelegate
        contentView.addSubview(passwordTextField)
    }
    
    func addConfirmPasswordTextField() {
        confirmPasswordTextField.addTarget(self, action: #selector(confirmPasswordTextFieldEditingDidChangeAction), for: .editingChanged)
        confirmPasswordTextField.delegate = presenter.textFieldDelegate
        contentView.addSubview(confirmPasswordTextField)
    }
    
    func addRegisterButton() {
        registerButton.addTarget(self, action: #selector(registerButtonAction), for: .touchUpInside)
        contentView.addSubview(registerButton)
    }
    
}

// MARK: - Add Constraints
fileprivate extension RegistrationViewController {
    
    func addConstraints() {
        addScrollViewConstraints()
        addContentViewConstraints()
        addNicknameTextFieldConstraints()
        addPasswordTextFieldConstraints()
        addConfirmPasswordTextFieldConstraints()
        addRegisterButtonConstraints()
    }
    
    func addScrollViewConstraints() {
        
        NSLayoutConstraint.addItemEqualToItemAndActivate(item: self.scrollView,
                                                         toItem: self.view)
        
    }
    
    func addContentViewConstraints() {
        
        NSLayoutConstraint.addItemEqualToItemAndActivate(item: self.contentView,
                                                         toItem: self.scrollView)
        
        NSLayoutConstraint.addEqualCenterXConstraint(item: self.contentView,
                                                     toItem: self.scrollView,
                                                     constant: .zero)
        
        NSLayoutConstraint.addEqualCenterYConstraint(item: self.contentView,
                                                     toItem: self.scrollView,
                                                     constant: .zero)
        
    }
    
    func addNicknameTextFieldConstraints() {
        
        NSLayoutConstraint.addEqualConstraint(item: self.nicknameTextField,
                                              attribute: .top,
                                              toItem: self.contentView,
                                              attribute: .top,
                                              constant: MDConstants.NavigationBar.heightPlusStatusBarHeight(fromNavigationController: self.navigationController,
                                                                                                            prefersLargeTitles: true) + Self.nicknameTextFieldTopOffset)
        
        NSLayoutConstraint.addEqualLeftConstraint(item: self.nicknameTextField,
                                                  toItem: self.backgroundImageView,
                                                  constant: Self.nicknameTextFieldLeftOffset)
        
        NSLayoutConstraint.addEqualRightConstraint(item: self.nicknameTextField,
                                                   toItem: self.backgroundImageView,
                                                   constant: -Self.nicknameTextFieldRightOffset)
        
        NSLayoutConstraint.addEqualHeightConstraint(item: self.nicknameTextField,
                                                    constant: Self.nicknameTextFieldHeight)
        
    }
    
    func addPasswordTextFieldConstraints() {
        
        NSLayoutConstraint.addEqualConstraint(item: self.passwordTextField,
                                              attribute: .top,
                                              toItem: self.nicknameTextField,
                                              attribute: .bottom,
                                              constant: Self.passwordTextFieldTopOffset)
        
        NSLayoutConstraint.addEqualLeftConstraint(item: self.passwordTextField,
                                                  toItem: self.backgroundImageView,
                                                  constant: Self.passwordTextFieldLeftOffset)
        
        NSLayoutConstraint.addEqualRightConstraint(item: self.passwordTextField,
                                                   toItem: self.backgroundImageView,
                                                   constant: -Self.passwordTextFieldRightOffset)
        
        NSLayoutConstraint.addEqualHeightConstraint(item: self.passwordTextField,
                                                    constant: Self.passwordTextFieldHeight)
        
    }
    
    func addConfirmPasswordTextFieldConstraints() {
        
        NSLayoutConstraint.addEqualConstraint(item: self.confirmPasswordTextField,
                                              attribute: .top,
                                              toItem: self.passwordTextField,
                                              attribute: .bottom,
                                              constant: Self.confirmPasswordTextFieldTopOffset)
        
        NSLayoutConstraint.addEqualLeftConstraint(item: self.confirmPasswordTextField,
                                                  toItem: self.backgroundImageView,
                                                  constant: Self.confirmPasswordTextFieldLeftOffset)
        
        NSLayoutConstraint.addEqualRightConstraint(item: self.confirmPasswordTextField,
                                                   toItem: self.backgroundImageView,
                                                   constant: -Self.confirmPasswordTextFieldRightOffset)
        
        NSLayoutConstraint.addEqualHeightConstraint(item: self.confirmPasswordTextField,
                                                    constant: Self.confirmPasswordTextFieldHeight)
        
    }
    
    func addRegisterButtonConstraints() {
        
        NSLayoutConstraint.addEqualConstraint(item: self.registerButton,
                                              attribute: .top,
                                              toItem: self.confirmPasswordTextField,
                                              attribute: .bottom,
                                              constant: Self.registerButtonTopOffset)
        
        NSLayoutConstraint.addEqualLeftConstraint(item: self.registerButton,
                                                  toItem: self.backgroundImageView,
                                                  constant: Self.registerButtonLeftOffset)
        
        NSLayoutConstraint.addEqualRightConstraint(item: self.registerButton,
                                                   toItem: self.backgroundImageView,
                                                   constant: -Self.registerButtonRightOffset)
        
        NSLayoutConstraint.addEqualHeightConstraint(item: self.registerButton,
                                                    constant: Self.registerButtonHeight)
        
    }
    
}

// MARK: - Configure UI
fileprivate extension RegistrationViewController {
    
    func configureUI() {
        configureSelfView()
    }
    
    func configureSelfView() {
        self.view.backgroundColor = MDUIResources.Color.md_FFFFFF.color()
    }
    
}

// MARK: - Drop Shadow
fileprivate extension RegistrationViewController {
    
    func dropShadow() {
        dropShadowNicknameTextField()
        dropShadowPasswordTextField()
        dropShadowConfirmPasswordTextField()
        dropShadowRegisterButton()
    }
    
    func dropShadowNicknameTextField() {
        nicknameTextField.dropShadow(color: MDUIResources.Color.md_5200FF.color(0.5),
                                     offSet: .init(width: 2, height: 4),
                                     radius: 15)
    }
    
    func dropShadowPasswordTextField() {
        passwordTextField.dropShadow(color: MDUIResources.Color.md_5200FF.color(0.5),
                                     offSet: .init(width: 2, height: 4),
                                     radius: 15)
    }
    
    func dropShadowConfirmPasswordTextField() {
        confirmPasswordTextField.dropShadow(color: MDUIResources.Color.md_5200FF.color(0.5),
                                            offSet: .init(width: 2, height: 4),
                                            radius: 15)
    }
    
    func dropShadowRegisterButton() {
        registerButton.dropShadow(color: MDUIResources.Color.md_4400D4.color(0.5),
                                  offSet: .init(width: 0,
                                                height: 4),
                                  radius: 20)
    }
    
}

// MARK: - Round Off Edges
fileprivate extension RegistrationViewController {
    
    func roundOffEdges() {
        nicknameTextFieldRoundOffEdges()
        passwordTextFieldRoundOffEdges()
        confirmPasswordTextFieldRoundOffEdges()
        registerButtonRoundOffEdges()
    }
    
    func nicknameTextFieldRoundOffEdges() {
        nicknameTextField.layer.cornerRadius = 10
    }
    
    func passwordTextFieldRoundOffEdges() {
        passwordTextField.layer.cornerRadius = 10
    }
    
    func confirmPasswordTextFieldRoundOffEdges() {
        confirmPasswordTextField.layer.cornerRadius = 10
    }
    
    func registerButtonRoundOffEdges() {
        registerButton.layer.cornerRadius = 10
    }
    
}

// MARK: - Actions
fileprivate extension RegistrationViewController {
    
    @objc func nicknameTextFieldEditingDidChangeAction() {
        presenter.nicknameTextFieldEditingDidChangeAction(nicknameTextField.text)
    }
    
    @objc func passwordTextFieldEditingDidChangeAction() {
        presenter.passwordTextFieldEditingDidChangeAction(passwordTextField.text)
    }
    
    @objc func confirmPasswordTextFieldEditingDidChangeAction() {
        presenter.confirmPasswordTextFieldEditingDidChangeAction(confirmPasswordTextField.text)
    }
    
    @objc func registerButtonAction() {
        presenter.registerButtonClicked()
    }
    
}
