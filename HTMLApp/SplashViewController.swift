import UIKit

class SplashViewController: UIViewController {
    private let gradientView = GradientView()
    
    private let logoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 25
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
        label.text = "Meadow Dream"
        label.font = Theme.font(size: 32, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.text = "Record dreams, explore your mind, receive positive guidance"
        label.font = Theme.font(size: 16, weight: .regular)
        label.textColor = .white
        label.alpha = 0.9
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loadingView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let starsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStars()
        animateLoadingDots()
        
        // Navigate to onboarding after delay (matching HTML timing)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.navigateToOnboarding()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientView.frame = view.bounds
    }
    
    private func setupViews() {
        // Add gradient background (matching HTML gradient)
        view.addSubview(gradientView)
        
        // Add stars container
        view.addSubview(starsContainer)
        NSLayoutConstraint.activate([
            starsContainer.topAnchor.constraint(equalTo: view.topAnchor),
            starsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            starsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            starsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Create main content container to center everything
        let contentContainer = UIView()
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentContainer)
        
        // Add logo container and icon
        contentContainer.addSubview(logoContainer)
        logoContainer.addSubview(logoIcon)
        
        // Add title and tagline
        contentContainer.addSubview(titleLabel)
        contentContainer.addSubview(taglineLabel)
        
        // Add loading dots
        contentContainer.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            // Content container - centered in view
            contentContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentContainer.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            contentContainer.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            // Logo container - 120x120 like HTML
            logoContainer.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            logoContainer.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            logoContainer.widthAnchor.constraint(equalToConstant: 120),
            logoContainer.heightAnchor.constraint(equalToConstant: 120),
            
            // Logo icon - 60px like HTML
            logoIcon.centerXAnchor.constraint(equalTo: logoContainer.centerXAnchor),
            logoIcon.centerYAnchor.constraint(equalTo: logoContainer.centerYAnchor),
            logoIcon.widthAnchor.constraint(equalToConstant: 60),
            logoIcon.heightAnchor.constraint(equalToConstant: 60),
            
            // Title - 24px spacing from logo like HTML
            titleLabel.topAnchor.constraint(equalTo: logoContainer.bottomAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            
            // Tagline - 8px spacing from title like HTML
            taglineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            taglineLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            taglineLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            taglineLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 280), // Max width like HTML
            
            // Loading dots - 40px spacing from tagline like HTML
            loadingView.topAnchor.constraint(equalTo: taglineLabel.bottomAnchor, constant: 40),
            loadingView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            loadingView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor)
        ])
        
        // Create loading dots (matching HTML style)
        for _ in 0...2 {
            let dot = UIView()
            dot.backgroundColor = .white
            dot.alpha = 0.6
            dot.layer.cornerRadius = 4
            dot.translatesAutoresizingMaskIntoConstraints = false
            loadingView.addArrangedSubview(dot)
            
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: 8),
                dot.heightAnchor.constraint(equalToConstant: 8)
            ])
        }
    }
    
    private func setupStars() {
        // Create 50 stars like HTML
        for _ in 0...49 {
            let star = UIView()
            star.backgroundColor = .white
            star.alpha = 0
            star.layer.cornerRadius = 1.5
            star.translatesAutoresizingMaskIntoConstraints = false
            starsContainer.addSubview(star)
            
            // Random size between 1-3 points like HTML
            let size = CGFloat.random(in: 1...3)
            star.widthAnchor.constraint(equalToConstant: size).isActive = true
            star.heightAnchor.constraint(equalToConstant: size).isActive = true
            
            // Random position
            let xPosition = CGFloat.random(in: 0...1)
            let yPosition = CGFloat.random(in: 0...1)
            
            // Use multiplier constraints for percentage positioning
            star.centerXAnchor.constraint(equalTo: starsContainer.leadingAnchor, constant: xPosition * view.bounds.width).isActive = true
            star.centerYAnchor.constraint(equalTo: starsContainer.topAnchor, constant: yPosition * view.bounds.height).isActive = true
            
            // Animate star (twinkle effect like HTML)
            let delay = Double.random(in: 0...4)
            animateStar(star, delay: delay)
        }
    }
    
    private func animateStar(_ star: UIView, delay: TimeInterval) {
        UIView.animate(withDuration: 2, delay: delay, options: [.autoreverse, .repeat, .allowUserInteraction]) {
            star.alpha = 0.8
        }
    }
    
    private func animateLoadingDots() {
        // Pulse animation like HTML
        for (index, dot) in loadingView.arrangedSubviews.enumerated() {
            UIView.animate(withDuration: 1.5, delay: Double(index) * 0.3, options: [.autoreverse, .repeat, .allowUserInteraction]) {
                dot.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                dot.alpha = 1
            }
        }
    }
    
    private func navigateToOnboarding() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.modalPresentationStyle = .fullScreen
        onboardingVC.modalTransitionStyle = .crossDissolve
        present(onboardingVC, animated: true)
    }
} 