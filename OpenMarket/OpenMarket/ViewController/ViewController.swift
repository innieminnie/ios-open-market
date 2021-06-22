//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let listViewController = ListViewController()
    let gridViewController = GridViewController()
    let listPresentingStyleSelection = ["LIST","GRID"]
    private lazy var listPresentingStyleSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: listPresentingStyleSelection)
        control.selectedSegmentIndex = 0
        control.layer.borderColor = UIColor.systemBlue.cgColor
        control.tintColor = .systemBlue
        control.selectedSegmentTintColor = .systemBlue
        control.addTarget(self, action: #selector(didTapSegment(segment:)), for: .valueChanged)
        return control
    }()
    private lazy var addProductButton: UIBarButtonItem = {
        let button =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateChildViews), name: Notification.Name("dataUpdate"), object: nil)
        OpenMarketAPIManager.shared.requestProductList()
        setUpNavigationItem()
        setUpView()
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
//        let registerProductViewController = RegisterProductViewController()
//        self.present(registerProductViewController, animated: true, completion: nil)
    }
}
extension ViewController {
    @objc private func updateChildViews() {
        DispatchQueue.main.async {
            self.listViewController.tableView.reloadData()
            self.gridViewController.collectionView.reloadData()
        }
    }
    private func setUpNavigationItem() {
        self.navigationItem.titleView = listPresentingStyleSegmentControl
        self.navigationItem.rightBarButtonItem = addProductButton
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
}
