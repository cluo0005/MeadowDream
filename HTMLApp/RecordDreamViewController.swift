import UIKit

class RecordDreamViewController: UIViewController {
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
    
    private let headerTitle: UILabel = {
        let label = UILabel()
        label.text = "Record Dream"
        label.font = Theme.font(size: 18, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = Theme.font(size: 16, weight: .semibold)
        button.setTitleColor(Theme.tertiaryText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleField: UITextField = {
        let field = UITextField()
        field.placeholder = "Dream title"
        Theme.styleTextField(field)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let descriptionView: UITextView = {
        let view = UITextView()
        Theme.styleTextView(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "How did you feel?"
        label.font = Theme.font(size: 16, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emotionSelector: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var emotionButtons: [EmotionButton] = []
    private var selectedEmotion: Dream.Mood = .happy
    
    private let lucidLabel: UILabel = {
        let label = UILabel()
        label.text = "Lucid Dream"
        label.font = Theme.font(size: 16, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var lucidSwitch = UISwitch()
    private let tagsTextField = UITextField()
    
    private let dreamStore = DreamStore.shared
    private var existingDream: Dream?
    
    init(dream: Dream? = nil) {
        self.existingDream = dream
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupEmotionSelector()
        if let dream = existingDream {
            populateForm(with: dream)
        }
        
        // Add placeholder text to description view
        setupDescriptionPlaceholder()
    }
    
    private func setupViews() {
        view.backgroundColor = Theme.background
        
        // Hide default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Setup header
        view.addSubview(headerContainer)
        headerContainer.addSubview(backButton)
        headerContainer.addSubview(headerTitle)
        headerContainer.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            // Header container
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 60),
            
            // Back button
            backButton.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            
            // Header title
            headerTitle.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            headerTitle.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            
            // Save button
            saveButton.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -20),
            saveButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor)
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
        
        // Add input fields
        contentView.addSubview(titleField)
        contentView.addSubview(descriptionView)
        contentView.addSubview(sectionTitleLabel)
        contentView.addSubview(emotionSelector)
        
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleField.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 16),
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionView.heightAnchor.constraint(equalToConstant: 200),
            
            sectionTitleLabel.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 20),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            emotionSelector.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 12),
            emotionSelector.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emotionSelector.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emotionSelector.heightAnchor.constraint(equalToConstant: 84) // 60px icon + 8px gap + 16px label
        ])
        
        // Lucid dream switch
        let lucidStackView = UIStackView()
        lucidStackView.axis = .horizontal
        lucidStackView.spacing = 12
        lucidStackView.alignment = .center
        contentView.addSubview(lucidStackView)
        lucidStackView.translatesAutoresizingMaskIntoConstraints = false
        
        lucidStackView.addArrangedSubview(lucidLabel)
        lucidStackView.addArrangedSubview(UIView()) // Spacer
        lucidStackView.addArrangedSubview(lucidSwitch)
        
        NSLayoutConstraint.activate([
            lucidStackView.topAnchor.constraint(equalTo: emotionSelector.bottomAnchor, constant: 20),
            lucidStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lucidStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            lucidStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Tags input field
        tagsTextField.placeholder = "Add tags (comma separated)"
        Theme.styleTextField(tagsTextField)
        contentView.addSubview(tagsTextField)
        tagsTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagsTextField.topAnchor.constraint(equalTo: lucidStackView.bottomAnchor, constant: 20),
            tagsTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tagsTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tagsTextField.heightAnchor.constraint(equalToConstant: 50),
            tagsTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveDream), for: .touchUpInside)
        
        // Enable/disable save button based on content
        titleField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        descriptionView.delegate = self
        
        // Update button title
        saveButton.setTitle(existingDream == nil ? "Save" : "Update", for: .normal)
        
        // Configure lucid switch
        lucidSwitch.onTintColor = Theme.primary
    }
    
    private func setupEmotionSelector() {
        for mood in Dream.Mood.allCases {
            let button = EmotionButton(mood: mood)
            button.addTarget(self, action: #selector(emotionButtonTapped(_:)), for: .touchUpInside)
            emotionButtons.append(button)
            emotionSelector.addArrangedSubview(button)
        }
        
        // Select first emotion by default
        if let firstButton = emotionButtons.first {
            selectEmotion(firstButton)
        }
    }
    
    private func setupDescriptionPlaceholder() {
        if descriptionView.text.isEmpty {
            descriptionView.text = "Describe your dream..."
            descriptionView.textColor = Theme.tertiaryText
        }
    }
    
    @objc private func emotionButtonTapped(_ sender: EmotionButton) {
        selectEmotion(sender)
    }
    
    private func selectEmotion(_ button: EmotionButton) {
        // Deselect all buttons
        emotionButtons.forEach { $0.isSelected = false }
        
        // Select the tapped button
        button.isSelected = true
        selectedEmotion = button.mood
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func textFieldChanged() {
        updateSaveButtonState()
    }
    
    private func updateSaveButtonState() {
        let hasContent = !(titleField.text?.isEmpty ?? true) && 
                        !descriptionView.text.isEmpty && 
                        descriptionView.text != "Describe your dream..."
        
        saveButton.setTitleColor(hasContent ? Theme.primary : Theme.tertiaryText, for: .normal)
        saveButton.isEnabled = hasContent
    }
    
    private func populateForm(with dream: Dream) {
        titleField.text = dream.title
        descriptionView.text = dream.description
        descriptionView.textColor = Theme.primaryText
        
        if let index = Dream.Mood.allCases.firstIndex(of: dream.mood) {
            selectEmotion(emotionButtons[index])
        }
        lucidSwitch.isOn = dream.isLucid
        tagsTextField.text = dream.tags.joined(separator: ", ")
        
        updateSaveButtonState()
    }
    
    @objc private func saveDream() {
        guard let title = titleField.text, !title.isEmpty,
              let description = descriptionView.text, !description.isEmpty, description != "Describe your dream..." else {
            showAlert(message: "Please enter title and description")
            return
        }
        
        let mood = selectedEmotion
        let isLucid = lucidSwitch.isOn
        let tags = tagsTextField.text?.components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty } ?? []
        
        if var dream = existingDream {
            dream.title = title
            dream.description = description
            dream.mood = mood
            dream.isLucid = isLucid
            dream.tags = tags
            dreamStore.updateDream(dream)
            showAlert(message: "Dream updated") { [weak self] _ in
                self?.dismiss(animated: true)
            }
        } else {
            let dream = Dream(
                title: title,
                description: description,
                mood: mood,
                isLucid: isLucid,
                tags: tags
            )
            dreamStore.addDream(dream)
            showAlert(message: "Dream saved") { [weak self] _ in
                self?.dismiss(animated: true)
            }
        }
    }
    
    private func showAlert(message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension RecordDreamViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Describe your dream..." {
            textView.text = ""
            textView.textColor = Theme.primaryText
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setupDescriptionPlaceholder()
        }
        updateSaveButtonState()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButtonState()
    }
}

// MARK: - Emotion Button
class EmotionButton: UIButton {
    let mood: Dream.Mood
    
    private let iconView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.inputBackground
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.font(size: 14, weight: .medium)
        label.textColor = Theme.tertiaryText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    init(mood: Dream.Mood) {
        self.mood = mood
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(iconView)
        iconView.addSubview(emojiLabel)
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            // Icon view - 60x60 like HTML
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 60),
            iconView.heightAnchor.constraint(equalToConstant: 60),
            
            // Emoji label - centered in icon
            emojiLabel.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            
            // Name label - below icon with 8px gap like HTML
            nameLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        emojiLabel.text = mood.emoji
        nameLabel.text = mood.rawValue
        
        updateAppearance()
    }
    
    private func updateAppearance() {
        if isSelected {
            iconView.backgroundColor = Theme.primary
            emojiLabel.textColor = .white
            nameLabel.textColor = Theme.primary
            nameLabel.font = Theme.font(size: 14, weight: .medium)
        } else {
            iconView.backgroundColor = Theme.inputBackground
            emojiLabel.textColor = Theme.tertiaryText
            nameLabel.textColor = Theme.tertiaryText
            nameLabel.font = Theme.font(size: 14, weight: .regular)
        }
    }
} 