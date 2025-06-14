import UIKit

enum Theme {
    // Colors - matching HTML design exactly
    static let primary = UIColor(red: 91/255, green: 127/255, blue: 255/255, alpha: 1) // #5B7FFF
    static let secondary = UIColor(red: 167/255, green: 139/255, blue: 250/255, alpha: 1) // #A78BFA
    static let background = UIColor(red: 245/255, green: 247/255, blue: 250/255, alpha: 1) // #F5F7FA
    static let darkBackground = UIColor(red: 26/255, green: 32/255, blue: 44/255, alpha: 1) // #1A202C
    static let cardBackground = UIColor.white
    static let darkCardBackground = UIColor(red: 45/255, green: 55/255, blue: 72/255, alpha: 1) // #2D3748
    static let inputBackground = UIColor(red: 237/255, green: 242/255, blue: 247/255, alpha: 1) // #EDF2F7
    static let darkInputBackground = UIColor(red: 45/255, green: 55/255, blue: 72/255, alpha: 1) // #2D3748
    
    // Text Colors
    static let primaryText = UIColor(red: 26/255, green: 32/255, blue: 44/255, alpha: 1) // #1A202C
    static let secondaryText = UIColor(red: 74/255, green: 85/255, blue: 104/255, alpha: 1) // #4A5568
    static let tertiaryText = UIColor(red: 113/255, green: 128/255, blue: 150/255, alpha: 1) // #718096
    
    // Tag Colors
    static let tagBackground = UIColor(red: 235/255, green: 244/255, blue: 255/255, alpha: 1) // #EBF4FF
    static let tagText = UIColor(red: 91/255, green: 127/255, blue: 255/255, alpha: 1) // #5B7FFF
    
    // Gradients
    static let splashGradient = [
        UIColor(red: 91/255, green: 127/255, blue: 255/255, alpha: 1).cgColor,
        UIColor(red: 167/255, green: 139/255, blue: 250/255, alpha: 1).cgColor
    ]
    
    // Typography - Inter font system
    static func font(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        // Using system font with Inter-like characteristics
        return .systemFont(ofSize: size, weight: weight)
    }
    
    // Layout - matching HTML spacing
    static let cornerRadius: CGFloat = 12
    static let cardCornerRadius: CGFloat = 16
    static let buttonCornerRadius: CGFloat = 12
    static let padding: CGFloat = 20
    static let cardPadding: CGFloat = 16
    static let spacing: CGFloat = 16
    static let smallSpacing: CGFloat = 8
    
    // Animations
    static let defaultAnimationDuration: TimeInterval = 0.3
    
    // Common UI Elements
    static func styleTextField(_ textField: UITextField) {
        textField.backgroundColor = Theme.inputBackground
        textField.layer.cornerRadius = Theme.cornerRadius
        textField.font = Theme.font(size: 16, weight: .semibold)
        textField.textColor = Theme.primaryText
        textField.tintColor = Theme.primary
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.rightViewMode = .always
        
        // Match HTML input styling
        textField.layer.borderWidth = 0
        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder ?? "",
            attributes: [
                .foregroundColor: Theme.tertiaryText,
                .font: Theme.font(size: 16, weight: .regular)
            ]
        )
    }
    
    static func styleTextView(_ textView: UITextView) {
        textView.backgroundColor = Theme.inputBackground
        textView.layer.cornerRadius = Theme.cornerRadius
        textView.font = Theme.font(size: 16)
        textView.textColor = Theme.primaryText
        textView.tintColor = Theme.primary
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        textView.layer.borderWidth = 0
    }
    
    static func styleButton(_ button: UIButton, style: ButtonStyle = .primary) {
        button.layer.cornerRadius = Theme.buttonCornerRadius
        button.titleLabel?.font = Theme.font(size: 16, weight: .semibold)
        
        switch style {
        case .primary:
            button.backgroundColor = Theme.primary
            button.setTitleColor(.white, for: .normal)
            // Add shadow like HTML
            button.layer.shadowColor = Theme.primary.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
            button.layer.shadowRadius = 6
            button.layer.shadowOpacity = 0.2
        case .secondary:
            button.backgroundColor = Theme.inputBackground
            button.setTitleColor(Theme.primary, for: .normal)
        case .text:
            button.backgroundColor = .clear
            button.setTitleColor(Theme.tertiaryText, for: .normal)
        }
    }
    
    static func styleCard(_ view: UIView) {
        view.backgroundColor = Theme.cardBackground
        view.layer.cornerRadius = Theme.cardCornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.1
    }
    
    static func createDreamCard() -> UIView {
        let card = UIView()
        styleCard(card)
        return card
    }
    
    static func createTag(text: String) -> UIView {
        let tagView = UIView()
        tagView.backgroundColor = Theme.tagBackground
        tagView.layer.cornerRadius = 8
        
        let label = UILabel()
        label.text = text
        label.font = Theme.font(size: 14, weight: .medium)
        label.textColor = Theme.tagText
        
        tagView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: tagView.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: tagView.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: tagView.trailingAnchor, constant: -12),
            label.bottomAnchor.constraint(equalTo: tagView.bottomAnchor, constant: -8)
        ])
        
        return tagView
    }
    
    enum ButtonStyle {
        case primary
        case secondary
        case text
    }
}

// Custom UI Components
class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    private func setupGradient() {
        gradientLayer.colors = Theme.splashGradient
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [0.0, 1.0]
    }
}

// HTML-style header button
class HeaderButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        backgroundColor = Theme.inputBackground
        layer.cornerRadius = Theme.cornerRadius
        titleLabel?.font = Theme.font(size: 16, weight: .medium)
        setTitleColor(Theme.secondaryText, for: .normal)
        
        // Match HTML header button size
        widthAnchor.constraint(equalToConstant: 40).isActive = true
        heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
} 