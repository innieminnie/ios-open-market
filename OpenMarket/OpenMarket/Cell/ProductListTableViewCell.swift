
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
    
    private lazy var productPriceLabel: UILabel = {
        let productPriceLabel = UILabel()
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productPriceLabel.font = .preferredFont(forTextStyle: .body)
        productPriceLabel.adjustsFontForContentSizeCategory = true
        productPriceLabel.textColor = .gray
        return productPriceLabel
    }()
    
    private lazy var productDiscountedPriceLabel: UILabel = {
        let productDiscountedPriceLabel = UILabel()
        productDiscountedPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productDiscountedPriceLabel.font = .preferredFont(forTextStyle: .body)
        productDiscountedPriceLabel.adjustsFontForContentSizeCategory = true
        productDiscountedPriceLabel.textColor = .gray
        return productDiscountedPriceLabel
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
        self.contentView.addSubview(productNameLabel)
        self.contentView.addSubview(productStockLabel)
        self.contentView.addSubview(productPriceLabel)
        self.contentView.addSubview(productDiscountedPriceLabel)
        
        NSLayoutConstraint.activate([
            productThumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            productThumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productThumbnailImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            productThumbnailImageView.heightAnchor.constraint(equalTo: productThumbnailImageView.widthAnchor),
            productThumbnailImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5),
            
            productStockLabel.topAnchor.constraint(equalTo: productThumbnailImageView.topAnchor),
            productStockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            productNameLabel.topAnchor.constraint(equalTo:  productStockLabel.bottomAnchor, constant: 5),
            productNameLabel.leadingAnchor.constraint(equalTo: productThumbnailImageView.trailingAnchor, constant: 5),
            
            productPriceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 5),
            productPriceLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
            
            productDiscountedPriceLabel.topAnchor.constraint(equalTo: productPriceLabel.topAnchor),
            productDiscountedPriceLabel.leadingAnchor.constraint(equalTo: productPriceLabel.trailingAnchor, constant: 5),
            productDiscountedPriceLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10)
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
