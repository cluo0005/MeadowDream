import UIKit

class InterpretationLoadingViewController: UIViewController {
    private let dream: Dream
    
    private let backgroundGradient = GradientView()
    
    private let backButton: HeaderButton = {
        let button = HeaderButton()
        button.setTitle("×", for: .normal)
        button.titleLabel?.font = Theme.font(size: 24, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return button
    }()
    
    private let contentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loadingIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "brain.head.profile")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Analyzing Your Dream"
        label.font = Theme.font(size: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Our AI is interpreting the symbols and patterns in your dream..."
        label.font = Theme.font(size: 16, weight: .regular)
        label.textColor = .white
        label.alpha = 0.9
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let progressTrack: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.font = Theme.font(size: 14, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Initializing analysis..."
        label.font = Theme.font(size: 14, weight: .medium)
        label.textColor = .white
        label.alpha = 0.8
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var progressWidthConstraint: NSLayoutConstraint!
    private var timer: Timer?
    private var progress: Float = 0
    private let statuses = [
        "Initializing analysis...",
        "Processing dream content...",
        "Identifying symbols...",
        "Analyzing emotions...",
        "Generating insights...",
        "Finalizing interpretation..."
    ]
    private var currentStatusIndex = 0
    
    init(dream: Dream) {
        self.dream = dream
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        startLoadingAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }
    
    private func setupViews() {
        // Add gradient background
        view.addSubview(backgroundGradient)
        
        // Add back button
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Add content container
        view.addSubview(contentContainer)
        contentContainer.addSubview(loadingIcon)
        contentContainer.addSubview(titleLabel)
        contentContainer.addSubview(subtitleLabel)
        contentContainer.addSubview(progressContainer)
        progressContainer.addSubview(progressTrack)
        progressContainer.addSubview(progressBar)
        contentContainer.addSubview(progressLabel)
        contentContainer.addSubview(statusLabel)
        
        // Setup progress bar constraint
        progressWidthConstraint = progressBar.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            // Content container - centered
            contentContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentContainer.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            contentContainer.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            // Loading icon
            loadingIcon.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            loadingIcon.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            loadingIcon.widthAnchor.constraint(equalToConstant: 80),
            loadingIcon.heightAnchor.constraint(equalToConstant: 80),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: loadingIcon.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            subtitleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 320),
            
            // Progress container
            progressContainer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 48),
            progressContainer.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            progressContainer.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            progressContainer.heightAnchor.constraint(equalToConstant: 8),
            
            // Progress track
            progressTrack.topAnchor.constraint(equalTo: progressContainer.topAnchor),
            progressTrack.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
            progressTrack.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor),
            progressTrack.bottomAnchor.constraint(equalTo: progressContainer.bottomAnchor),
            
            // Progress bar
            progressBar.topAnchor.constraint(equalTo: progressContainer.topAnchor),
            progressBar.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
            progressBar.bottomAnchor.constraint(equalTo: progressContainer.bottomAnchor),
            progressWidthConstraint,
            
            // Progress label
            progressLabel.topAnchor.constraint(equalTo: progressContainer.bottomAnchor, constant: 16),
            progressLabel.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            
            // Status label
            statusLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor)
        ])
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    
    private func startLoadingAnimation() {
        // Animate the brain icon
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction]) {
            self.loadingIcon.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.loadingIcon.alpha = 0.7
        }
        
        // Start progress animation
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateProgress()
        }
    }
    
    private func updateProgress() {
        progress += 0.5 // Increase by 0.5% every 0.1 seconds (5% per second)
        
        let progressWidth = view.bounds.width - 40 // Account for margins
        progressWidthConstraint.constant = CGFloat(progress / 100) * progressWidth
        
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        
        progressLabel.text = "\(Int(progress))%"
        
        // Update status message
        let statusIndex = min(Int(progress / 17), statuses.count - 1) // Change status every ~17%
        if statusIndex != currentStatusIndex {
            currentStatusIndex = statusIndex
            UIView.transition(with: statusLabel, duration: 0.3, options: .transitionCrossDissolve) {
                self.statusLabel.text = self.statuses[statusIndex]
            }
        }
        
        // Complete loading when progress reaches 100%
        if progress >= 100 {
            timer?.invalidate()
            timer = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.showInterpretationResult()
            }
        }
    }
    
    private func showInterpretationResult() {
        let resultVC = InterpretationResultViewController(dream: dream)
        resultVC.modalPresentationStyle = .fullScreen
        present(resultVC, animated: true)
    }
    
    @objc private func backTapped() {
        timer?.invalidate()
        timer = nil
        dismiss(animated: true)
    }
    
    deinit {
        timer?.invalidate()
    }
} 