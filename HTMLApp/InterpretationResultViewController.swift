import UIKit

class InterpretationResultViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dream: Dream
    
    private let backButton: HeaderButton = {
        let button = HeaderButton()
        button.setTitle("←", for: .normal)
        button.titleLabel?.font = Theme.font(size: 18, weight: .medium)
        return button
    }()
    
    private let shareButton: HeaderButton = {
        let button = HeaderButton()
        button.setTitle("Share", for: .normal)
        button.titleLabel?.font = Theme.font(size: 16, weight: .medium)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Dream Interpretation"
        label.font = Theme.font(size: 24, weight: .bold)
        label.textColor = Theme.primaryText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dreamTitleCard: UIView = {
        let view = UIView()
        Theme.styleCard(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dreamTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 18, weight: .semibold)
        label.textColor = Theme.primaryText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dreamDateLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 14, weight: .medium)
        label.textColor = Theme.tertiaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overallMeaningCard: UIView = {
        let view = UIView()
        Theme.styleCard(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let overallMeaningHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "✨ Overall Meaning"
        label.font = Theme.font(size: 16, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overallMeaningTextLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 15, weight: .regular)
        label.textColor = Theme.primaryText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let symbolsCard: UIView = {
        let view = UIView()
        Theme.styleCard(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let symbolsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "🔍 Key Symbols"
        label.font = Theme.font(size: 16, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let symbolsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let emotionsCard: UIView = {
        let view = UIView()
        Theme.styleCard(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emotionsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "💭 Emotional Analysis"
        label.font = Theme.font(size: 16, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emotionsTextLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 15, weight: .regular)
        label.textColor = Theme.primaryText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let insightsCard: UIView = {
        let view = UIView()
        Theme.styleCard(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let insightsHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "💡 Personal Insights"
        label.font = Theme.font(size: 16, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let insightsTextLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 15, weight: .regular)
        label.textColor = Theme.primaryText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionButtonsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Interpretation", for: .normal)
        Theme.styleButton(button, style: .primary)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let guidanceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Positive Guidance", for: .normal)
        Theme.styleButton(button, style: .secondary)
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
    
    private func setupViews() {
        view.backgroundColor = Theme.background
        
        // Add header buttons
        view.addSubview(backButton)
        view.addSubview(shareButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            shareButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
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
        
        // Add title
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        // Add dream title card
        contentView.addSubview(dreamTitleCard)
        dreamTitleCard.addSubview(dreamTitleLabel)
        dreamTitleCard.addSubview(dreamDateLabel)
        
        NSLayoutConstraint.activate([
            // Dream title card
            dreamTitleCard.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            dreamTitleCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dreamTitleCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Dream title content
            dreamTitleLabel.topAnchor.constraint(equalTo: dreamTitleCard.topAnchor, constant: 16),
            dreamTitleLabel.leadingAnchor.constraint(equalTo: dreamTitleCard.leadingAnchor, constant: 16),
            dreamTitleLabel.trailingAnchor.constraint(equalTo: dreamTitleCard.trailingAnchor, constant: -16),
            
            dreamDateLabel.topAnchor.constraint(equalTo: dreamTitleLabel.bottomAnchor, constant: 4),
            dreamDateLabel.leadingAnchor.constraint(equalTo: dreamTitleCard.leadingAnchor, constant: 16),
            dreamDateLabel.trailingAnchor.constraint(equalTo: dreamTitleCard.trailingAnchor, constant: -16),
            dreamDateLabel.bottomAnchor.constraint(equalTo: dreamTitleCard.bottomAnchor, constant: -16)
        ])
        
        // Add overall meaning card
        contentView.addSubview(overallMeaningCard)
        overallMeaningCard.addSubview(overallMeaningHeaderLabel)
        overallMeaningCard.addSubview(overallMeaningTextLabel)
        
        NSLayoutConstraint.activate([
            // Overall meaning card
            overallMeaningCard.topAnchor.constraint(equalTo: dreamTitleCard.bottomAnchor, constant: 20),
            overallMeaningCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            overallMeaningCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Overall meaning content
            overallMeaningHeaderLabel.topAnchor.constraint(equalTo: overallMeaningCard.topAnchor, constant: 16),
            overallMeaningHeaderLabel.leadingAnchor.constraint(equalTo: overallMeaningCard.leadingAnchor, constant: 16),
            overallMeaningHeaderLabel.trailingAnchor.constraint(equalTo: overallMeaningCard.trailingAnchor, constant: -16),
            
            overallMeaningTextLabel.topAnchor.constraint(equalTo: overallMeaningHeaderLabel.bottomAnchor, constant: 8),
            overallMeaningTextLabel.leadingAnchor.constraint(equalTo: overallMeaningCard.leadingAnchor, constant: 16),
            overallMeaningTextLabel.trailingAnchor.constraint(equalTo: overallMeaningCard.trailingAnchor, constant: -16),
            overallMeaningTextLabel.bottomAnchor.constraint(equalTo: overallMeaningCard.bottomAnchor, constant: -16)
        ])
        
        // Add symbols card
        contentView.addSubview(symbolsCard)
        symbolsCard.addSubview(symbolsHeaderLabel)
        symbolsCard.addSubview(symbolsContainer)
        
        NSLayoutConstraint.activate([
            // Symbols card
            symbolsCard.topAnchor.constraint(equalTo: overallMeaningCard.bottomAnchor, constant: 20),
            symbolsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            symbolsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Symbols content
            symbolsHeaderLabel.topAnchor.constraint(equalTo: symbolsCard.topAnchor, constant: 16),
            symbolsHeaderLabel.leadingAnchor.constraint(equalTo: symbolsCard.leadingAnchor, constant: 16),
            symbolsHeaderLabel.trailingAnchor.constraint(equalTo: symbolsCard.trailingAnchor, constant: -16),
            
            symbolsContainer.topAnchor.constraint(equalTo: symbolsHeaderLabel.bottomAnchor, constant: 12),
            symbolsContainer.leadingAnchor.constraint(equalTo: symbolsCard.leadingAnchor, constant: 16),
            symbolsContainer.trailingAnchor.constraint(equalTo: symbolsCard.trailingAnchor, constant: -16),
            symbolsContainer.bottomAnchor.constraint(equalTo: symbolsCard.bottomAnchor, constant: -16)
        ])
        
        // Add emotions card
        contentView.addSubview(emotionsCard)
        emotionsCard.addSubview(emotionsHeaderLabel)
        emotionsCard.addSubview(emotionsTextLabel)
        
        NSLayoutConstraint.activate([
            // Emotions card
            emotionsCard.topAnchor.constraint(equalTo: symbolsCard.bottomAnchor, constant: 20),
            emotionsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emotionsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Emotions content
            emotionsHeaderLabel.topAnchor.constraint(equalTo: emotionsCard.topAnchor, constant: 16),
            emotionsHeaderLabel.leadingAnchor.constraint(equalTo: emotionsCard.leadingAnchor, constant: 16),
            emotionsHeaderLabel.trailingAnchor.constraint(equalTo: emotionsCard.trailingAnchor, constant: -16),
            
            emotionsTextLabel.topAnchor.constraint(equalTo: emotionsHeaderLabel.bottomAnchor, constant: 8),
            emotionsTextLabel.leadingAnchor.constraint(equalTo: emotionsCard.leadingAnchor, constant: 16),
            emotionsTextLabel.trailingAnchor.constraint(equalTo: emotionsCard.trailingAnchor, constant: -16),
            emotionsTextLabel.bottomAnchor.constraint(equalTo: emotionsCard.bottomAnchor, constant: -16)
        ])
        
        // Add insights card
        contentView.addSubview(insightsCard)
        insightsCard.addSubview(insightsHeaderLabel)
        insightsCard.addSubview(insightsTextLabel)
        
        NSLayoutConstraint.activate([
            // Insights card
            insightsCard.topAnchor.constraint(equalTo: emotionsCard.bottomAnchor, constant: 20),
            insightsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            insightsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Insights content
            insightsHeaderLabel.topAnchor.constraint(equalTo: insightsCard.topAnchor, constant: 16),
            insightsHeaderLabel.leadingAnchor.constraint(equalTo: insightsCard.leadingAnchor, constant: 16),
            insightsHeaderLabel.trailingAnchor.constraint(equalTo: insightsCard.trailingAnchor, constant: -16),
            
            insightsTextLabel.topAnchor.constraint(equalTo: insightsHeaderLabel.bottomAnchor, constant: 8),
            insightsTextLabel.leadingAnchor.constraint(equalTo: insightsCard.leadingAnchor, constant: 16),
            insightsTextLabel.trailingAnchor.constraint(equalTo: insightsCard.trailingAnchor, constant: -16),
            insightsTextLabel.bottomAnchor.constraint(equalTo: insightsCard.bottomAnchor, constant: -16)
        ])
        
        // Add action buttons
        contentView.addSubview(actionButtonsContainer)
        actionButtonsContainer.addSubview(saveButton)
        actionButtonsContainer.addSubview(guidanceButton)
        
        NSLayoutConstraint.activate([
            // Action buttons container
            actionButtonsContainer.topAnchor.constraint(equalTo: insightsCard.bottomAnchor, constant: 32),
            actionButtonsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actionButtonsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            actionButtonsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            // Action buttons
            saveButton.topAnchor.constraint(equalTo: actionButtonsContainer.topAnchor),
            saveButton.leadingAnchor.constraint(equalTo: actionButtonsContainer.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: actionButtonsContainer.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            guidanceButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 12),
            guidanceButton.leadingAnchor.constraint(equalTo: actionButtonsContainer.leadingAnchor),
            guidanceButton.trailingAnchor.constraint(equalTo: actionButtonsContainer.trailingAnchor),
            guidanceButton.heightAnchor.constraint(equalToConstant: 50),
            guidanceButton.bottomAnchor.constraint(equalTo: actionButtonsContainer.bottomAnchor)
        ])
    }
    
    private func configureContent() {
        // Format date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy · h:mm a"
        
        dreamTitleLabel.text = dream.title
        dreamDateLabel.text = formatter.string(from: dream.date)
        
        // Generate interpretation content
        generateInterpretationContent()
        
        // Create symbol interpretations
        createSymbolInterpretations()
    }
    
    private func generateInterpretationContent() {
        // This would normally come from an AI service, but for demo purposes we'll generate content
        let moodBasedMeaning = generateMoodBasedMeaning()
        let emotionalAnalysis = generateEmotionalAnalysis()
        let personalInsights = generatePersonalInsights()
        
        overallMeaningTextLabel.text = moodBasedMeaning
        emotionsTextLabel.text = emotionalAnalysis
        insightsTextLabel.text = personalInsights
    }
    
    private func generateMoodBasedMeaning() -> String {
        switch dream.mood {
        case .excited:
            return "Your dream reflects a time of positive anticipation and energy in your life. The excitement you felt suggests you're embracing new opportunities and feeling optimistic about the future. This dream may be encouraging you to maintain this enthusiastic mindset as you pursue your goals."
        case .happy:
            return "This dream emanates contentment and joy, indicating a harmonious period in your life. The happiness you experienced suggests inner peace and satisfaction with your current circumstances. Your subconscious is celebrating positive developments and encouraging you to appreciate the good things around you."
        case .peaceful:
            return "Your peaceful dream reflects a state of inner calm and balance. This suggests you've found or are seeking tranquility in your waking life. The serene nature of this dream indicates that you're in tune with your inner self and may be processing experiences in a healthy, balanced way."
        case .neutral:
            return "This neutral dream suggests a period of stability and equilibrium in your life. Your subconscious is in a balanced state, neither highlighting particular concerns nor celebrating specific achievements. This can be an ideal time for reflection, planning, and setting intentions for future growth."
        case .confused:
            return "This dream reflects uncertainty or indecision you may be experiencing in your waking life. The confusion suggests you're processing complex situations or emotions. Your subconscious is working through conflicting thoughts or feelings, and this dream encourages you to seek clarity through reflection or discussion with trusted individuals."
        case .anxious:
            return "Your anxious dream is your mind's way of processing stress or concerns from your daily life. While these feelings can be uncomfortable, they often serve as a signal to pay attention to areas of your life that may need attention or change. Consider what specific worries the dream might be highlighting."
        case .scared:
            return "This frightening dream often represents fears or insecurities you're facing in your waking life. Rather than being purely negative, scary dreams can be your psyche's way of helping you confront and overcome challenges. The fear in your dream may be pointing to areas where you need to build confidence or seek support."
        case .sad:
            return "Your sad dream reflects a period of emotional processing or grief. This doesn't necessarily indicate current sadness, but rather shows your mind working through past experiences or current challenges. Sad dreams can be healing, allowing you to release emotions and move toward emotional resolution."
        case .angry:
            return "This angry dream suggests you may be processing frustration or injustice in your waking life. Anger in dreams often points to situations where you feel powerless or need to assert yourself. Your subconscious may be encouraging you to address conflicts or stand up for your beliefs in a constructive way."
        }
    }
    
    private func generateEmotionalAnalysis() -> String {
        let baseAnalysis = "The emotional tone of your dream provides valuable insights into your current psychological state. "
        
        switch dream.mood {
        case .excited, .happy:
            return baseAnalysis + "The positive emotions you experienced suggest you're in a healthy mental space, with good emotional regulation and optimism. This indicates readiness for new challenges and personal growth."
        case .peaceful:
            return baseAnalysis + "The peaceful emotions demonstrate emotional maturity and inner balance. You appear to be managing stress well and maintaining perspective during challenging times."
        case .neutral:
            return baseAnalysis + "The neutral emotional tone suggests emotional stability and balanced perspective. You're likely in a good place to make thoughtful decisions and approach life situations with clarity and objectivity."
        case .confused:
            return baseAnalysis + "The confusion reflects a natural response to complex life situations. Your emotional processing system is working to integrate new information or experiences. Consider this a sign to slow down and practice patience with yourself."
        case .anxious, .scared:
            return baseAnalysis + "The anxiety or fear represents your mind's protective mechanisms at work. While uncomfortable, these emotions often motivate positive change and self-protection. Consider what your intuition might be telling you."
        case .sad:
            return baseAnalysis + "The sadness indicates emotional depth and the capacity for meaningful processing of experiences. This emotional state often precedes personal growth and renewed appreciation for life's positive aspects."
        case .angry:
            return baseAnalysis + "The anger suggests strong personal values and the need for authentic self-expression. This emotion can be a catalyst for positive change when channeled constructively toward problem-solving."
        }
    }
    
    private func generatePersonalInsights() -> String {
        let insights = [
            "This dream may be reflecting your current life transitions and how you're adapting to change.",
            "Consider how the themes in this dream might relate to your relationships and social connections.",
            "The symbols and events in your dream could be highlighting areas of personal growth and self-discovery.",
            "Your subconscious might be processing recent experiences and helping you integrate new learning.",
            "This dream could be offering guidance about decisions you're currently facing in your waking life."
        ]
        
        let lucidInsight = dream.isLucid ? " The lucid nature of this dream suggests heightened self-awareness and the potential for conscious personal development." : ""
        
        return insights.randomElement()! + lucidInsight + " Take time to reflect on how these insights might apply to your current life circumstances and goals."
    }
    
    private func createSymbolInterpretations() {
        symbolsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Extract potential symbols from dream content
        let dreamText = dream.description.lowercased()
        var symbols: [(symbol: String, meaning: String)] = []
        
        // Common dream symbols and their meanings
        let symbolDict: [String: String] = [
            "water": "Emotions, purification, or life changes flowing through your experience",
            "flying": "Freedom, ambition, or desire to transcend current limitations",
            "house": "Your sense of self, personal identity, or life foundation",
            "car": "Life direction, personal control, or journey toward goals",
            "animal": "Instinctual nature, natural wisdom, or protective qualities",
            "forest": "The unknown, personal growth, or connection with nature",
            "mountain": "Challenges to overcome, personal achievement, or spiritual elevation",
            "bridge": "Transition, connection between life phases, or overcoming obstacles",
            "door": "New opportunities, choices, or access to hidden aspects of self",
            "light": "Understanding, hope, spiritual guidance, or clarity",
            "dark": "Unknown aspects, hidden fears, or potential for discovery",
            "fire": "Passion, transformation, purification, or creative energy",
            "tree": "Growth, stability, family connections, or life development",
            "ocean": "Vast emotions, unconscious mind, or life's mysteries",
            "bird": "Freedom, spirituality, messages, or higher perspective"
        ]
        
        // Check for symbols in dream text
        for (symbol, meaning) in symbolDict {
            if dreamText.contains(symbol) {
                symbols.append((symbol: symbol.capitalized, meaning: meaning))
            }
        }
        
        // If no symbols found, add some generic ones based on mood
        if symbols.isEmpty {
            switch dream.mood {
            case .excited, .happy:
                symbols.append(("Positive Energy", "Vibrant life force and optimistic outlook"))
                symbols.append(("Growth", "Personal development and expanding possibilities"))
            case .peaceful:
                symbols.append(("Harmony", "Balance between different aspects of your life"))
                symbols.append(("Sanctuary", "Safe space for rest and contemplation"))
            case .neutral:
                symbols.append(("Foundation", "Stable base for building future experiences"))
                symbols.append(("Clarity", "Clear perspective and balanced understanding"))
            case .confused:
                symbols.append(("Maze", "Complex life situations requiring careful navigation"))
                symbols.append(("Crossroads", "Important decisions and multiple life paths"))
            case .anxious, .scared:
                symbols.append(("Storm", "Turbulent emotions or challenging circumstances"))
                symbols.append(("Shadow", "Hidden fears or aspects needing attention"))
            case .sad:
                symbols.append(("Rain", "Emotional cleansing and renewal processes"))
                symbols.append(("Reflection", "Deep contemplation and inner wisdom"))
            case .angry:
                symbols.append(("Fire", "Passionate energy seeking constructive expression"))
                symbols.append(("Barrier", "Obstacles requiring assertive action"))
            }
        }
        
        // Create symbol views
        for (symbol, meaning) in symbols.prefix(3) { // Limit to 3 symbols
            let symbolView = createSymbolView(symbol: symbol, meaning: meaning)
            symbolsContainer.addArrangedSubview(symbolView)
        }
    }
    
    private func createSymbolView(symbol: String, meaning: String) -> UIView {
        let container = UIView()
        container.backgroundColor = Theme.background
        container.layer.cornerRadius = 8
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let symbolLabel = UILabel()
        symbolLabel.text = symbol
        symbolLabel.font = Theme.font(size: 14, weight: .semibold)
        symbolLabel.textColor = Theme.primary
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let meaningLabel = UILabel()
        meaningLabel.text = meaning
        meaningLabel.font = Theme.font(size: 14, weight: .regular)
        meaningLabel.textColor = Theme.secondaryText
        meaningLabel.numberOfLines = 0
        meaningLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(symbolLabel)
        container.addSubview(meaningLabel)
        
        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            symbolLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            symbolLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            
            meaningLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 4),
            meaningLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            meaningLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            meaningLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
        
        return container
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        guidanceButton.addTarget(self, action: #selector(guidanceTapped), for: .touchUpInside)
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
    
    @objc private func shareTapped() {
        let interpretationText = """
        Dream Interpretation for "\(dream.title)"
        
        \(overallMeaningTextLabel.text ?? "")
        
        Emotional Analysis:
        \(emotionsTextLabel.text ?? "")
        
        Personal Insights:
        \(insightsTextLabel.text ?? "")
        """
        
        let activityVC = UIActivityViewController(activityItems: [interpretationText], applicationActivities: nil)
        
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = shareButton
            popover.sourceRect = shareButton.bounds
        }
        
        present(activityVC, animated: true)
    }
    
    @objc private func saveTapped() {
        let alert = UIAlertController(title: "Interpretation Saved", message: "Your dream interpretation has been saved to your dream journal.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func guidanceTapped() {
        let guidanceVC = PositiveGuidanceViewController(dream: dream)
        guidanceVC.modalPresentationStyle = .fullScreen
        present(guidanceVC, animated: true)
    }
} 