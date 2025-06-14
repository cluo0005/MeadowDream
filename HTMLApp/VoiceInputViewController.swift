import UIKit
import AVFoundation

class VoiceInputViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var audioRecorder: AVAudioRecorder?
    private var isRecording = false
    private var recordedText: String = ""
    private var selectedEmotion: Dream.Mood = .happy
    private var dreamTags: [String] = []
    
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
        label.text = "Record Dream (Voice)"
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
        button.backgroundColor = UIColor(red: 203/255, green: 213/255, blue: 224/255, alpha: 1) // #CBD5E0
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Dream title"
        Theme.styleTextField(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let voiceInputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 237/255, green: 242/255, blue: 247/255, alpha: 1) // #EDF2F7
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let voiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = Theme.primary
        button.layer.cornerRadius = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let voiceIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mic.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let voiceStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to Start Recording"
        label.font = Theme.font(size: 16, weight: .semibold)
        label.textColor = Theme.primaryText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let voiceHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Clearly describe your dream. Your voice will be automatically transcribed."
        label.font = Theme.font(size: 14, weight: .regular)
        label.textColor = Theme.secondaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let waveformView: WaveformView = {
        let view = WaveformView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emotionSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Dream Emotion"
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
    
    private var emotionButtons: [VoiceEmotionButton] = []
    
    private let tagsSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Tags"
        label.font = Theme.font(size: 16, weight: .semibold)
        label.textColor = Theme.primaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tagsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tagsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let addTagButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("  + Add Tag", for: .normal)
        button.setTitleColor(Theme.secondaryText, for: .normal)
        button.titleLabel?.font = Theme.font(size: 14, weight: .medium)
        button.backgroundColor = UIColor(red: 237/255, green: 242/255, blue: 247/255, alpha: 1) // #EDF2F7
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupEmotionSelector()
        setupActions()
        setupAudioRecorder()
        updateTagsDisplay()
    }
    
    private func setupViews() {
        view.backgroundColor = Theme.background
        
        // Hide default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Setup header
        view.addSubview(headerContainer)
        headerContainer.addSubview(backButton)
        headerContainer.addSubview(titleLabel)
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
            
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            
            // Save button
            saveButton.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -20),
            saveButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 60),
            saveButton.heightAnchor.constraint(equalToConstant: 36)
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
        
        // Add title field
        contentView.addSubview(titleTextField)
        
        // Add voice input container
        contentView.addSubview(voiceInputContainer)
        voiceInputContainer.addSubview(voiceButton)
        voiceButton.addSubview(voiceIcon)
        voiceInputContainer.addSubview(voiceStatusLabel)
        voiceInputContainer.addSubview(voiceHintLabel)
        voiceInputContainer.addSubview(waveformView)
        
        // Add emotion section
        contentView.addSubview(emotionSectionLabel)
        contentView.addSubview(emotionSelector)
        
        // Add tags section
        contentView.addSubview(tagsSectionLabel)
        contentView.addSubview(tagsContainer)
        tagsContainer.addSubview(tagsStackView)
        tagsContainer.addSubview(addTagButton)
        
        NSLayoutConstraint.activate([
            // Title field
            titleTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Voice input container
            voiceInputContainer.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            voiceInputContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            voiceInputContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            voiceInputContainer.heightAnchor.constraint(equalToConstant: 280),
            
            // Voice button
            voiceButton.centerXAnchor.constraint(equalTo: voiceInputContainer.centerXAnchor),
            voiceButton.topAnchor.constraint(equalTo: voiceInputContainer.topAnchor, constant: 40),
            voiceButton.widthAnchor.constraint(equalToConstant: 80),
            voiceButton.heightAnchor.constraint(equalToConstant: 80),
            
            // Voice icon
            voiceIcon.centerXAnchor.constraint(equalTo: voiceButton.centerXAnchor),
            voiceIcon.centerYAnchor.constraint(equalTo: voiceButton.centerYAnchor),
            voiceIcon.widthAnchor.constraint(equalToConstant: 30),
            voiceIcon.heightAnchor.constraint(equalToConstant: 30),
            
            // Voice status label
            voiceStatusLabel.topAnchor.constraint(equalTo: voiceButton.bottomAnchor, constant: 16),
            voiceStatusLabel.leadingAnchor.constraint(equalTo: voiceInputContainer.leadingAnchor, constant: 20),
            voiceStatusLabel.trailingAnchor.constraint(equalTo: voiceInputContainer.trailingAnchor, constant: -20),
            
            // Voice hint label
            voiceHintLabel.topAnchor.constraint(equalTo: voiceStatusLabel.bottomAnchor, constant: 8),
            voiceHintLabel.leadingAnchor.constraint(equalTo: voiceInputContainer.leadingAnchor, constant: 20),
            voiceHintLabel.trailingAnchor.constraint(equalTo: voiceInputContainer.trailingAnchor, constant: -20),
            
            // Waveform view
            waveformView.topAnchor.constraint(equalTo: voiceHintLabel.bottomAnchor, constant: 16),
            waveformView.centerXAnchor.constraint(equalTo: voiceInputContainer.centerXAnchor),
            waveformView.widthAnchor.constraint(equalToConstant: 200),
            waveformView.heightAnchor.constraint(equalToConstant: 40),
            
            // Emotion section
            emotionSectionLabel.topAnchor.constraint(equalTo: voiceInputContainer.bottomAnchor, constant: 20),
            emotionSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emotionSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            emotionSelector.topAnchor.constraint(equalTo: emotionSectionLabel.bottomAnchor, constant: 12),
            emotionSelector.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emotionSelector.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emotionSelector.heightAnchor.constraint(equalToConstant: 80),
            
            // Tags section
            tagsSectionLabel.topAnchor.constraint(equalTo: emotionSelector.bottomAnchor, constant: 20),
            tagsSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tagsSectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            tagsContainer.topAnchor.constraint(equalTo: tagsSectionLabel.bottomAnchor, constant: 12),
            tagsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tagsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tagsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            // Tags stack view
            tagsStackView.topAnchor.constraint(equalTo: tagsContainer.topAnchor),
            tagsStackView.leadingAnchor.constraint(equalTo: tagsContainer.leadingAnchor),
            tagsStackView.trailingAnchor.constraint(equalTo: tagsContainer.trailingAnchor),
            
            // Add tag button
            addTagButton.topAnchor.constraint(equalTo: tagsStackView.bottomAnchor, constant: 12),
            addTagButton.leadingAnchor.constraint(equalTo: tagsContainer.leadingAnchor),
            addTagButton.bottomAnchor.constraint(equalTo: tagsContainer.bottomAnchor)
        ])
    }
    
    private func setupEmotionSelector() {
        let emotions: [Dream.Mood] = [.happy, .peaceful, .confused, .anxious]
        
        for emotion in emotions {
            let button = VoiceEmotionButton(mood: emotion)
            button.addTarget(self, action: #selector(emotionSelected(_:)), for: .touchUpInside)
            emotionButtons.append(button)
            emotionSelector.addArrangedSubview(button)
            
            if emotion == selectedEmotion {
                button.isSelected = true
            }
        }
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        voiceButton.addTarget(self, action: #selector(voiceButtonTapped), for: .touchUpInside)
        addTagButton.addTarget(self, action: #selector(addTagTapped), for: .touchUpInside)
        titleTextField.addTarget(self, action: #selector(titleChanged), for: .editingChanged)
    }
    
    private func setupAudioRecorder() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            audioSession.requestRecordPermission { [weak self] allowed in
                if !allowed {
                    DispatchQueue.main.async {
                        self?.showPermissionAlert()
                    }
                }
            }
        } catch {
            print("Failed to set up audio session")
        }
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(message: "Please enter a dream title")
            return
        }
        
        guard !recordedText.isEmpty else {
            showAlert(message: "Please record your dream description")
            return
        }
        
        let dream = Dream(
            title: title,
            description: recordedText,
            mood: selectedEmotion,
            isLucid: false,
            tags: dreamTags
        )
        
        DreamStore.shared.addDream(dream)
        
        showAlert(message: "Dream saved successfully!") { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }
    
    @objc private func voiceButtonTapped() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    @objc private func emotionSelected(_ sender: VoiceEmotionButton) {
        emotionButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        selectedEmotion = sender.mood
    }
    
    @objc private func addTagTapped() {
        showAddTagAlert()
    }
    
    @objc private func titleChanged() {
        updateSaveButton()
    }
    
    private func startRecording() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsPath.appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            
            isRecording = true
            updateRecordingUI()
            waveformView.startAnimation()
            
        } catch {
            showAlert(message: "Failed to start recording")
        }
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        
        isRecording = false
        updateRecordingUI()
        waveformView.stopAnimation()
        
        // Simulate voice-to-text processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.processRecording()
        }
    }
    
    private func processRecording() {
        // In a real app, this would use speech-to-text API
        // For demo, we'll use placeholder text
        recordedText = "I dreamt I was flying over a beautiful city at night. The city lights were twinkling like stars below me, and I felt an incredible sense of freedom and peace. I soared through fluffy clouds, feeling completely weightless and serene."
        
        if titleTextField.text?.isEmpty ?? true {
            titleTextField.text = "Night Flight Over City"
        }
        
        voiceStatusLabel.text = "Recording Complete"
        voiceHintLabel.text = "Tap the microphone to record again if needed."
        
        updateSaveButton()
    }
    
    private func updateRecordingUI() {
        if isRecording {
            voiceButton.backgroundColor = UIColor(red: 229/255, green: 62/255, blue: 62/255, alpha: 1) // Red
            voiceIcon.image = UIImage(systemName: "stop.fill")
            voiceStatusLabel.text = "Recording..."
            voiceHintLabel.text = "Tap the stop button to end recording."
            waveformView.isHidden = false
        } else {
            voiceButton.backgroundColor = Theme.primary
            voiceIcon.image = UIImage(systemName: "mic.fill")
            voiceStatusLabel.text = "Processing Recording..."
            voiceHintLabel.text = "Please wait while we process your recording."
            waveformView.isHidden = true
        }
    }
    
    private func updateSaveButton() {
        let hasTitle = !(titleTextField.text?.isEmpty ?? true)
        let hasRecording = !recordedText.isEmpty
        
        if hasTitle && hasRecording {
            saveButton.isEnabled = true
            saveButton.backgroundColor = Theme.primary
            saveButton.setTitleColor(.white, for: .normal)
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor(red: 203/255, green: 213/255, blue: 224/255, alpha: 1)
            saveButton.setTitleColor(Theme.tertiaryText, for: .normal)
        }
    }
    
    private func updateTagsDisplay() {
        // Clear existing tags
        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for tag in dreamTags {
            let tagView = createTagView(text: tag)
            tagsStackView.addArrangedSubview(tagView)
        }
    }
    
    private func createTagView(text: String) -> UIView {
        let container = UIView()
        container.backgroundColor = Theme.tagBackground
        container.layer.cornerRadius = 8
        
        let label = UILabel()
        label.text = text
        label.font = Theme.font(size: 14, weight: .medium)
        label.textColor = Theme.tagText
        
        let removeButton = UIButton(type: .system)
        removeButton.setTitle("×", for: .normal)
        removeButton.setTitleColor(Theme.tagText, for: .normal)
        removeButton.titleLabel?.font = Theme.font(size: 16, weight: .bold)
        removeButton.addTarget(self, action: #selector(removeTag(_:)), for: .touchUpInside)
        
        container.addSubview(label)
        container.addSubview(removeButton)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            
            removeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            removeButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8),
            removeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            removeButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            removeButton.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        // Store tag text for removal
        removeButton.accessibilityIdentifier = text
        
        return container
    }
    
    @objc private func removeTag(_ sender: UIButton) {
        guard let tagText = sender.accessibilityIdentifier,
              let index = dreamTags.firstIndex(of: tagText) else { return }
        
        dreamTags.remove(at: index)
        updateTagsDisplay()
    }
    
    private func showAddTagAlert() {
        let alert = UIAlertController(title: "Add Tag", message: "Enter a tag for your dream", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Tag name"
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text,
                  !text.isEmpty,
                  !(self?.dreamTags.contains(text) ?? true) else { return }
            
            self?.dreamTags.append(text)
            self?.updateTagsDisplay()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: "Microphone Permission Required",
            message: "Please enable microphone access in Settings to record your dreams.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showAlert(message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        present(alert, animated: true)
    }
}

// MARK: - Voice Emotion Button
class VoiceEmotionButton: UIButton {
    let mood: Dream.Mood
    
    private let iconView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 237/255, green: 242/255, blue: 247/255, alpha: 1) // #EDF2F7
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
        label.font = Theme.font(size: 12, weight: .medium)
        label.textColor = Theme.secondaryText
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
        updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(iconView)
        iconView.addSubview(emojiLabel)
        addSubview(nameLabel)
        
        emojiLabel.text = mood.emoji
        nameLabel.text = mood.rawValue.capitalized
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 60),
            iconView.heightAnchor.constraint(equalToConstant: 60),
            
            emojiLabel.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func updateAppearance() {
        if isSelected {
            iconView.backgroundColor = Theme.primary
            emojiLabel.textColor = .white
            nameLabel.textColor = Theme.primary
            nameLabel.font = Theme.font(size: 12, weight: .semibold)
        } else {
            iconView.backgroundColor = UIColor(red: 237/255, green: 242/255, blue: 247/255, alpha: 1) // #EDF2F7
            emojiLabel.textColor = Theme.secondaryText
            nameLabel.textColor = Theme.secondaryText
            nameLabel.font = Theme.font(size: 12, weight: .medium)
        }
    }
}

// MARK: - Waveform Animation View
class WaveformView: UIView {
    private var waveBarViews: [UIView] = []
    private var displayLink: CADisplayLink?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWaveBars()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWaveBars()
    }
    
    private func setupWaveBars() {
        for i in 0..<8 {
            let waveBar = UIView()
            waveBar.backgroundColor = Theme.primary
            waveBar.layer.cornerRadius = 1.5
            waveBar.translatesAutoresizingMaskIntoConstraints = false
            addSubview(waveBar)
            waveBarViews.append(waveBar)
            
            NSLayoutConstraint.activate([
                waveBar.widthAnchor.constraint(equalToConstant: 3),
                waveBar.centerYAnchor.constraint(equalTo: centerYAnchor),
                waveBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat(i * 24)),
                waveBar.heightAnchor.constraint(equalToConstant: 5)
            ])
        }
    }
    
    func startAnimation() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateWaveform))
        displayLink?.add(to: .main, forMode: .common)
        
        for (index, waveBar) in waveBarViews.enumerated() {
            let animation = CABasicAnimation(keyPath: "transform.scale.y")
            animation.fromValue = 1.0
            animation.toValue = 6.0
            animation.duration = 1.5
            animation.repeatCount = .infinity
            animation.autoreverses = true
            animation.beginTime = CACurrentMediaTime() + Double(index) * 0.1
            waveBar.layer.add(animation, forKey: "wave")
        }
    }
    
    func stopAnimation() {
        displayLink?.invalidate()
        displayLink = nil
        
        waveBarViews.forEach { $0.layer.removeAllAnimations() }
    }
    
    @objc private func updateWaveform() {
        // Additional waveform logic if needed
    }
} 