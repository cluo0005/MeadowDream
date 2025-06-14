import UIKit

class StatisticsViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dreamStore = DreamStore.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.background
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatistics()
    }
    
    private func setupUI() {
        title = "Statistics"
        view.backgroundColor = .systemBackground
        
        // Setup scroll view
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Setup content view
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func updateStatistics() {
        // Clear existing views
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let statistics = dreamStore.statistics
        var lastView: UIView?
        
        // Overview card
        let overviewCard = createCard(title: "Overview") {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 8
            
            let totalLabel = createStatLabel(title: "Total Dreams", value: "\(statistics.totalDreams)")
            let lucidLabel = createStatLabel(title: "Lucid Dreams", value: "\(statistics.lucidDreams)")
            let avgLabel = createStatLabel(title: "Weekly Average", value: String(format: "%.1f", statistics.averageDreamsPerWeek))
            
            stackView.addArrangedSubview(totalLabel)
            stackView.addArrangedSubview(lucidLabel)
            stackView.addArrangedSubview(avgLabel)
            
            return stackView
        }
        contentView.addSubview(overviewCard)
        NSLayoutConstraint.activate([
            overviewCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            overviewCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            overviewCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        lastView = overviewCard
        
        // Mood distribution card
        let moodCard = createCard(title: "Mood Distribution") {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 8
            
            let total = statistics.moodDistribution.values.reduce(0, +)
            
            for mood in Dream.Mood.allCases {
                let count = statistics.moodDistribution[mood] ?? 0
                let percentage = total > 0 ? Double(count) / Double(total) * 100 : 0
                
                let moodView = createMoodDistributionView(
                    emoji: mood.emoji,
                    title: mood.rawValue,
                    percentage: percentage
                )
                stackView.addArrangedSubview(moodView)
            }
            
            return stackView
        }
        contentView.addSubview(moodCard)
        NSLayoutConstraint.activate([
            moodCard.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: 20),
            moodCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            moodCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        lastView = moodCard
        
        // Common tags card
        let tagsCard = createCard(title: "Common Tags") {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 12
            
            let tagsFlowLayout = createTagsFlowLayout(tags: statistics.mostCommonTags)
            stackView.addArrangedSubview(tagsFlowLayout)
            
            return stackView
        }
        contentView.addSubview(tagsCard)
        NSLayoutConstraint.activate([
            tagsCard.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: 20),
            tagsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tagsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tagsCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func createCard(title: String, contentBuilder: () -> UIView) -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemBackground
        card.layer.cornerRadius = 12
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        card.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let content = contentBuilder()
        card.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            
            content.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            content.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            content.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        
        return card
    }
    
    private func createStatLabel(title: String, value: String) -> UIView {
        let container = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .secondaryLabel
        titleLabel.font = .systemFont(ofSize: 14)
        container.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 24, weight: .bold)
        container.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func createMoodDistributionView(emoji: String, title: String, percentage: Double) -> UIView {
        let container = UIView()
        container.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        container.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)
        container.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let percentageLabel = UILabel()
        percentageLabel.text = String(format: "%.1f%%", percentage)
        percentageLabel.font = .systemFont(ofSize: 14)
        percentageLabel.textAlignment = .right
        container.addSubview(percentageLabel)
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = Float(percentage / 100)
        progressView.progressTintColor = .systemBlue
        container.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            percentageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            progressView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            progressView.trailingAnchor.constraint(equalTo: percentageLabel.leadingAnchor, constant: -8),
            progressView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        return container
    }
    
    private func createTagsFlowLayout(tags: [(tag: String, count: Int)]) -> UIView {
        let container = UIView()
        
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        let spacing: CGFloat = 8
        let maxWidth = UIScreen.main.bounds.width - 40 - 32 // Screen width - margins - card padding
        
        for (index, tag) in tags.enumerated() {
            let tagView = createTagView(text: tag.tag, count: tag.count)
            container.addSubview(tagView)
            tagView.translatesAutoresizingMaskIntoConstraints = false
            
            let tagSize = tagView.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
            
            if currentX + tagSize.width > maxWidth {
                currentX = 0
                currentY += tagSize.height + spacing
            }
            
            NSLayoutConstraint.activate([
                tagView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: currentX),
                tagView.topAnchor.constraint(equalTo: container.topAnchor, constant: currentY),
                tagView.widthAnchor.constraint(equalToConstant: tagSize.width),
                tagView.heightAnchor.constraint(equalToConstant: tagSize.height)
            ])
            
            currentX += tagSize.width + spacing
            
            if index == tags.count - 1 {
                NSLayoutConstraint.activate([
                    container.heightAnchor.constraint(equalToConstant: currentY + tagSize.height)
                ])
            }
        }
        
        return container
    }
    
    private func createTagView(text: String, count: Int) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemBlue
        container.layer.cornerRadius = 12
        
        let label = UILabel()
        label.text = "\(text) (\(count))"
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        container.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -6)
        ])
        
        return container
    }
} 