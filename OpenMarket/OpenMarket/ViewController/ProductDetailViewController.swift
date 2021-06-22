//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by 강인희 on 2021/06/22.
//

import UIKit

class ProductDetailViewController: UIViewController, DetailProductDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showCurrentProduct(_ product: Product) {
    
        print(product)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
