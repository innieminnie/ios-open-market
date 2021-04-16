import UIKit

class RegisterProductViewController: UIViewController {
    private lazy var productTitleTextField: UITextField = {
        let productTitleLabel = UITextField()
        productTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        productTitleLabel.borderStyle = .line
        return productTitleLabel
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(productTitleTextField)
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpConstraints()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        productTitleTextField.text = "가나다"
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
