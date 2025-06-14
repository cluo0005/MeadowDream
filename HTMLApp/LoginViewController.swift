import UIKit

class LoginViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Theme.primary
        imageView.image = UIImage(systemName: "moon.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome Back"
        label.font = Theme.font(size: 32, weight: .bold)
        label.textColor = Theme.primaryText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in to continue your dream journey"
        label.font = Theme.font(size: 16, weight: .regular)
        label.textColor = Theme.secondaryText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        Theme.styleButton(button, style: .text)
        button.titleLabel?.font = Theme.font(size: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
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
    
    private let signupContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let signupLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.font = Theme.font(size: 14, weight: .regular)
        label.textColor = Theme.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
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
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Add header with logo
        contentView.addSubview(logoContainer)
        logoContainer.addSubview(logoIcon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            // Logo container
            logoContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            logoContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoContainer.widthAnchor.constraint(equalToConstant: 80),
            logoContainer.heightAnchor.constraint(equalToConstant: 80),
            
            // Logo icon
            logoIcon.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
            logoIcon.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor),
            logoIcon.widthAnchor.constraint(equalToConstant: 40),
            logoIcon.heightAnchor.constraint(equalToConstant: 40),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: logoContainer.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        // Add form fields
        contentView.addSubview(emailField)
        contentView.addSubview(passwordField)
        contentView.addSubview(forgotPasswordButton)
        contentView.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            // Email field
            emailField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            // Password field
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            // Forgot password
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 12),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Login button
            loginButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 24),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add divider
        contentView.addSubview(dividerContainer)
        dividerContainer.addSubview(dividerLine1)
        dividerContainer.addSubview(dividerLabel)
        dividerContainer.addSubview(dividerLine2)
        
        NSLayoutConstraint.activate([
            // Divider container
            dividerContainer.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 32),
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
        
        // Add signup section
        contentView.addSubview(signupContainer)
        signupContainer.addSubview(signupLabel)
        signupContainer.addSubview(signupButton)
        
        NSLayoutConstraint.activate([
            // Signup container
            signupContainer.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 40),
            signupContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signupContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            // Signup label and button
            signupLabel.leadingAnchor.constraint(equalTo: signupContainer.leadingAnchor),
            signupLabel.centerYAnchor.constraint(equalTo: signupContainer.centerYAnchor),
            signupLabel.topAnchor.constraint(equalTo: signupContainer.topAnchor),
            signupLabel.bottomAnchor.constraint(equalTo: signupContainer.bottomAnchor),
            
            signupButton.leadingAnchor.constraint(equalTo: signupLabel.trailingAnchor, constant: 4),
            signupButton.centerYAnchor.constraint(equalTo: signupContainer.centerYAnchor),
            signupButton.trailingAnchor.constraint(equalTo: signupContainer.trailingAnchor)
        ])
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleLoginTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
    }
    
    @objc private func loginTapped() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert(message: "Please enter email and password")
            return
        }
        
        // TODO: Implement Firebase authentication
        // For now, navigate to main app
        let mainVC = MainTabBarController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }
    
    @objc private func signupTapped() {
        let signupVC = SignupViewController()
        signupVC.modalPresentationStyle = .fullScreen
        present(signupVC, animated: true)
    }
    
    @objc private func googleLoginTapped() {
        // TODO: Implement Google Sign-In
        showAlert(message: "Google Sign-In coming soon")
    }
    
    @objc private func forgotPasswordTapped() {
        // TODO: Implement password reset
        showAlert(message: "Password reset coming soon")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
} 