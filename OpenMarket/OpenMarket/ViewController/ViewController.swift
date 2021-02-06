//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let openMarketAPIManager = OpenMarketAPIManager()
    
    let listViewController = ListViewController()
    let gridViewController = GridViewController()
    let listPresentingStyleSelection = ["LIST","GRID"]
    lazy var listPresentingStyleSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: listPresentingStyleSelection)
        control.selectedSegmentIndex = 0
        control.layer.borderColor = UIColor.systemBlue.cgColor
        control.tintColor = .systemBlue
        control.selectedSegmentTintColor = .systemBlue
        control.addTarget(self, action: #selector(didTapSegment(segment:)), for: .valueChanged)
        return control
    }()
    lazy var addProductButton: UIBarButtonItem = {
        let button =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        return button
    }()
    
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
        setUpView()
        
        listViewController.tableView.prefetchDataSource = self
        gridViewController.collectionView.prefetchDataSource = self
        
        requestProductList()
    }
    
    private func requestProductList() {
        openMarketAPIManager.requestProductList(of: currentPage) { (result) in
            switch result {
            case .success (let product):
                guard product.items.count > 0 else {
                    return
                }
                
                self.listViewController.productList.append(contentsOf: product.items)
                self.gridViewController.productList.append(contentsOf: product.items)
                
                DispatchQueue.main.async {
                    self.listViewController.tableView.reloadData()
                    self.gridViewController.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.currentPage += 1
    }
    
    private func setUpView() {
        addChild(listViewController)
        addChild(gridViewController)
        
        self.view.addSubview(listViewController.view)
        self.view.addSubview(gridViewController.view)
        
        listViewController.didMove(toParent: self)
        gridViewController.didMove(toParent: self)
        
        listViewController.view.frame = self.view.bounds
        gridViewController.view.frame = self.view.bounds
        
        gridViewController.view.isHidden = true
    }
    
    private func setUpNavigationItem() {
        self.navigationItem.titleView = listPresentingStyleSegmentControl
        self.navigationItem.rightBarButtonItem = addProductButton
    }
    
    @objc private func didTapSegment(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            listViewController.view.isHidden = false
            gridViewController.view.isHidden = true
        } else {
            gridViewController.view.isHidden = false
            listViewController.view.isHidden = true
        }
    }
    
    @objc private func addButtonTapped(_ sender: Any) {
        print("button pressed")
    }
}
extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            if index.row >= listViewController.productList.count - 3 {
                requestProductList()
            }
        }
    }
}
extension ViewController: UICollectionViewDataSourcePrefetching  {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            if index.row >= gridViewController.productList.count - 7 {
                requestProductList()
            }
        }
    }
}
