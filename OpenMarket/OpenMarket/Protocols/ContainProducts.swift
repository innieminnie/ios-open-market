//
//  ContainProduct.swift
//  OpenMarket
//
//  Created by 강인희 on 2021/06/14.
//

protocol ContainProducts {
    var productList: [Product] { get }
}
extension ContainProducts {
    var productList: [Product] {
        return OpenMarketAPIManager.shared.productList
    }
}

protocol DetailProductDelegate: AnyObject {
    func showCurrentProduct(_ product: Product)
}
