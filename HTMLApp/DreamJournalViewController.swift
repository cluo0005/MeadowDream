import UIKit

class DreamJournalViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let searchController = UISearchController(searchResultsController: nil)
    private var dreamStore: DreamStore!
    private var filteredDreams: [Dream] = []
    private var isSearching: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    private let emptyStateView = EmptyStateView(
        image: UIImage(systemName: "book")!,
        title: "No dreams recorded yet",
        message: "Record your first dream to start exploring your subconscious world"
    )
    
    private let headerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerTitle: UILabel = {
        let label = UILabel()
        label.text = "Dream Journal"
        label.font = Theme.font(size: 28, weight: .bold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchButton: HeaderButton = {
        let button = HeaderButton()
        button.setTitle("🔍", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    private let addButton: HeaderButton = {
        let button = HeaderButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = Theme.font(size: 20, weight: .semibold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDreamStore()
        setupViews()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateEmptyState()
    }
    
    private func setupDreamStore() {
        dreamStore = DreamStore.shared
    }
    
    private func setupViews() {
        view.backgroundColor = Theme.background
        
        // Hide default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add custom header
        view.addSubview(headerContainer)
        headerContainer.addSubview(headerTitle)
        headerContainer.addSubview(searchButton)
        headerContainer.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            // Header container
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 60),
            
            // Header title
            headerTitle.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 20),
            headerTitle.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            
            // Buttons on the right
            addButton.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -20),
            addButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            
            searchButton.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -16),
            searchButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor)
        ])
        
        addButton.addTarget(self, action: #selector(addDreamTapped), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.backgroundColor = Theme.background
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DreamCardCell.self, forCellReuseIdentifier: "DreamCardCell")
        
        // Setup empty state view
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateView)
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    @objc private func addDreamTapped() {
        let recordVC = RecordDreamViewController()
        let navController = UINavigationController(rootViewController: recordVC)
        present(navController, animated: true)
    }
    
    @objc private func searchButtonTapped() {
        let searchVC = DreamSearchViewController()
        searchVC.modalPresentationStyle = .fullScreen
        present(searchVC, animated: true)
    }
    
    private func updateEmptyState() {
        let hasDreams = dreamStore.dreams.count > 0
        emptyStateView.isHidden = hasDreams
        tableView.isHidden = !hasDreams
    }
}

// MARK: - UITableViewDataSource
extension DreamJournalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredDreams.count : dreamStore.dreams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DreamCardCell", for: indexPath) as! DreamCardCell
        let dream = isSearching ? filteredDreams[indexPath.row] : dreamStore.dreams[indexPath.row]
        cell.configure(with: dream)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DreamJournalViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dream = isSearching ? filteredDreams[indexPath.row] : dreamStore.dreams[indexPath.row]
        let detailVC = DreamDetailViewController(dream: dream)
        detailVC.modalPresentationStyle = .fullScreen
        present(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - Dream Card Cell
class DreamCardCell: UITableViewCell {
    private let cardView: UIView = {
        let view = UIView()
        Theme.styleCard(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 12, weight: .medium)
        label.textColor = Theme.tertiaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 18, weight: .semibold)
        label.textColor = Theme.primaryText
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 14, weight: .regular)
        label.textColor = Theme.secondaryText
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tagsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardView)
        cardView.addSubview(dateLabel)
        cardView.addSubview(titleLabel)
        cardView.addSubview(previewLabel)
        cardView.addSubview(tagsContainer)
        
        NSLayoutConstraint.activate([
            // Card view with margins like HTML
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Date label - top left
            dateLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            // Title label - below date
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            // Preview label - below title
            previewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            previewLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            previewLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            // Tags container - below preview
            tagsContainer.topAnchor.constraint(equalTo: previewLabel.bottomAnchor, constant: 12),
            tagsContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            tagsContainer.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -16),
            tagsContainer.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with dream: Dream) {
        // Format date like HTML
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy · h:mm a"
        dateLabel.text = formatter.string(from: dream.date)
        
        titleLabel.text = dream.title
        previewLabel.text = dream.description
        
        // Clear existing tags
        tagsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add mood tag
        let moodTag = createMoodTag(mood: dream.mood, isLucid: dream.isLucid)
        tagsContainer.addArrangedSubview(moodTag)
        
        // Add other tags (limit to 2 more to avoid overflow)
        for (index, tag) in dream.tags.prefix(2).enumerated() {
            let tagView = createTag(text: tag)
            tagsContainer.addArrangedSubview(tagView)
        }
    }
    
    private func createMoodTag(mood: Dream.Mood, isLucid: Bool) -> UIView {
        let container = UIView()
        container.backgroundColor = getMoodColor(mood: mood)
        container.layer.cornerRadius = 8
        
        let label = UILabel()
        label.text = "\(mood.emoji) \(mood.rawValue)\(isLucid ? " ⭐" : "")"
        label.font = Theme.font(size: 12, weight: .medium)
        label.textColor = .white
        
        container.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4)
        ])
        
        return container
    }
    
    private func createTag(text: String) -> UIView {
        return Theme.createTag(text: text)
    }
    
    private func getMoodColor(mood: Dream.Mood) -> UIColor {
        switch mood {
        case .happy:
            return UIColor(red: 56/255, green: 161/255, blue: 105/255, alpha: 1) // Green
        case .excited:
            return UIColor(red: 34/255, green: 197/255, blue: 94/255, alpha: 1) // Bright Green
        case .peaceful:
            return UIColor(red: 59/255, green: 130/255, blue: 246/255, alpha: 1) // Blue
        case .neutral:
            return UIColor(red: 113/255, green: 128/255, blue: 150/255, alpha: 1) // Gray
        case .confused:
            return UIColor(red: 168/255, green: 85/255, blue: 247/255, alpha: 1) // Purple
        case .anxious:
            return UIColor(red: 245/255, green: 158/255, blue: 11/255, alpha: 1) // Orange
        case .sad:
            return UIColor(red: 59/255, green: 130/255, blue: 246/255, alpha: 0.7) // Light Blue
        case .scared:
            return UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1) // Red
        case .angry:
            return UIColor(red: 220/255, green: 38/255, blue: 38/255, alpha: 1) // Dark Red
        }
    }
}

// MARK: - Empty State View
class EmptyStateView: UIView {
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = Theme.tertiaryText
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 20, weight: .semibold)
        label.textColor = Theme.primaryText
        label.textAlignment = .center
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 16, weight: .regular)
        label.textColor = Theme.secondaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(image: UIImage, title: String, message: String) {
        super.init(frame: .zero)
        
        imageView.image = image
        titleLabel.text = title
        messageLabel.text = message
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
} 