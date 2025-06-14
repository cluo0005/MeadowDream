import UIKit

class PositiveGuidanceViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dream: Dream
    
    private let backgroundGradient = GradientView()
    
    private let backButton: HeaderButton = {
        let button = HeaderButton()
        button.setTitle("←", for: .normal)
        button.titleLabel?.font = Theme.font(size: 18, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let shareButton: HeaderButton = {
        let button = HeaderButton()
        button.setTitle("Share", for: .normal)
        button.titleLabel?.font = Theme.font(size: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Positive Guidance"
        label.font = Theme.font(size: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Transform your dream insights into positive action"
        label.font = Theme.font(size: 16, weight: .regular)
        label.textColor = .white
        label.alpha = 0.9
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let guidanceCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainMessageLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 18, weight: .semibold)
        label.textColor = Theme.primaryText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recommendationsLabel: UILabel = {
        let label = UILabel()
        label.text = "💡 Recommended Actions"
        label.font = Theme.font(size: 16, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recommendationsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let affirmationsLabel: UILabel = {
        let label = UILabel()
        label.text = "✨ Daily Affirmations"
        label.font = Theme.font(size: 16, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let affirmationsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let journalPromptsLabel: UILabel = {
        let label = UILabel()
        label.text = "📝 Journal Prompts"
        label.font = Theme.font(size: 16, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let journalPromptsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let actionButtonsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let saveGuidanceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Guidance", for: .normal)
        button.backgroundColor = Theme.primary
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Theme.font(size: 16, weight: .semibold)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let feedbackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Rate This Guidance", for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Theme.font(size: 16, weight: .medium)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        configureContent()
        setupActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradient.frame = view.bounds
    }
    
    private func setupViews() {
        // Add gradient background
        view.addSubview(backgroundGradient)
        
        // Add header buttons
        view.addSubview(backButton)
        view.addSubview(shareButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            shareButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Add title and subtitle
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Add guidance card
        contentView.addSubview(guidanceCard)
        guidanceCard.addSubview(mainMessageLabel)
        guidanceCard.addSubview(recommendationsLabel)
        guidanceCard.addSubview(recommendationsContainer)
        guidanceCard.addSubview(affirmationsLabel)
        guidanceCard.addSubview(affirmationsContainer)
        guidanceCard.addSubview(journalPromptsLabel)
        guidanceCard.addSubview(journalPromptsContainer)
        
        NSLayoutConstraint.activate([
            // Guidance card
            guidanceCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            guidanceCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            guidanceCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Main message
            mainMessageLabel.topAnchor.constraint(equalTo: guidanceCard.topAnchor, constant: 24),
            mainMessageLabel.leadingAnchor.constraint(equalTo: guidanceCard.leadingAnchor, constant: 20),
            mainMessageLabel.trailingAnchor.constraint(equalTo: guidanceCard.trailingAnchor, constant: -20),
            
            // Recommendations
            recommendationsLabel.topAnchor.constraint(equalTo: mainMessageLabel.bottomAnchor, constant: 24),
            recommendationsLabel.leadingAnchor.constraint(equalTo: guidanceCard.leadingAnchor, constant: 20),
            recommendationsLabel.trailingAnchor.constraint(equalTo: guidanceCard.trailingAnchor, constant: -20),
            
            recommendationsContainer.topAnchor.constraint(equalTo: recommendationsLabel.bottomAnchor, constant: 12),
            recommendationsContainer.leadingAnchor.constraint(equalTo: guidanceCard.leadingAnchor, constant: 20),
            recommendationsContainer.trailingAnchor.constraint(equalTo: guidanceCard.trailingAnchor, constant: -20),
            
            // Affirmations
            affirmationsLabel.topAnchor.constraint(equalTo: recommendationsContainer.bottomAnchor, constant: 24),
            affirmationsLabel.leadingAnchor.constraint(equalTo: guidanceCard.leadingAnchor, constant: 20),
            affirmationsLabel.trailingAnchor.constraint(equalTo: guidanceCard.trailingAnchor, constant: -20),
            
            affirmationsContainer.topAnchor.constraint(equalTo: affirmationsLabel.bottomAnchor, constant: 12),
            affirmationsContainer.leadingAnchor.constraint(equalTo: guidanceCard.leadingAnchor, constant: 20),
            affirmationsContainer.trailingAnchor.constraint(equalTo: guidanceCard.trailingAnchor, constant: -20),
            
            // Journal prompts
            journalPromptsLabel.topAnchor.constraint(equalTo: affirmationsContainer.bottomAnchor, constant: 24),
            journalPromptsLabel.leadingAnchor.constraint(equalTo: guidanceCard.leadingAnchor, constant: 20),
            journalPromptsLabel.trailingAnchor.constraint(equalTo: guidanceCard.trailingAnchor, constant: -20),
            
            journalPromptsContainer.topAnchor.constraint(equalTo: journalPromptsLabel.bottomAnchor, constant: 12),
            journalPromptsContainer.leadingAnchor.constraint(equalTo: guidanceCard.leadingAnchor, constant: 20),
            journalPromptsContainer.trailingAnchor.constraint(equalTo: guidanceCard.trailingAnchor, constant: -20),
            journalPromptsContainer.bottomAnchor.constraint(equalTo: guidanceCard.bottomAnchor, constant: -24)
        ])
        
        // Add action buttons
        contentView.addSubview(actionButtonsContainer)
        actionButtonsContainer.addSubview(saveGuidanceButton)
        actionButtonsContainer.addSubview(feedbackButton)
        
        NSLayoutConstraint.activate([
            // Action buttons container
            actionButtonsContainer.topAnchor.constraint(equalTo: guidanceCard.bottomAnchor, constant: 32),
            actionButtonsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actionButtonsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            actionButtonsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            // Action buttons
            saveGuidanceButton.topAnchor.constraint(equalTo: actionButtonsContainer.topAnchor),
            saveGuidanceButton.leadingAnchor.constraint(equalTo: actionButtonsContainer.leadingAnchor),
            saveGuidanceButton.trailingAnchor.constraint(equalTo: actionButtonsContainer.trailingAnchor),
            saveGuidanceButton.heightAnchor.constraint(equalToConstant: 50),
            
            feedbackButton.topAnchor.constraint(equalTo: saveGuidanceButton.bottomAnchor, constant: 12),
            feedbackButton.leadingAnchor.constraint(equalTo: actionButtonsContainer.leadingAnchor),
            feedbackButton.trailingAnchor.constraint(equalTo: actionButtonsContainer.trailingAnchor),
            feedbackButton.heightAnchor.constraint(equalToConstant: 50),
            feedbackButton.bottomAnchor.constraint(equalTo: actionButtonsContainer.bottomAnchor)
        ])
    }
    
    private func configureContent() {
        generateGuidanceContent()
        createRecommendations()
        createAffirmations()
        createJournalPrompts()
    }
    
    private func generateGuidanceContent() {
        let mainMessage = generateMainMessage()
        mainMessageLabel.text = mainMessage
    }
    
    private func generateMainMessage() -> String {
        switch dream.mood {
        case .excited, .happy:
            return "Your dream radiates positive energy and joy! This is a beautiful sign that you're aligned with your inner happiness and moving in the right direction. Use this uplifting energy to fuel your goals and share your positivity with others around you."
        case .peaceful:
            return "The peace in your dream reflects your inner wisdom and emotional balance. This is a gift that many seek but few find. Honor this tranquility by creating more moments of calm in your daily life and trusting your intuitive guidance."
        case .neutral:
            return "The neutral tone of your dream suggests a period of stability and balance in your life. This is a foundation from which you can explore new possibilities and make thoughtful decisions. Use this calm energy to reflect on your goals and plan your next steps."
        case .confused:
            return "Confusion in dreams often signals transformation and growth. Your mind is processing new possibilities and expanding beyond old limitations. Embrace this uncertainty as a sign that you're evolving and trust that clarity will come with time and patience."
        case .anxious:
            return "While anxiety can feel overwhelming, your dream is actually helping you process and release these feelings. This is your mind's way of working through challenges and building resilience. Use this awareness to practice self-compassion and seek support when needed."
        case .scared:
            return "Fear in dreams often represents your courage to face what needs to be addressed. By experiencing this in your dream, you're building strength to handle real-life challenges. Remember that facing our fears, even in dreams, is an act of bravery."
        case .sad:
            return "Sadness in dreams often signals emotional healing and the processing of important life experiences. This emotional depth shows your capacity for meaningful connections and growth. Allow yourself to feel while also reaching out for comfort and support."
        case .angry:
            return "Anger in dreams can reveal your passion and drive for positive change. This energy, when channeled constructively, can become a powerful force for transformation. Use this intensity to advocate for what matters to you and create meaningful change."
        }
    }
    
    private func createRecommendations() {
        recommendationsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let recommendations = generateRecommendations()
        
        for (index, recommendation) in recommendations.enumerated() {
            let recommendationView = createRecommendationView(number: index + 1, text: recommendation)
            recommendationsContainer.addArrangedSubview(recommendationView)
        }
    }
    
    private func generateRecommendations() -> [String] {
        switch dream.mood {
        case .excited, .happy:
            return [
                "Celebrate your current achievements and share your joy with loved ones",
                "Set new inspiring goals while maintaining this positive momentum",
                "Practice gratitude daily to sustain and amplify these good feelings"
            ]
        case .peaceful:
            return [
                "Create a daily meditation or mindfulness practice to maintain inner calm",
                "Spend time in nature to connect with this peaceful energy",
                "Share your wisdom and serenity with others who might benefit from it"
            ]
        case .neutral:
            return [
                "Take time to reflect on your current life direction and priorities",
                "Explore new interests or hobbies that might spark passion",
                "Set clear, achievable goals to create positive momentum"
            ]
        case .confused:
            return [
                "Journal about your thoughts and feelings to gain clarity",
                "Seek guidance from trusted mentors or counselors",
                "Take small steps forward without needing to see the complete path"
            ]
        case .anxious:
            return [
                "Practice deep breathing exercises and grounding techniques",
                "Break overwhelming tasks into smaller, manageable steps",
                "Connect with supportive friends or consider professional guidance"
            ]
        case .scared:
            return [
                "Identify specific fears and challenge negative thought patterns",
                "Build confidence through small acts of courage in daily life",
                "Develop a support network of people who believe in your strength"
            ]
        case .sad:
            return [
                "Allow yourself to feel emotions without judgment",
                "Engage in activities that bring comfort and healing",
                "Reach out to loved ones for connection and support"
            ]
        case .angry:
            return [
                "Channel anger into productive activities like exercise or creative expression",
                "Identify the values or boundaries that need protection",
                "Practice assertive communication to address underlying issues"
            ]
        }
    }
    
    private func createAffirmations() {
        affirmationsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let affirmations = generateAffirmations()
        
        for affirmation in affirmations {
            let affirmationView = createAffirmationView(text: affirmation)
            affirmationsContainer.addArrangedSubview(affirmationView)
        }
    }
    
    private func generateAffirmations() -> [String] {
        switch dream.mood {
        case .excited, .happy:
            return [
                "I deserve happiness and joy in my life",
                "I attract positive experiences and opportunities",
                "My enthusiasm inspires and uplifts others"
            ]
        case .peaceful:
            return [
                "I am calm, centered, and at peace with myself",
                "I trust my inner wisdom to guide me",
                "I create harmony in all aspects of my life"
            ]
        case .neutral:
            return [
                "I am open to new possibilities and experiences",
                "I trust in my ability to create positive change",
                "I am exactly where I need to be in this moment"
            ]
        case .confused:
            return [
                "It's okay not to have all the answers right now",
                "I trust that clarity will come at the right time",
                "Each step I take teaches me something valuable"
            ]
        case .anxious:
            return [
                "I am safe and capable of handling life's challenges",
                "I breathe deeply and release tension from my body",
                "I have the strength to overcome any obstacle"
            ]
        case .scared:
            return [
                "I am braver than I believe and stronger than I seem",
                "Fear is temporary, but my courage is lasting",
                "I face challenges with confidence and determination"
            ]
        case .sad:
            return [
                "It's natural and healthy to feel my emotions fully",
                "This difficult time will pass, and I will grow stronger",
                "I am worthy of love, comfort, and support"
            ]
        case .angry:
            return [
                "My anger shows me what I value and need to protect",
                "I express my feelings in healthy and constructive ways",
                "I have the power to create positive change in my life"
            ]
        }
    }
    
    private func createJournalPrompts() {
        journalPromptsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let prompts = generateJournalPrompts()
        
        for prompt in prompts {
            let promptView = createJournalPromptView(text: prompt)
            journalPromptsContainer.addArrangedSubview(promptView)
        }
    }
    
    private func generateJournalPrompts() -> [String] {
        switch dream.mood {
        case .excited, .happy:
            return [
                "What specific aspects of my life am I most grateful for right now?",
                "How can I share this positive energy with others today?",
                "What dreams and goals feel most exciting to pursue?"
            ]
        case .peaceful:
            return [
                "What practices help me maintain inner peace and balance?",
                "When do I feel most connected to my authentic self?",
                "How can I create more moments of tranquility in my daily routine?"
            ]
        case .neutral:
            return [
                "What areas of my life would I like to explore or develop further?",
                "What small changes could I make to create more meaning in my daily routine?",
                "What am I curious about that I haven't pursued yet?"
            ]
        case .confused:
            return [
                "What specific areas of my life feel unclear or uncertain?",
                "What small step can I take today to move forward?",
                "Who in my life could offer helpful perspective or guidance?"
            ]
        case .anxious:
            return [
                "What specific worries or concerns are weighing on my mind?",
                "What coping strategies have helped me feel calmer in the past?",
                "What would I tell a good friend experiencing similar anxiety?"
            ]
        case .scared:
            return [
                "What am I truly afraid of, and why might this fear exist?",
                "What evidence do I have of my own strength and resilience?",
                "What would I do if I knew I couldn't fail?"
            ]
        case .sad:
            return [
                "What loss or change am I processing right now?",
                "What brings me comfort during difficult emotional times?",
                "How have I grown stronger through past challenges?"
            ]
        case .angry:
            return [
                "What values or boundaries feel threatened or violated?",
                "How can I express these feelings in a healthy way?",
                "What positive changes could result from addressing this anger?"
            ]
        }
    }
    
    private func createRecommendationView(number: Int, text: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let numberLabel = UILabel()
        numberLabel.text = "\(number)"
        numberLabel.font = Theme.font(size: 14, weight: .bold)
        numberLabel.textColor = .white
        numberLabel.backgroundColor = Theme.primary
        numberLabel.textAlignment = .center
        numberLabel.layer.cornerRadius = 12
        numberLabel.clipsToBounds = true
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.font = Theme.font(size: 14, weight: .regular)
        textLabel.textColor = Theme.primaryText
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(numberLabel)
        container.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: container.topAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            numberLabel.widthAnchor.constraint(equalToConstant: 24),
            numberLabel.heightAnchor.constraint(equalToConstant: 24),
            
            textLabel.topAnchor.constraint(equalTo: container.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 12),
            textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func createAffirmationView(text: String) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1) // Very light gray
        container.layer.cornerRadius = 8
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let textLabel = UILabel()
        textLabel.text = "• \(text)"
        textLabel.font = Theme.font(size: 14, weight: .medium)
        textLabel.textColor = Theme.primaryText
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
        
        return container
    }
    
    private func createJournalPromptView(text: String) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(red: 248/255, green: 250/255, blue: 252/255, alpha: 1) // Very light gray
        container.layer.cornerRadius = 8
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1).cgColor
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.font = Theme.font(size: 14, weight: .regular)
        textLabel.textColor = Theme.primaryText
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
        
        return container
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        saveGuidanceButton.addTarget(self, action: #selector(saveGuidanceTapped), for: .touchUpInside)
        feedbackButton.addTarget(self, action: #selector(feedbackTapped), for: .touchUpInside)
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
    
    @objc private func shareTapped() {
        let guidanceText = """
        Positive Guidance for "\(dream.title)"
        
        \(mainMessageLabel.text ?? "")
        
        Recommended Actions:
        \(generateRecommendations().enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: "\n"))
        
        Daily Affirmations:
        \(generateAffirmations().map { "• \($0)" }.joined(separator: "\n"))
        """
        
        let activityVC = UIActivityViewController(activityItems: [guidanceText], applicationActivities: nil)
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = shareButton
            popover.sourceRect = shareButton.bounds
        }
        
        present(activityVC, animated: true)
    }
    
    @objc private func saveGuidanceTapped() {
        let alert = UIAlertController(title: "Guidance Saved", message: "Your positive guidance has been saved to your dream journal.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func feedbackTapped() {
        let alert = UIAlertController(title: "Rate This Guidance", message: "How helpful was this guidance for you?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "⭐⭐⭐⭐⭐ Excellent", style: .default) { _ in
            self.showFeedbackThanks()
        })
        alert.addAction(UIAlertAction(title: "⭐⭐⭐⭐ Good", style: .default) { _ in
            self.showFeedbackThanks()
        })
        alert.addAction(UIAlertAction(title: "⭐⭐⭐ Okay", style: .default) { _ in
            self.showFeedbackThanks()
        })
        alert.addAction(UIAlertAction(title: "⭐⭐ Poor", style: .default) { _ in
            self.showFeedbackThanks()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showFeedbackThanks() {
        let alert = UIAlertController(title: "Thank You!", message: "Your feedback helps us improve our guidance for everyone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
} 