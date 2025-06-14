import UIKit

class DreamSearchViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let dreamStore = DreamStore.shared
    private var searchResults: [Dream] = []
    private var selectedFilter: FilterType = .all
    
    enum FilterType: String, CaseIterable {
        case all = "All"
        case thisWeek = "This Week"
        case thisMonth = "This Month"
        case lucidDreams = "Lucid Dreams"
        case nightmares = "Nightmares"
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
        label.text = "Search Dreams"
        label.font = Theme.font(size: 18, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 237/255, green: 242/255, blue: 247/255, alpha: 1) // #EDF2F7
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = UIColor(red: 113/255, green: 128/255, blue: 150/255, alpha: 1) // #718096
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search your dreams..."
        textField.font = Theme.font(size: 16, weight: .regular)
        textField.textColor = Theme.primaryText
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let filterScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView(
            image: UIImage(systemName: "magnifyingglass")!,
            title: "No dreams found",
            message: "Try adjusting your search terms or filters"
        )
        view.isHidden = true
        return view
    }()
    
    private let noSearchView: EmptyStateView = {
        let view = EmptyStateView(
            image: UIImage(systemName: "text.magnifyingglass")!,
            title: "Search your dreams",
            message: "Enter keywords, symbols, or feelings to find specific dreams"
        )
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
        setupFilterChips()
        setupSearchFunctionality()
        updateResultsDisplay()
    }
    
    private func setupViews() {
        view.backgroundColor = Theme.background
        
        // Hide default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add header
        view.addSubview(headerContainer)
        headerContainer.addSubview(backButton)
        headerContainer.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            // Header container
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 60),
            
            // Back button
            backButton.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor)
        ])
        
        // Add search container
        view.addSubview(searchContainer)
        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            // Search container
            searchContainer.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 20),
            searchContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchContainer.heightAnchor.constraint(equalToConstant: 50),
            
            // Search icon
            searchIcon.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 16),
            searchIcon.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 18),
            searchIcon.heightAnchor.constraint(equalToConstant: 18),
            
            // Search text field
            searchTextField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 12),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -16),
            searchTextField.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor)
        ])
        
        // Add filter scroll view
        view.addSubview(filterScrollView)
        filterScrollView.addSubview(filterStackView)
        
        NSLayoutConstraint.activate([
            // Filter scroll view
            filterScrollView.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 16),
            filterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterScrollView.heightAnchor.constraint(equalToConstant: 40),
            
            // Filter stack view
            filterStackView.topAnchor.constraint(equalTo: filterScrollView.topAnchor),
            filterStackView.leadingAnchor.constraint(equalTo: filterScrollView.leadingAnchor, constant: 20),
            filterStackView.trailingAnchor.constraint(equalTo: filterScrollView.trailingAnchor, constant: -20),
            filterStackView.bottomAnchor.constraint(equalTo: filterScrollView.bottomAnchor),
            filterStackView.heightAnchor.constraint(equalTo: filterScrollView.heightAnchor)
        ])
        
        // Add empty state views
        view.addSubview(emptyStateView)
        view.addSubview(noSearchView)
        
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        noSearchView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Empty state view
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // No search view
            noSearchView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noSearchView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noSearchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            noSearchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: filterScrollView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DreamCardCell.self, forCellReuseIdentifier: "DreamCardCell")
        tableView.keyboardDismissMode = .onDrag
    }
    
    private func setupFilterChips() {
        for filterType in FilterType.allCases {
            let chip = createFilterChip(for: filterType)
            filterStackView.addArrangedSubview(chip)
        }
    }
    
    private func createFilterChip(for filterType: FilterType) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(filterType.rawValue, for: .normal)
        button.titleLabel?.font = Theme.font(size: 14, weight: .medium)
        button.layer.cornerRadius = 16
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        updateFilterChipAppearance(button: button, isSelected: filterType == selectedFilter)
        
        button.addTarget(self, action: #selector(filterChipTapped(_:)), for: .touchUpInside)
        button.tag = FilterType.allCases.firstIndex(of: filterType) ?? 0
        
        return button
    }
    
    private func updateFilterChipAppearance(button: UIButton, isSelected: Bool) {
        if isSelected {
            button.backgroundColor = Theme.primary
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = UIColor(red: 237/255, green: 242/255, blue: 247/255, alpha: 1) // #EDF2F7
            button.setTitleColor(UIColor(red: 74/255, green: 85/255, blue: 104/255, alpha: 1), for: .normal) // #4A5568
        }
    }
    
    private func setupSearchFunctionality() {
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
    
    @objc private func filterChipTapped(_ sender: UIButton) {
        let newFilter = FilterType.allCases[sender.tag]
        
        // Update selection
        selectedFilter = newFilter
        
        // Update all chip appearances
        for (index, chip) in filterStackView.arrangedSubviews.enumerated() {
            if let button = chip as? UIButton {
                let filterType = FilterType.allCases[index]
                updateFilterChipAppearance(button: button, isSelected: filterType == selectedFilter)
            }
        }
        
        performSearch()
    }
    
    @objc private func searchTextChanged() {
        performSearch()
    }
    
    private func performSearch() {
        let searchText = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // Start with all dreams or search results
        var results = searchText.isEmpty ? dreamStore.dreams : dreamStore.searchDreams(query: searchText)
        
        // Apply filter
        results = applyFilter(to: results)
        
        searchResults = results
        updateResultsDisplay()
    }
    
    private func applyFilter(to dreams: [Dream]) -> [Dream] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedFilter {
        case .all:
            return dreams
        case .thisWeek:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return dreams.filter { $0.date >= weekAgo }
        case .thisMonth:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return dreams.filter { $0.date >= monthAgo }
        case .lucidDreams:
            return dreams.filter { $0.isLucid }
        case .nightmares:
            return dreams.filter { $0.mood == .scared || $0.mood == .anxious }
        }
    }
    
    private func updateResultsDisplay() {
        let searchText = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let hasSearchText = !searchText.isEmpty
        let hasResults = !searchResults.isEmpty
        
        tableView.isHidden = !hasSearchText || !hasResults
        emptyStateView.isHidden = !hasSearchText || hasResults
        noSearchView.isHidden = hasSearchText
        
        if hasSearchText && hasResults {
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension DreamSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DreamCardCell", for: indexPath) as! DreamCardCell
        let dream = searchResults[indexPath.row]
        cell.configure(with: dream)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DreamSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dream = searchResults[indexPath.row]
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

