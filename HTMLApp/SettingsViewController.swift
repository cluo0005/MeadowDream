import UIKit

class SettingsViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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
        label.text = "Settings"
        label.font = Theme.font(size: 18, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileSection: UIView = {
        let view = UIView()
        Theme.styleCard(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.primary
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.text = "JD"
        label.font = Theme.font(size: 24, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "John Doe"
        label.font = Theme.font(size: 18, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "john.doe@example.com"
        label.font = Theme.font(size: 14, weight: .regular)
        label.textColor = Theme.secondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = Theme.tertiaryText
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupActions()
    }
    
    private func setupViews() {
        view.backgroundColor = Theme.background
        
        // Hide default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Setup header
        view.addSubview(headerContainer)
        headerContainer.addSubview(backButton)
        headerContainer.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 60),
            
            backButton.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor)
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
        
        // Setup profile section
        contentView.addSubview(profileSection)
        profileSection.addSubview(avatarView)
        avatarView.addSubview(avatarLabel)
        profileSection.addSubview(nameLabel)
        profileSection.addSubview(emailLabel)
        profileSection.addSubview(profileArrow)
        
        NSLayoutConstraint.activate([
            // Profile section
            profileSection.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profileSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            profileSection.heightAnchor.constraint(equalToConstant: 92),
            
            // Avatar
            avatarView.leadingAnchor.constraint(equalTo: profileSection.leadingAnchor, constant: 20),
            avatarView.centerYAnchor.constraint(equalTo: profileSection.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 60),
            avatarView.heightAnchor.constraint(equalToConstant: 60),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            // Profile info
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: avatarView.topAnchor, constant: 8),
            
            emailLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            // Arrow
            profileArrow.trailingAnchor.constraint(equalTo: profileSection.trailingAnchor, constant: -20),
            profileArrow.centerYAnchor.constraint(equalTo: profileSection.centerYAnchor),
            profileArrow.widthAnchor.constraint(equalToConstant: 12),
            profileArrow.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        // Add settings sections
        var lastView: UIView = profileSection
        
        // Preferences section
        let preferencesSection = createSettingsSection(
            title: "Preferences",
            items: [
                SettingItem(
                    icon: "moon.fill",
                    iconColor: Theme.primary,
                    title: "Dark Mode",
                    subtitle: "Use dark theme",
                    accessory: .toggle(isOn: true)
                ),
                SettingItem(
                    icon: "textformat",
                    iconColor: UIColor(red: 52/255, green: 211/255, blue: 153/255, alpha: 1),
                    title: "Language",
                    subtitle: "App language",
                    accessory: .value("English")
                ),
                SettingItem(
                    icon: "bell.fill",
                    iconColor: UIColor(red: 251/255, green: 191/255, blue: 36/255, alpha: 1),
                    title: "Notifications",
                    subtitle: "Manage notifications",
                    accessory: .arrow
                )
            ]
        )
        
        contentView.addSubview(preferencesSection)
        NSLayoutConstraint.activate([
            preferencesSection.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 32),
            preferencesSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            preferencesSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        lastView = preferencesSection
        
        // Dream Recording section
        let dreamRecordingSection = createSettingsSection(
            title: "Dream Recording",
            items: [
                SettingItem(
                    icon: "mic.fill",
                    iconColor: UIColor(red: 167/255, green: 139/255, blue: 250/255, alpha: 1),
                    title: "Voice Recording",
                    subtitle: "Enable voice input",
                    accessory: .toggle(isOn: true)
                ),
                SettingItem(
                    icon: "clock.fill",
                    iconColor: UIColor(red: 248/255, green: 113/255, blue: 113/255, alpha: 1),
                    title: "Daily Reminder",
                    subtitle: "Remind to record dreams",
                    accessory: .value("9:00 AM")
                ),
                SettingItem(
                    icon: "square.and.arrow.down.fill",
                    iconColor: UIColor(red: 99/255, green: 102/255, blue: 241/255, alpha: 1),
                    title: "Auto Save",
                    subtitle: "Automatically save drafts",
                    accessory: .toggle(isOn: true)
                )
            ]
        )
        
        contentView.addSubview(dreamRecordingSection)
        NSLayoutConstraint.activate([
            dreamRecordingSection.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 32),
            dreamRecordingSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dreamRecordingSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        lastView = dreamRecordingSection
        
        // Support section
        let supportSection = createSettingsSection(
            title: "Support",
            items: [
                SettingItem(
                    icon: "questionmark.circle.fill",
                    iconColor: UIColor(red: 34/255, green: 197/255, blue: 94/255, alpha: 1),
                    title: "Help Center",
                    subtitle: "Get help and support",
                    accessory: .arrow
                ),
                SettingItem(
                    icon: "envelope.fill",
                    iconColor: UIColor(red: 59/255, green: 130/255, blue: 246/255, alpha: 1),
                    title: "Contact Us",
                    subtitle: "Send us feedback",
                    accessory: .arrow
                ),
                SettingItem(
                    icon: "star.fill",
                    iconColor: UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1),
                    title: "Rate App",
                    subtitle: "Rate on App Store",
                    accessory: .arrow
                )
            ]
        )
        
        contentView.addSubview(supportSection)
        NSLayoutConstraint.activate([
            supportSection.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 32),
            supportSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            supportSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            supportSection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        // Add tap gesture to profile section
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        profileSection.addGestureRecognizer(profileTap)
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
    
    @objc private func profileTapped() {
        // TODO: Navigate to account settings
        showComingSoonAlert()
    }
    
    private func showComingSoonAlert() {
        let alert = UIAlertController(title: "Coming Soon", message: "This feature will be available in a future update.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Settings Models
struct SettingItem {
    let icon: String
    let iconColor: UIColor
    let title: String
    let subtitle: String
    let accessory: SettingAccessory
}

enum SettingAccessory {
    case arrow
    case toggle(isOn: Bool)
    case value(String)
}

// MARK: - Settings Creation Helper
extension SettingsViewController {
    private func createSettingsSection(title: String, items: [SettingItem]) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        // Section title
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Theme.font(size: 16, weight: .semibold)
        titleLabel.textColor = Theme.primaryText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Settings group
        let groupView = UIView()
        Theme.styleCard(groupView)
        groupView.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        container.addSubview(groupView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            groupView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            groupView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            groupView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            groupView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        // Add setting items
        var lastItemView: UIView?
        
        for (index, item) in items.enumerated() {
            let itemView = createSettingItemView(item: item, isLast: index == items.count - 1)
            groupView.addSubview(itemView)
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: groupView.leadingAnchor),
                itemView.trailingAnchor.constraint(equalTo: groupView.trailingAnchor),
                itemView.heightAnchor.constraint(equalToConstant: 60)
            ])
            
            if let lastView = lastItemView {
                itemView.topAnchor.constraint(equalTo: lastView.bottomAnchor).isActive = true
            } else {
                itemView.topAnchor.constraint(equalTo: groupView.topAnchor).isActive = true
            }
            
            if index == items.count - 1 {
                itemView.bottomAnchor.constraint(equalTo: groupView.bottomAnchor).isActive = true
            }
            
            lastItemView = itemView
        }
        
        return container
    }
    
    private func createSettingItemView(item: SettingItem, isLast: Bool) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        // Icon container
        let iconContainer = UIView()
        iconContainer.backgroundColor = item.iconColor.withAlphaComponent(0.1)
        iconContainer.layer.cornerRadius = 8
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: item.icon)
        iconView.tintColor = item.iconColor
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        iconContainer.addSubview(iconView)
        
        // Title and subtitle
        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = Theme.font(size: 16, weight: .medium)
        titleLabel.textColor = Theme.primaryText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = item.subtitle
        subtitleLabel.font = Theme.font(size: 14, weight: .regular)
        subtitleLabel.textColor = Theme.secondaryText
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Accessory view
        let accessoryView = createAccessoryView(for: item.accessory)
        
        // Border (if not last)
        let borderView = UIView()
        borderView.backgroundColor = UIColor(red: 226/255, green: 232/255, blue: 240/255, alpha: 1) // #E2E8F0
        borderView.isHidden = isLast
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(iconContainer)
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        container.addSubview(accessoryView)
        container.addSubview(borderView)
        
        NSLayoutConstraint.activate([
            // Icon container
            iconContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            iconContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 32),
            iconContainer.heightAnchor.constraint(equalToConstant: 32),
            
            // Icon view
            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 16),
            iconView.heightAnchor.constraint(equalToConstant: 16),
            
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: container.centerYAnchor, constant: -12),
            
            // Subtitle
            subtitleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            
            // Accessory
            accessoryView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            accessoryView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            // Border
            borderView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        return container
    }
    
    private func createAccessoryView(for accessory: SettingAccessory) -> UIView {
        switch accessory {
        case .arrow:
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "chevron.right")
            imageView.tintColor = Theme.tertiaryText
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 12),
                imageView.heightAnchor.constraint(equalToConstant: 12)
            ])
            return imageView
            
        case .toggle(let isOn):
            let toggle = UISwitch()
            toggle.isOn = isOn
            toggle.onTintColor = Theme.primary
            toggle.translatesAutoresizingMaskIntoConstraints = false
            return toggle
            
        case .value(let text):
            let container = UIView()
            let label = UILabel()
            label.text = text
            label.font = Theme.font(size: 14, weight: .medium)
            label.textColor = Theme.tertiaryText
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let arrow = UIImageView()
            arrow.image = UIImage(systemName: "chevron.right")
            arrow.tintColor = Theme.tertiaryText
            arrow.contentMode = .scaleAspectFit
            arrow.translatesAutoresizingMaskIntoConstraints = false
            
            container.addSubview(label)
            container.addSubview(arrow)
            container.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                
                arrow.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
                arrow.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                arrow.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                arrow.widthAnchor.constraint(equalToConstant: 12),
                arrow.heightAnchor.constraint(equalToConstant: 12),
                
                container.topAnchor.constraint(equalTo: label.topAnchor),
                container.bottomAnchor.constraint(equalTo: label.bottomAnchor)
            ])
            
            return container
        }
    }
} 