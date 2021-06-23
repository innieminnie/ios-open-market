//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by 강인희 on 2021/06/22.
//

import UIKit

class ProductDetailViewController: UIViewController {
    private lazy var mainScrollView: UIScrollView = {
        let mainScrollView = UIScrollView()
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.addSubview(stackView)
        return mainScrollView
    }()
    
    private lazy var productImageView: UIImageView = {
        let productThumbnailImageView = UIImageView()
        productThumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        return productThumbnailImageView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let productNameLabel = UILabel()
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.font = .preferredFont(forTextStyle: .title1)
        productNameLabel.numberOfLines = 0
        productNameLabel.adjustsFontForContentSizeCategory = true
        productNameLabel.textColor = .black
        productNameLabel.adjustsFontSizeToFitWidth = true
        productNameLabel.textAlignment = .center
        return productNameLabel
    }()
    
    private lazy var productDescriptionLabel: UILabel = {
        let productDescriptionLabel = UILabel()
        productDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        productDescriptionLabel.font = .preferredFont(forTextStyle: .body)
        productDescriptionLabel.numberOfLines = 0
        productDescriptionLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        productDescriptionLabel.adjustsFontForContentSizeCategory = true
        productDescriptionLabel.textColor = .black
        productDescriptionLabel.adjustsFontSizeToFitWidth = true
        productDescriptionLabel.textAlignment = .center
        return productDescriptionLabel
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let productPriceLabel = UILabel()
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productPriceLabel.font = .preferredFont(forTextStyle: .title2)
        productPriceLabel.numberOfLines = 0
        productPriceLabel.adjustsFontForContentSizeCategory = true
        productPriceLabel.textColor = .gray
        productPriceLabel.adjustsFontSizeToFitWidth = true
        return productPriceLabel
    }()

    private lazy var productDiscountedPriceLabel: UILabel = {
        let productDiscountedPriceLabel = UILabel()
        productDiscountedPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productDiscountedPriceLabel.font = .preferredFont(forTextStyle: .title2)
        productDiscountedPriceLabel.numberOfLines = 0
        productDiscountedPriceLabel.adjustsFontForContentSizeCategory = true
        productDiscountedPriceLabel.textColor = .gray
        productDiscountedPriceLabel.adjustsFontSizeToFitWidth = true
        return productDiscountedPriceLabel
    }()
    
    private lazy var productStockLabel: UILabel = {
        let productStockLabel = UILabel()
        productStockLabel.translatesAutoresizingMaskIntoConstraints = false
        productStockLabel.font = .preferredFont(forTextStyle: .title2)
        productStockLabel.numberOfLines = 0
        productStockLabel.adjustsFontSizeToFitWidth = true
        productStockLabel.adjustsFontForContentSizeCategory = true
        productStockLabel.textColor = .gray
        return productStockLabel
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(productImageView)
        stackView.addArrangedSubview(productNameLabel)
        stackView.addArrangedSubview(productDescriptionLabel)
        stackView.addArrangedSubview(productPriceLabel)
        stackView.addArrangedSubview(productDiscountedPriceLabel)
        stackView.addArrangedSubview(productStockLabel)
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.axis = .vertical
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpConstraints()
        
    }
    
    private func updateUI(with product: Product) {
        DispatchQueue.main.async {
            self.productNameLabel.text = product.title
            self.productDescriptionLabel.text = product.descriptions ?? "상세 정보가 없습니다."
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
    
    private func setUpConstraints() {
        view.addSubview(mainScrollView)
        
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor, constant: -10),
            stackView.widthAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.widthAnchor, constant: -20),
            
            productImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
        ])
    }
}
extension ProductDetailViewController: DetailProductDelegate {
    func showCurrentProduct(_ product: Product) {
        DispatchQueue.global().async {
            guard let imageURLText = product.images?.first, let imageURL = URL(string: imageURLText), let imageData = try? Data(contentsOf: imageURL) else {
                DispatchQueue.main.async {
                    self.productImageView.image = UIImage(systemName: "multiply.circle.fill")
                    self.updateUI(with: product)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.productImageView.image = UIImage(data: imageData)
                self.updateUI(with: product)
            }
        }
    }
}
