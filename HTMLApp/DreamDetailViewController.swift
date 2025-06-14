import UIKit

class DreamDetailViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let dream: Dream
    private let dreamStore = DreamStore.shared
    
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
    
    private let editButton: HeaderButton = {
        let button = HeaderButton()
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = Theme.font(size: 16, weight: .medium)
        return button
    }()
    
    private let moreButton: HeaderButton = {
        let button = HeaderButton()
        button.setTitle("•••", for: .normal)
        button.titleLabel?.font = Theme.font(size: 16, weight: .bold)
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 14, weight: .medium)
        label.textColor = Theme.tertiaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 28, weight: .bold)
        label.textColor = Theme.primaryText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moodContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let moodIcon: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moodLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 16, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lucidBadge: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.primary
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lucidLabel: UILabel = {
        let label = UILabel()
        label.text = "⭐ Lucid Dream"
        label.font = Theme.font(size: 12, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let divider1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1) // #E5E7EB
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 16, weight: .regular)
        label.textColor = Theme.primaryText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let divider2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1) // #E5E7EB
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tagsLabel: UILabel = {
        let label = UILabel()
        label.text = "Tags"
        label.font = Theme.font(size: 18, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tagsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let actionButtonsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let interpretButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Interpretation", for: .normal)
        Theme.styleButton(button, style: .primary)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Share Dream", for: .normal)
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
        
        // Hide default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Setup header
        view.addSubview(headerContainer)
        headerContainer.addSubview(backButton)
        headerContainer.addSubview(editButton)
        headerContainer.addSubview(moreButton)
        
        NSLayoutConstraint.activate([
            // Header container
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 60),
            
            // Back button
            backButton.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            
            // More button
            moreButton.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -20),
            moreButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            
            // Edit button
            editButton.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: -16),
            editButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor)
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
        
        // Add content elements
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(moodContainer)
        moodContainer.addSubview(moodIcon)
        moodContainer.addSubview(moodLabel)
        
        if dream.isLucid {
            contentView.addSubview(lucidBadge)
            lucidBadge.addSubview(lucidLabel)
        }
        
        contentView.addSubview(divider1)
        contentView.addSubview(contentLabel)
        contentView.addSubview(divider2)
        contentView.addSubview(tagsLabel)
        contentView.addSubview(tagsContainer)
        contentView.addSubview(actionButtonsContainer)
        actionButtonsContainer.addSubview(interpretButton)
        actionButtonsContainer.addSubview(shareButton)
        
        var lastElement: UIView = titleLabel
        
        NSLayoutConstraint.activate([
            // Date
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Mood container
            moodContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            moodContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            moodContainer.heightAnchor.constraint(equalToConstant: 40),
            
            // Mood icon and label
            moodIcon.leadingAnchor.constraint(equalTo: moodContainer.leadingAnchor),
            moodIcon.centerYAnchor.constraint(equalTo: moodContainer.centerYAnchor),
            
            moodLabel.leadingAnchor.constraint(equalTo: moodIcon.trailingAnchor, constant: 12),
            moodLabel.centerYAnchor.constraint(equalTo: moodContainer.centerYAnchor),
            moodLabel.trailingAnchor.constraint(equalTo: moodContainer.trailingAnchor)
        ])
        
        lastElement = moodContainer
        
        if dream.isLucid {
            NSLayoutConstraint.activate([
                // Lucid badge
                lucidBadge.topAnchor.constraint(equalTo: moodContainer.bottomAnchor, constant: 12),
                lucidBadge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                lucidBadge.heightAnchor.constraint(equalToConstant: 24),
                
                // Lucid label
                lucidLabel.topAnchor.constraint(equalTo: lucidBadge.topAnchor, constant: 4),
                lucidLabel.leadingAnchor.constraint(equalTo: lucidBadge.leadingAnchor, constant: 12),
                lucidLabel.trailingAnchor.constraint(equalTo: lucidBadge.trailingAnchor, constant: -12),
                lucidLabel.bottomAnchor.constraint(equalTo: lucidBadge.bottomAnchor, constant: -4)
            ])
            lastElement = lucidBadge
        }
        
        NSLayoutConstraint.activate([
            // Divider 1
            divider1.topAnchor.constraint(equalTo: lastElement.bottomAnchor, constant: 24),
            divider1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            divider1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            divider1.heightAnchor.constraint(equalToConstant: 1),
            
            // Content
            contentLabel.topAnchor.constraint(equalTo: divider1.bottomAnchor, constant: 24),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Divider 2
            divider2.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 24),
            divider2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            divider2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            divider2.heightAnchor.constraint(equalToConstant: 1),
            
            // Tags label
            tagsLabel.topAnchor.constraint(equalTo: divider2.bottomAnchor, constant: 24),
            tagsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tagsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Tags container
            tagsContainer.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 12),
            tagsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tagsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Action buttons container
            actionButtonsContainer.topAnchor.constraint(equalTo: tagsContainer.bottomAnchor, constant: 40),
            actionButtonsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actionButtonsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            actionButtonsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            // Action buttons
            interpretButton.topAnchor.constraint(equalTo: actionButtonsContainer.topAnchor),
            interpretButton.leadingAnchor.constraint(equalTo: actionButtonsContainer.leadingAnchor),
            interpretButton.trailingAnchor.constraint(equalTo: actionButtonsContainer.trailingAnchor),
            interpretButton.heightAnchor.constraint(equalToConstant: 50),
            
            shareButton.topAnchor.constraint(equalTo: interpretButton.bottomAnchor, constant: 12),
            shareButton.leadingAnchor.constraint(equalTo: actionButtonsContainer.leadingAnchor),
            shareButton.trailingAnchor.constraint(equalTo: actionButtonsContainer.trailingAnchor),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.bottomAnchor.constraint(equalTo: actionButtonsContainer.bottomAnchor)
        ])
    }
    
    private func configureContent() {
        // Format date
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy 'at' h:mm a"
        dateLabel.text = formatter.string(from: dream.date)
        
        titleLabel.text = dream.title
        contentLabel.text = dream.description
        
        moodIcon.text = dream.mood.emoji
        moodLabel.text = "\(dream.mood.rawValue) mood"
        
        // Create tags
        createTags()
    }
    
    private func createTags() {
        // Clear existing tags
        tagsContainer.subviews.forEach { $0.removeFromSuperview() }
        
        if dream.tags.isEmpty {
            let noTagsLabel = UILabel()
            noTagsLabel.text = "No tags added"
            noTagsLabel.font = Theme.font(size: 14, weight: .regular)
            noTagsLabel.textColor = Theme.tertiaryText
            noTagsLabel.translatesAutoresizingMaskIntoConstraints = false
            
            tagsContainer.addSubview(noTagsLabel)
            NSLayoutConstraint.activate([
                noTagsLabel.topAnchor.constraint(equalTo: tagsContainer.topAnchor),
                noTagsLabel.leadingAnchor.constraint(equalTo: tagsContainer.leadingAnchor),
                noTagsLabel.trailingAnchor.constraint(equalTo: tagsContainer.trailingAnchor),
                noTagsLabel.bottomAnchor.constraint(equalTo: tagsContainer.bottomAnchor),
                noTagsLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
            return
        }
        
        var currentRow: UIStackView?
        var currentRowWidth: CGFloat = 0
        let maxWidth = view.bounds.width - 40 // Account for margins
        
        for (index, tag) in dream.tags.enumerated() {
            let tagView = Theme.createTag(text: tag)
            
            // Calculate tag width (approximate)
            let tagWidth = tag.count * 8 + 24 // Rough calculation
            
            if currentRow == nil || currentRowWidth + CGFloat(tagWidth) + 8 > maxWidth {
                // Create new row
                currentRow = UIStackView()
                currentRow!.axis = .horizontal
                currentRow!.spacing = 8
                currentRow!.alignment = .leading
                currentRow!.translatesAutoresizingMaskIntoConstraints = false
                
                tagsContainer.addSubview(currentRow!)
                NSLayoutConstraint.activate([
                    currentRow!.leadingAnchor.constraint(equalTo: tagsContainer.leadingAnchor),
                    currentRow!.trailingAnchor.constraint(lessThanOrEqualTo: tagsContainer.trailingAnchor)
                ])
                
                if index == 0 {
                    currentRow!.topAnchor.constraint(equalTo: tagsContainer.topAnchor).isActive = true
                } else {
                    // Find the previous row
                    let previousRow = tagsContainer.subviews[tagsContainer.subviews.count - 2]
                    currentRow!.topAnchor.constraint(equalTo: previousRow.bottomAnchor, constant: 8).isActive = true
                }
                
                currentRowWidth = 0
            }
            
            currentRow!.addArrangedSubview(tagView)
            currentRowWidth += CGFloat(tagWidth) + 8
        }
        
        // Set bottom constraint for last row
        if let lastRow = tagsContainer.subviews.last {
            lastRow.bottomAnchor.constraint(equalTo: tagsContainer.bottomAnchor).isActive = true
        }
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        interpretButton.addTarget(self, action: #selector(interpretTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
    
    @objc private func editTapped() {
        let editVC = RecordDreamViewController(dream: dream)
        let navController = UINavigationController(rootViewController: editVC)
        present(navController, animated: true)
    }
    
    @objc private func moreTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete Dream", style: .destructive) { [weak self] _ in
            self?.deleteDream()
        })
        
        alert.addAction(UIAlertAction(title: "Duplicate Dream", style: .default) { [weak self] _ in
            self?.duplicateDream()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // For iPad
        if let popover = alert.popoverPresentationController {
            popover.sourceView = moreButton
            popover.sourceRect = moreButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    @objc private func interpretTapped() {
        let interpretVC = InterpretationLoadingViewController(dream: dream)
        interpretVC.modalPresentationStyle = .fullScreen
        present(interpretVC, animated: true)
    }
    
    @objc private func shareTapped() {
        let shareText = "\"\(dream.title)\"\n\n\(dream.description)\n\nMood: \(dream.mood.emoji) \(dream.mood.rawValue)"
        
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        // For iPad
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = shareButton
            popover.sourceRect = shareButton.bounds
        }
        
        present(activityVC, animated: true)
    }
    
    private func deleteDream() {
        let alert = UIAlertController(
            title: "Delete Dream",
            message: "Are you sure you want to delete this dream? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.dreamStore.deleteDream(self.dream)
            self.dismiss(animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func duplicateDream() {
        let newDream = Dream(
            id: UUID(),
            date: Date(),
            title: "\(dream.title) (Copy)",
            description: dream.description,
            mood: dream.mood,
            isLucid: dream.isLucid,
            tags: dream.tags
        )
        
        dreamStore.addDream(newDream)
        
        let alert = UIAlertController(title: "Dream Duplicated", message: "A copy of this dream has been created.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
} 