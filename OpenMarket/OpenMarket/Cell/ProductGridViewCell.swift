
import UIKit

class ProductGridViewCell: UICollectionViewCell {
    static let identifier: String = "ProductGridViewCell"
    
    private lazy var productThumbnailImageView: UIImageView = {
        let productThumbnailImageView = UIImageView()
        productThumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        return productThumbnailImageView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let productNameLabel = UILabel()
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.font = .preferredFont(forTextStyle: .headline)
        productNameLabel.adjustsFontForContentSizeCategory = true
        productNameLabel.textColor = .black
        productNameLabel.adjustsFontSizeToFitWidth = true
        productNameLabel.textAlignment = .center
        return productNameLabel
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let productPriceLabel = UILabel()
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productPriceLabel.font = .preferredFont(forTextStyle: .body)
        productPriceLabel.adjustsFontForContentSizeCategory = true
        productPriceLabel.textColor = .gray
        productPriceLabel.adjustsFontSizeToFitWidth = true
        return productPriceLabel
    }()
    
    private lazy var productDiscountedPriceLabel: UILabel = {
        let productDiscountedPriceLabel = UILabel()
        productDiscountedPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productDiscountedPriceLabel.font = .preferredFont(forTextStyle: .body)
        productDiscountedPriceLabel.adjustsFontForContentSizeCategory = true
        productDiscountedPriceLabel.textColor = .gray
        productDiscountedPriceLabel.adjustsFontSizeToFitWidth = true
        return productDiscountedPriceLabel
    }()
    
    private lazy var productStockLabel: UILabel = {
       let productStockLabel = UILabel()
        productStockLabel.translatesAutoresizingMaskIntoConstraints = false
        productStockLabel.font = .preferredFont(forTextStyle: .body)
        productStockLabel.adjustsFontSizeToFitWidth = true
        productStockLabel.adjustsFontForContentSizeCategory = true
        productStockLabel.textColor = .gray
        return productStockLabel
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(productPriceLabel)
        stackView.addArrangedSubview(productDiscountedPriceLabel)
        stackView.addArrangedSubview(productStockLabel)
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(productThumbnailImageView)
        mainStackView.addArrangedSubview(productNameLabel)
        mainStackView.addArrangedSubview(stackView)
        mainStackView.alignment = .center
        mainStackView.axis = .vertical
        return mainStackView
    }()

    override init(frame: CGRect) {
        super .init(frame: frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.magenta.cgColor
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpConstraints() {
        self.contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            productThumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            productThumbnailImageView.heightAnchor.constraint(equalTo: productThumbnailImageView.widthAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    override func prepareForReuse() {
        self.contentView.backgroundColor = .white
        productThumbnailImageView.image = nil
        productNameLabel.text = nil
        productStockLabel.text = nil
        productStockLabel.textColor = .gray
        productPriceLabel.attributedText = NSMutableAttributedString(string: "")
        productStockLabel.textColor = .gray
        productDiscountedPriceLabel.text = nil
        productDiscountedPriceLabel.textColor = .gray
    }
    
    func updateUI(with product: Product, imageData: UIImage?) {
        self.productThumbnailImageView.image = imageData ?? UIImage(systemName: "multiply.circle.fill")
        self.productNameLabel.text = product.title
        self.productStockLabel.text = "잔여수량 : \(product.stock.distinguishNumberUnit())"
        
        if product.stock == 0 {
            self.productStockLabel.text = "품절"
            self.productStockLabel.textColor = .systemOrange
        }
        
        guard let  discountedPrice = product.discountedPrice else {
            let text = NSMutableAttributedString(string: "\(product.currency) \(product.price.distinguishNumberUnit())")
            self.productPriceLabel.attributedText = text
            self.productPriceLabel.textColor = .gray
            
            return
        }
        
        let text = NSMutableAttributedString(string: "\(product.currency) \(product.price.distinguishNumberUnit())", attributes: [NSAttributedString.Key.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue)])
        self.productPriceLabel.attributedText = text
        self.productPriceLabel.textColor = .red
        self.productDiscountedPriceLabel.text = "\(product.currency) \((product.price-discountedPrice).distinguishNumberUnit())"
    }
}

