import UIKit

class InterpretationViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dreamStore = DreamStore.shared
    
    // Sample dream for demonstration
    private var currentDream: Dream {
        return dreamStore.dreams.first ?? Dream(
            title: "Lost in the Forest",
            description: "I dreamed that I was lost in a dark forest, surrounded by tall trees, and I felt very scared. Suddenly, I saw a light in the distance, and I started walking towards it...",
            mood: .scared,
            isLucid: false,
            tags: ["Forest", "Lost", "Darkness", "Light"]
        )
    }
    
    private let headerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: HeaderButton = {
        let button = HeaderButton()
        button.setTitle("←", for: .normal)
        button.titleLabel?.font = Theme.font(size: 18, weight: .medium)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Dream Interpretation"
        label.font = Theme.font(size: 18, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let shareButton: HeaderButton = {
        let button = HeaderButton()
        button.setTitle("⤴", for: .normal)
        button.titleLabel?.font = Theme.font(size: 16, weight: .medium)
        return button
    }()
    
    private let tabContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 237/255, green: 242/255, blue: 247/255, alpha: 1) // #EDF2F7
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tabStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var tabButtons: [InterpretationTabButton] = []
    private var currentTabIndex = 0
    
    private let contentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTabs()
        setupActions()
        displayTabContent(index: 0)
    }
    
    private func setupViews() {
        view.backgroundColor = Theme.background
        
        // Hide default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Setup header
        view.addSubview(headerContainer)
        headerContainer.addSubview(backButton)
        headerContainer.addSubview(titleLabel)
        headerContainer.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 60),
            
            backButton.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            
            shareButton.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -20),
            shareButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor)
        ])
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Add dream card
        let dreamCard = createDreamCard()
        contentView.addSubview(dreamCard)
        
        // Add tab container
        contentView.addSubview(tabContainer)
        tabContainer.addSubview(tabStackView)
        
        // Add content container
        contentView.addSubview(contentContainerView)
        
        NSLayoutConstraint.activate([
            // Dream card
            dreamCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            dreamCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dreamCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Tab container
            tabContainer.topAnchor.constraint(equalTo: dreamCard.bottomAnchor, constant: 16),
            tabContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tabContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tabContainer.heightAnchor.constraint(equalToConstant: 44),
            
            tabStackView.topAnchor.constraint(equalTo: tabContainer.topAnchor, constant: 8),
            tabStackView.leadingAnchor.constraint(equalTo: tabContainer.leadingAnchor, constant: 8),
            tabStackView.trailingAnchor.constraint(equalTo: tabContainer.trailingAnchor, constant: -8),
            tabStackView.bottomAnchor.constraint(equalTo: tabContainer.bottomAnchor, constant: -8),
            
            // Content container
            contentContainerView.topAnchor.constraint(equalTo: tabContainer.bottomAnchor, constant: 20),
            contentContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupTabs() {
        let tabTitles = ["Symbol Analysis", "Pattern Analysis", "Emotion Analysis"]
        
        for (index, title) in tabTitles.enumerated() {
            let button = InterpretationTabButton(title: title)
            button.isSelected = index == 0
            button.tag = index
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            tabButtons.append(button)
            tabStackView.addArrangedSubview(button)
        }
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
    
    @objc private func shareTapped() {
        // TODO: Implement sharing functionality
        showComingSoonAlert()
    }
    
    @objc private func tabButtonTapped(_ sender: InterpretationTabButton) {
        let newIndex = sender.tag
        
        // Update tab selection
        for (index, button) in tabButtons.enumerated() {
            button.isSelected = index == newIndex
        }
        
        currentTabIndex = newIndex
        displayTabContent(index: newIndex)
    }
    
    private func displayTabContent(index: Int) {
        // Clear existing content
        contentContainerView.subviews.forEach { $0.removeFromSuperview() }
        
        let contentView: UIView
        
        switch index {
        case 0:
            contentView = createSymbolAnalysisContent()
        case 1:
            contentView = createPatternAnalysisContent()
        case 2:
            contentView = createEmotionAnalysisContent()
        default:
            contentView = UIView()
        }
        
        contentContainerView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor)
        ])
    }
    
    private func createDreamCard() -> UIView {
        let card = UIView()
        Theme.styleCard(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = currentDream.title
        titleLabel.font = Theme.font(size: 20, weight: .bold)
        titleLabel.textColor = Theme.primaryText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let metaContainer = UIView()
        metaContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let dateIcon = UIImageView()
        dateIcon.image = UIImage(systemName: "calendar")
        dateIcon.tintColor = Theme.tertiaryText
        dateIcon.contentMode = .scaleAspectFit
        dateIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        dateLabel.text = formatter.string(from: currentDream.date)
        dateLabel.font = Theme.font(size: 14, weight: .medium)
        dateLabel.textColor = Theme.tertiaryText
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let emotionIcon = UIImageView()
        emotionIcon.image = UIImage(systemName: "face.dashed")
        emotionIcon.tintColor = Theme.tertiaryText
        emotionIcon.contentMode = .scaleAspectFit
        emotionIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let emotionLabel = UILabel()
        emotionLabel.text = currentDream.mood.rawValue.capitalized
        emotionLabel.font = Theme.font(size: 14, weight: .medium)
        emotionLabel.textColor = Theme.tertiaryText
        emotionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        metaContainer.addSubview(dateIcon)
        metaContainer.addSubview(dateLabel)
        metaContainer.addSubview(emotionIcon)
        metaContainer.addSubview(emotionLabel)
        
        let contentLabel = UILabel()
        contentLabel.text = currentDream.description
        contentLabel.font = Theme.font(size: 16, weight: .regular)
        contentLabel.textColor = Theme.primaryText
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let tagsContainer = UIView()
        tagsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(titleLabel)
        card.addSubview(metaContainer)
        card.addSubview(contentLabel)
        card.addSubview(tagsContainer)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            
            metaContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            metaContainer.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            metaContainer.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            metaContainer.heightAnchor.constraint(equalToConstant: 20),
            
            dateIcon.leadingAnchor.constraint(equalTo: metaContainer.leadingAnchor),
            dateIcon.centerYAnchor.constraint(equalTo: metaContainer.centerYAnchor),
            dateIcon.widthAnchor.constraint(equalToConstant: 16),
            dateIcon.heightAnchor.constraint(equalToConstant: 16),
            
            dateLabel.leadingAnchor.constraint(equalTo: dateIcon.trailingAnchor, constant: 8),
            dateLabel.centerYAnchor.constraint(equalTo: metaContainer.centerYAnchor),
            
            emotionIcon.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 20),
            emotionIcon.centerYAnchor.constraint(equalTo: metaContainer.centerYAnchor),
            emotionIcon.widthAnchor.constraint(equalToConstant: 16),
            emotionIcon.heightAnchor.constraint(equalToConstant: 16),
            
            emotionLabel.leadingAnchor.constraint(equalTo: emotionIcon.trailingAnchor, constant: 8),
            emotionLabel.centerYAnchor.constraint(equalTo: metaContainer.centerYAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: metaContainer.bottomAnchor, constant: 16),
            contentLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            
            tagsContainer.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 16),
            tagsContainer.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            tagsContainer.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            tagsContainer.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20)
        ])
        
        // Add tags
        let tagStackView = UIStackView()
        tagStackView.axis = .horizontal
        tagStackView.spacing = 8
        tagStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for tag in currentDream.tags.prefix(4) {
            let tagView = Theme.createTag(text: tag)
            tagStackView.addArrangedSubview(tagView)
        }
        
        tagsContainer.addSubview(tagStackView)
        NSLayoutConstraint.activate([
            tagStackView.topAnchor.constraint(equalTo: tagsContainer.topAnchor),
            tagStackView.leadingAnchor.constraint(equalTo: tagsContainer.leadingAnchor),
            tagStackView.bottomAnchor.constraint(equalTo: tagsContainer.bottomAnchor)
        ])
        
        return card
    }
    
    private func createSymbolAnalysisContent() -> UIView {
        let container = UIView()
        
        let symbols = [
            ("tree", "Forest", "In dreams, forests typically symbolize the unknown, the subconscious, or a confusing phase in life. A dark forest may represent challenges or uncertainties you're facing that make you feel lost or disoriented."),
            ("signpost", "Being Lost", "Being lost symbolizes that you may feel directionless or uncertain about your future in real life. This could be related to career choices, relationships, or personal growth, indicating that you're searching for your path."),
            ("lightbulb", "Distant Light", "The light seen in darkness represents hope, guidance, and solutions. This suggests that even in difficult times, you can find direction forward, indicating that deep down you know how to overcome your current challenges.")
        ]
        
        var lastView: UIView?
        
        for (icon, title, description) in symbols {
            let symbolView = createSymbolItem(icon: icon, title: title, description: description)
            container.addSubview(symbolView)
            
            NSLayoutConstraint.activate([
                symbolView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                symbolView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
            ])
            
            if let lastView = lastView {
                symbolView.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 20).isActive = true
            } else {
                symbolView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            }
            
            lastView = symbolView
        }
        
        if let lastView = lastView {
            lastView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        }
        
        return container
    }
    
    private func createPatternAnalysisContent() -> UIView {
        let container = UIView()
        
        let patterns = [
            ("magnifyingglass", "Journey of Finding Direction", "This dream reflects a common psychological pattern: seeking direction when facing uncertainty. Your dream suggests you're going through a transition period, and although you feel lost, you're actively looking for a way out."),
            ("scale.3d", "Contrast Between Darkness and Light", "The contrast between the dark forest and the distant light symbolizes the balance between challenges and hope. This contrast suggests that you can see positive possibilities even in difficult situations, which is an important sign of psychological resilience."),
            ("arrow.up.and.down.and.arrow.left.and.right", "Transition from Passive to Active", "At the beginning of the dream, you were in a passive state (being lost), but after seeing the light, you took active action (walking towards the light). This indicates your ability to recover from difficult situations and take positive steps to change your circumstances.")
        ]
        
        var lastView: UIView?
        
        for (icon, title, description) in patterns {
            let patternView = createPatternItem(icon: icon, title: title, description: description)
            container.addSubview(patternView)
            
            NSLayoutConstraint.activate([
                patternView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                patternView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
            ])
            
            if let lastView = lastView {
                patternView.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 20).isActive = true
            } else {
                patternView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            }
            
            lastView = patternView
        }
        
        if let lastView = lastView {
            lastView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        }
        
        return container
    }
    
    private func createEmotionAnalysisContent() -> UIView {
        let container = UIView()
        
        let emotions = [
            ("Fear", 75, UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1)),
            ("Anxiety", 65, UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1)),
            ("Confusion", 60, UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1)),
            ("Curiosity", 40, UIColor(red: 72/255, green: 187/255, blue: 120/255, alpha: 1)),
            ("Hope", 35, UIColor(red: 66/255, green: 153/255, blue: 225/255, alpha: 1))
        ]
        
        let emotionContainer = UIView()
        emotionContainer.translatesAutoresizingMaskIntoConstraints = false
        
        var lastEmotionView: UIView?
        
        for (emotion, percentage, color) in emotions {
            let emotionView = createEmotionBar(emotion: emotion, percentage: percentage, color: color)
            emotionContainer.addSubview(emotionView)
            
            NSLayoutConstraint.activate([
                emotionView.leadingAnchor.constraint(equalTo: emotionContainer.leadingAnchor),
                emotionView.trailingAnchor.constraint(equalTo: emotionContainer.trailingAnchor),
                emotionView.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            if let lastView = lastEmotionView {
                emotionView.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 16).isActive = true
            } else {
                emotionView.topAnchor.constraint(equalTo: emotionContainer.topAnchor).isActive = true
            }
            
            lastEmotionView = emotionView
        }
        
        if let lastView = lastEmotionView {
            lastView.bottomAnchor.constraint(equalTo: emotionContainer.bottomAnchor).isActive = true
        }
        
        // Add emotional summary card
        let summaryCard = UIView()
        Theme.styleCard(summaryCard)
        summaryCard.translatesAutoresizingMaskIntoConstraints = false
        
        let summaryTitle = UILabel()
        summaryTitle.text = "Emotional Summary"
        summaryTitle.font = Theme.font(size: 16, weight: .semibold)
        summaryTitle.textColor = Theme.primary
        summaryTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let summaryContent = UILabel()
        summaryContent.text = "Your dream primarily reflects emotions of fear and anxiety, which may be related to uncertainties in your real life. However, the presence of hope and curiosity suggests that deep down, you maintain a positive attitude toward facing challenges. This emotional balance is very important for mental health."
        summaryContent.font = Theme.font(size: 16, weight: .regular)
        summaryContent.textColor = Theme.primaryText
        summaryContent.numberOfLines = 0
        summaryContent.lineBreakMode = .byWordWrapping
        summaryContent.translatesAutoresizingMaskIntoConstraints = false
        
        summaryCard.addSubview(summaryTitle)
        summaryCard.addSubview(summaryContent)
        
        NSLayoutConstraint.activate([
            summaryTitle.topAnchor.constraint(equalTo: summaryCard.topAnchor, constant: 20),
            summaryTitle.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 20),
            summaryTitle.trailingAnchor.constraint(equalTo: summaryCard.trailingAnchor, constant: -20),
            
            summaryContent.topAnchor.constraint(equalTo: summaryTitle.bottomAnchor, constant: 12),
            summaryContent.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 20),
            summaryContent.trailingAnchor.constraint(equalTo: summaryCard.trailingAnchor, constant: -20),
            summaryContent.bottomAnchor.constraint(equalTo: summaryCard.bottomAnchor, constant: -20)
        ])
        
        container.addSubview(emotionContainer)
        container.addSubview(summaryCard)
        
        NSLayoutConstraint.activate([
            emotionContainer.topAnchor.constraint(equalTo: container.topAnchor),
            emotionContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            emotionContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            summaryCard.topAnchor.constraint(equalTo: emotionContainer.bottomAnchor, constant: 20),
            summaryCard.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            summaryCard.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            summaryCard.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func createSymbolItem(icon: String, title: String, description: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let iconContainer = UIView()
        iconContainer.backgroundColor = UIColor(red: 235/255, green: 244/255, blue: 255/255, alpha: 1) // #EBF4FF
        iconContainer.layer.cornerRadius = 20
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = Theme.primary
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Theme.font(size: 16, weight: .semibold)
        titleLabel.textColor = Theme.primaryText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = Theme.font(size: 15, weight: .regular)
        descriptionLabel.textColor = Theme.secondaryText
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        iconContainer.addSubview(iconView)
        container.addSubview(iconContainer)
        container.addSubview(titleLabel)
        container.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            iconContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            iconContainer.topAnchor.constraint(equalTo: container.topAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 40),
            iconContainer.heightAnchor.constraint(equalToConstant: 40),
            
            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: iconContainer.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func createPatternItem(icon: String, title: String, description: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let titleContainer = UIView()
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = Theme.primary
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Theme.font(size: 16, weight: .semibold)
        titleLabel.textColor = Theme.primaryText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = Theme.font(size: 15, weight: .regular)
        descriptionLabel.textColor = Theme.secondaryText
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleContainer.addSubview(iconView)
        titleContainer.addSubview(titleLabel)
        container.addSubview(titleContainer)
        container.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            titleContainer.topAnchor.constraint(equalTo: container.topAnchor),
            titleContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            titleContainer.heightAnchor.constraint(equalToConstant: 24),
            
            iconView.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 16),
            iconView.heightAnchor.constraint(equalToConstant: 16),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 28),
            descriptionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func createEmotionBar(emotion: String, percentage: Int, color: UIColor) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let emotionLabel = UILabel()
        emotionLabel.text = emotion
        emotionLabel.font = Theme.font(size: 14, weight: .medium)
        emotionLabel.textColor = Theme.primaryText
        emotionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let barContainer = UIView()
        barContainer.backgroundColor = UIColor(red: 237/255, green: 242/255, blue: 247/255, alpha: 1) // #EDF2F7
        barContainer.layer.cornerRadius = 4
        barContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let barFill = UIView()
        barFill.backgroundColor = color
        barFill.layer.cornerRadius = 4
        barFill.translatesAutoresizingMaskIntoConstraints = false
        
        let percentageLabel = UILabel()
        percentageLabel.text = "\(percentage)%"
        percentageLabel.font = Theme.font(size: 14, weight: .medium)
        percentageLabel.textColor = Theme.primaryText
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        barContainer.addSubview(barFill)
        container.addSubview(emotionLabel)
        container.addSubview(barContainer)
        container.addSubview(percentageLabel)
        
        NSLayoutConstraint.activate([
            emotionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            emotionLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            emotionLabel.widthAnchor.constraint(equalToConstant: 80),
            
            barContainer.leadingAnchor.constraint(equalTo: emotionLabel.trailingAnchor, constant: 16),
            barContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            barContainer.heightAnchor.constraint(equalToConstant: 8),
            
            percentageLabel.leadingAnchor.constraint(equalTo: barContainer.trailingAnchor, constant: 16),
            percentageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            percentageLabel.widthAnchor.constraint(equalToConstant: 40),
            
            barFill.leadingAnchor.constraint(equalTo: barContainer.leadingAnchor),
            barFill.topAnchor.constraint(equalTo: barContainer.topAnchor),
            barFill.bottomAnchor.constraint(equalTo: barContainer.bottomAnchor),
            barFill.widthAnchor.constraint(equalTo: barContainer.widthAnchor, multiplier: CGFloat(percentage) / 100.0)
        ])
        
        return container
    }
    
    private func showComingSoonAlert() {
        let alert = UIAlertController(title: "Coming Soon", message: "This feature will be available in a future update.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Tab Button
class InterpretationTabButton: UIButton {
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = Theme.font(size: 14, weight: .medium)
        layer.cornerRadius = 8
        updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateAppearance() {
        if isSelected {
            backgroundColor = .white
            setTitleColor(Theme.primary, for: .normal)
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowRadius = 4
            layer.shadowOpacity = 0.05
        } else {
            backgroundColor = .clear
            setTitleColor(Theme.secondaryText, for: .normal)
            layer.shadowOpacity = 0
        }
    }
} 