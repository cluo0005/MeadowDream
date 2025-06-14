import UIKit

class SignupViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backButton: HeaderButton = {
        let button = HeaderButton()
        button.setTitle("←", for: .normal)
        button.titleLabel?.font = Theme.font(size: 18, weight: .medium)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Account"
        label.font = Theme.font(size: 32, weight: .bold)
        label.textColor = Theme.primaryText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Start your dream exploration journey"
        label.font = Theme.font(size: 16, weight: .regular)
        label.textColor = Theme.secondaryText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Full name"
        field.autocapitalizationType = .words
        Theme.styleTextField(field)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email address"
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        Theme.styleTextField(field)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        Theme.styleTextField(field)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let confirmPasswordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Confirm password"
        field.isSecureTextEntry = true
        Theme.styleTextField(field)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let termsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let termsCheckbox: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tintColor = Theme.primary
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let termsLabel: UILabel = {
        let label = UILabel()
        label.text = "I agree to the Terms of Service and Privacy Policy"
        label.font = Theme.font(size: 14, weight: .regular)
        label.textColor = Theme.secondaryText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Account", for: .normal)
        Theme.styleButton(button, style: .primary)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dividerContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dividerLine1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1) // #E5E7EB
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dividerLabel: UILabel = {
        let label = UILabel()
        label.text = "or"
        label.font = Theme.font(size: 14, weight: .medium)
        label.textColor = Theme.tertiaryText
        label.backgroundColor = Theme.background
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dividerLine2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1) // #E5E7EB
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue with Google", for: .normal)
        Theme.styleButton(button, style: .secondary)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loginContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.font = Theme.font(size: 14, weight: .regular)
        label.textColor = Theme.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(Theme.primary, for: .normal)
        button.titleLabel?.font = Theme.font(size: 14, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupActions()
    }
    
    private func setupViews() {
        view.backgroundColor = Theme.background
        
        // Add back button
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Add header
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        // Add form fields
        contentView.addSubview(nameField)
        contentView.addSubview(emailField)
        contentView.addSubview(passwordField)
        contentView.addSubview(confirmPasswordField)
        
        NSLayoutConstraint.activate([
            // Name field
            nameField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            nameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameField.heightAnchor.constraint(equalToConstant: 50),
            
            // Email field
            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 16),
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            // Password field
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            // Confirm password field
            confirmPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16),
            confirmPasswordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            confirmPasswordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            confirmPasswordField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add terms container
        contentView.addSubview(termsContainer)
        termsContainer.addSubview(termsCheckbox)
        termsContainer.addSubview(termsLabel)
        
        NSLayoutConstraint.activate([
            // Terms container
            termsContainer.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 20),
            termsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            termsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Terms checkbox
            termsCheckbox.leadingAnchor.constraint(equalTo: termsContainer.leadingAnchor),
            termsCheckbox.topAnchor.constraint(equalTo: termsContainer.topAnchor),
            termsCheckbox.widthAnchor.constraint(equalToConstant: 24),
            termsCheckbox.heightAnchor.constraint(equalToConstant: 24),
            
            // Terms label
            termsLabel.leadingAnchor.constraint(equalTo: termsCheckbox.trailingAnchor, constant: 12),
            termsLabel.trailingAnchor.constraint(equalTo: termsContainer.trailingAnchor),
            termsLabel.topAnchor.constraint(equalTo: termsContainer.topAnchor),
            termsLabel.bottomAnchor.constraint(equalTo: termsContainer.bottomAnchor)
        ])
        
        // Add signup button
        contentView.addSubview(signupButton)
        NSLayoutConstraint.activate([
            signupButton.topAnchor.constraint(equalTo: termsContainer.bottomAnchor, constant: 24),
            signupButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            signupButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            signupButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add divider
        contentView.addSubview(dividerContainer)
        dividerContainer.addSubview(dividerLine1)
        dividerContainer.addSubview(dividerLabel)
        dividerContainer.addSubview(dividerLine2)
        
        NSLayoutConstraint.activate([
            // Divider container
            dividerContainer.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 32),
            dividerContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dividerContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dividerContainer.heightAnchor.constraint(equalToConstant: 20),
            
            // Divider lines and label
            dividerLine1.leadingAnchor.constraint(equalTo: dividerContainer.leadingAnchor),
            dividerLine1.trailingAnchor.constraint(equalTo: dividerLabel.leadingAnchor, constant: -12),
            dividerLine1.centerYAnchor.constraint(equalTo: dividerContainer.centerYAnchor),
            dividerLine1.heightAnchor.constraint(equalToConstant: 1),
            
            dividerLabel.centerXAnchor.constraint(equalTo: dividerContainer.centerXAnchor),
            dividerLabel.centerYAnchor.constraint(equalTo: dividerContainer.centerYAnchor),
            dividerLabel.widthAnchor.constraint(equalToConstant: 30),
            
            dividerLine2.leadingAnchor.constraint(equalTo: dividerLabel.trailingAnchor, constant: 12),
            dividerLine2.trailingAnchor.constraint(equalTo: dividerContainer.trailingAnchor),
            dividerLine2.centerYAnchor.constraint(equalTo: dividerContainer.centerYAnchor),
            dividerLine2.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        // Add Google button
        contentView.addSubview(googleButton)
        NSLayoutConstraint.activate([
            googleButton.topAnchor.constraint(equalTo: dividerContainer.bottomAnchor, constant: 32),
            googleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            googleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            googleButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add login section
        contentView.addSubview(loginContainer)
        loginContainer.addSubview(loginLabel)
        loginContainer.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            // Login container
            loginContainer.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 40),
            loginContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loginContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            // Login label and button
            loginLabel.leadingAnchor.constraint(equalTo: loginContainer.leadingAnchor),
            loginLabel.centerYAnchor.constraint(equalTo: loginContainer.centerYAnchor),
            loginLabel.topAnchor.constraint(equalTo: loginContainer.topAnchor),
            loginLabel.bottomAnchor.constraint(equalTo: loginContainer.bottomAnchor),
            
            loginButton.leadingAnchor.constraint(equalTo: loginLabel.trailingAnchor, constant: 4),
            loginButton.centerYAnchor.constraint(equalTo: loginContainer.centerYAnchor),
            loginButton.trailingAnchor.constraint(equalTo: loginContainer.trailingAnchor)
        ])
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        termsCheckbox.addTarget(self, action: #selector(termsCheckboxTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleSignupTapped), for: .touchUpInside)
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
    
    @objc private func termsCheckboxTapped() {
        termsCheckbox.isSelected.toggle()
    }
    
    @objc private func signupTapped() {
        guard let name = nameField.text, !name.isEmpty,
              let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordField.text, !confirmPassword.isEmpty else {
            showAlert(message: "Please fill in all fields")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(message: "Passwords don't match")
            return
        }
        
        guard termsCheckbox.isSelected else {
            showAlert(message: "Please agree to the Terms of Service")
            return
        }
        
        // TODO: Implement Firebase authentication
        // For now, navigate to onboarding
        let onboardingVC = OnboardingViewController()
        onboardingVC.modalPresentationStyle = .fullScreen
        present(onboardingVC, animated: true)
    }
    
    @objc private func loginTapped() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    @objc private func googleSignupTapped() {
        // TODO: Implement Google Sign-In
        showAlert(message: "Google Sign-Up coming soon")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
} 