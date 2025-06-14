import UIKit

class OnboardingViewController: UIViewController {
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            image: UIImage(systemName: "book.fill")!,
            title: "Record Your Dreams",
            description: "Easily record each dream through text or voice, capturing fleeting dream details"
        ),
        OnboardingPage(
            image: UIImage(systemName: "sparkles")!,
            title: "Explore Your Mind", 
            description: "Analyze patterns, emotions, and recurring themes in your dreams"
        ),
        OnboardingPage(
            image: UIImage(systemName: "heart.fill")!,
            title: "Get Positive Guidance",
            description: "Receive gentle insights and suggestions based on your dream patterns"
        )
    ]
    
    private let navigationContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPageIndicatorTintColor = Theme.primary
        control.pageIndicatorTintColor = UIColor(red: 203/255, green: 213/255, blue: 224/255, alpha: 1) // #CBD5E0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        Theme.styleButton(button, style: .primary)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        Theme.styleButton(button, style: .text)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var currentPageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupPageViewController()
    }
    
    private func setupViews() {
        view.backgroundColor = Theme.background
        
        // Add page view controller first
        setupPageViewController()
        
        // Add navigation container at bottom
        view.addSubview(navigationContainer)
        navigationContainer.addSubview(skipButton)
        navigationContainer.addSubview(pageControl)
        navigationContainer.addSubview(nextButton)
        
        pageControl.numberOfPages = pages.count
        
        NSLayoutConstraint.activate([
            // Navigation container at bottom (matching HTML layout)
            navigationContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            navigationContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            navigationContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            navigationContainer.heightAnchor.constraint(equalToConstant: 50),
            
            // Skip button on left
            skipButton.leadingAnchor.constraint(equalTo: navigationContainer.leadingAnchor),
            skipButton.centerYAnchor.constraint(equalTo: navigationContainer.centerYAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: 80),
            
            // Page control in center
            pageControl.centerXAnchor.constraint(equalTo: navigationContainer.centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: navigationContainer.centerYAnchor),
            
            // Next button on right
            nextButton.trailingAnchor.constraint(equalTo: navigationContainer.trailingAnchor),
            nextButton.centerYAnchor.constraint(equalTo: navigationContainer.centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        
        updateButtonTitle()
    }
    
    private func setupPageViewController() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120) // Space for navigation
        ])
        
        pageViewController.didMove(toParent: self)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let firstPage = OnboardingContentViewController(page: pages[0]) {
            pageViewController.setViewControllers([firstPage], direction: .forward, animated: true)
        }
    }
    
    @objc private func nextButtonTapped() {
        if currentPageIndex < pages.count - 1 {
            currentPageIndex += 1
            pageControl.currentPage = currentPageIndex
            if let nextPage = OnboardingContentViewController(page: pages[currentPageIndex]) {
                pageViewController.setViewControllers([nextPage], direction: .forward, animated: true)
            }
            updateButtonTitle()
        } else {
            navigateToMain()
        }
    }
    
    @objc private func skipButtonTapped() {
        navigateToMain()
    }
    
    private func updateButtonTitle() {
        let title = currentPageIndex == pages.count - 1 ? "Get Started" : "Next"
        nextButton.setTitle(title, for: .normal)
    }
    
    private func navigateToMain() {
        let mainVC = MainTabBarController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }
}

// MARK: - UIPageViewControllerDataSource & UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let contentVC = viewController as? OnboardingContentViewController,
              let currentIndex = pages.firstIndex(where: { $0 == contentVC.page }),
              currentIndex > 0 else {
            return nil
        }
        return OnboardingContentViewController(page: pages[currentIndex - 1])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let contentVC = viewController as? OnboardingContentViewController,
              let currentIndex = pages.firstIndex(where: { $0 == contentVC.page }),
              currentIndex < pages.count - 1 else {
            return nil
        }
        return OnboardingContentViewController(page: pages[currentIndex + 1])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let currentVC = pageViewController.viewControllers?.first as? OnboardingContentViewController,
           let currentIndex = pages.firstIndex(where: { $0 == currentVC.page }) {
            currentPageIndex = currentIndex
            pageControl.currentPage = currentIndex
            updateButtonTitle()
        }
    }
}

// MARK: - OnboardingPage Model
struct OnboardingPage: Equatable {
    let image: UIImage
    let title: String
    let description: String
}

// MARK: - OnboardingContentViewController
class OnboardingContentViewController: UIViewController {
    let page: OnboardingPage
    
    private let illustrationContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let illustrationCircle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 235/255, green: 244/255, blue: 255/255, alpha: 1) // #EBF4FF
        view.layer.cornerRadius = 140 // 280px diameter / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let contentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 28, weight: .bold)
        label.textColor = Theme.primaryText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 17, weight: .regular)
        label.textColor = Theme.secondaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init?(page: OnboardingPage) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = Theme.background
        
        // Add illustration container
        view.addSubview(illustrationContainer)
        illustrationContainer.addSubview(illustrationCircle)
        illustrationCircle.addSubview(imageView)
        
        // Add content container
        view.addSubview(contentContainer)
        contentContainer.addSubview(titleLabel)
        contentContainer.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            // Illustration container - takes most of the space
            illustrationContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            illustrationContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            illustrationContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            illustrationContainer.heightAnchor.constraint(equalToConstant: 350),
            
            // Illustration circle - 280x280 like HTML
            illustrationCircle.centerXAnchor.constraint(equalTo: illustrationContainer.centerXAnchor),
            illustrationCircle.centerYAnchor.constraint(equalTo: illustrationContainer.centerYAnchor),
            illustrationCircle.widthAnchor.constraint(equalToConstant: 280),
            illustrationCircle.heightAnchor.constraint(equalToConstant: 280),
            
            // Image view - 120px icon like HTML
            imageView.centerXAnchor.constraint(equalTo: illustrationCircle.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: illustrationCircle.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            // Content container - below illustration
            contentContainer.topAnchor.constraint(equalTo: illustrationContainer.bottomAnchor, constant: 40),
            contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentContainer.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -40),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            
            // Description - 16px spacing from title like HTML
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            descriptionLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 320) // Max width like HTML
        ])
        
        // Apply gradient to icon like HTML
        imageView.image = page.image
        imageView.tintColor = Theme.primary
        titleLabel.text = page.title
        descriptionLabel.text = page.description
        
        // Add shadow to illustration circle like HTML
        illustrationCircle.layer.shadowColor = UIColor.black.cgColor
        illustrationCircle.layer.shadowOffset = CGSize(width: 0, height: 10)
        illustrationCircle.layer.shadowRadius = 15
        illustrationCircle.layer.shadowOpacity = 0.1
    }
} 