
import UIKit

class ProductListTableViewCell: UITableViewCell {
    static let identifier: String = "ProductListTableViewCell"
    
    private lazy var productThumbnailImageView: UIImageView = {
        let productThumbnailImageView = UIImageView()
        productThumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        return productThumbnailImageView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let productNameLabel = UILabel()
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.font = .preferredFont(forTextStyle: .headline)
        productNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        productNameLabel.adjustsFontForContentSizeCategory = true
        productNameLabel.textColor = .black
        return productNameLabel
    }()
    
    private lazy var productStockLabel: UILabel = {
        let productStockLabel = UILabel()
        productStockLabel.translatesAutoresizingMaskIntoConstraints = false
        productStockLabel.font = .preferredFont(forTextStyle: .body)
        productStockLabel.adjustsFontForContentSizeCategory = true
        productStockLabel.textColor = .gray
        productStockLabel.textAlignment = .right
        return productStockLabel
    }()
    
    private lazy var productInformationHorizontalStackView: UIStackView = {
        let productInformationHorizontalStackView = UIStackView()
        productInformationHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        productInformationHorizontalStackView.addArrangedSubview(productNameLabel)
        productInformationHorizontalStackView.addArrangedSubview(productStockLabel)
        productInformationHorizontalStackView.spacing = 8
        productInformationHorizontalStackView.axis = .horizontal
        return productInformationHorizontalStackView
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let productPriceLabel = UILabel()
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productPriceLabel.font = .preferredFont(forTextStyle: .body)
        productPriceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        productPriceLabel.adjustsFontForContentSizeCategory = true
        productPriceLabel.textColor = .gray
        return productPriceLabel
    }()
    
    private lazy var productDiscountedPriceLabel: UILabel = {
        let productDiscountedPriceLabel = UILabel()
        productDiscountedPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productDiscountedPriceLabel.font = .preferredFont(forTextStyle: .body)
        productDiscountedPriceLabel.adjustsFontForContentSizeCategory = true
        return productDiscountedPriceLabel
    }()
    
    private lazy var productPriceStackView: UIStackView = {
        let productPriceStackView = UIStackView()
        productPriceStackView.translatesAutoresizingMaskIntoConstraints = false
        productPriceStackView.addArrangedSubview(productPriceLabel)
        productPriceStackView.addArrangedSubview(productDiscountedPriceLabel)
        productPriceStackView.spacing = 5
        productPriceStackView.axis = .horizontal
        return productPriceStackView
    }()
    
    private lazy var productInformationVerticalStackView: UIStackView = {
        let productInformationVerticalStackView = UIStackView()
        productInformationVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        productInformationVerticalStackView.addArrangedSubview(productInformationHorizontalStackView)
        productInformationVerticalStackView.addArrangedSubview(productPriceStackView)
        productInformationVerticalStackView.axis = .vertical
        return productInformationVerticalStackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        self.contentView.addSubview(productThumbnailImageView)
        self.contentView.addSubview(productInformationVerticalStackView)
        
        NSLayoutConstraint.activate([
            productThumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            productThumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productThumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            productThumbnailImageView.heightAnchor.constraint(equalTo: productThumbnailImageView.widthAnchor),
            productThumbnailImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5),
        
            productInformationVerticalStackView.leadingAnchor.constraint(equalTo: productThumbnailImageView.trailingAnchor, constant: 10),
            productInformationVerticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            productInformationVerticalStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
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
