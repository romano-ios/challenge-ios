//
//  ProductListRouter.swift
//  Test.AmeDigitalLodjinha
//
//  Created by Leandro Romano on 22/06/19.
//  Copyright (c) 2019 Leandro Romano. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol ProductListRoutingLogic {
    func routeToProductDetails()
}

protocol ProductListDataPassing {
    var dataStore: ProductListDataStore? { get }
}

class ProductListRouter: NSObject, ProductListRoutingLogic, ProductListDataPassing {

    weak var viewController: ProductListViewController?
    var dataStore: ProductListDataStore?

    func routeToProductDetails() {
        let productDetailsVC = ProductDetailsViewController(nibName: String(describing: ProductDetailsViewController.self), bundle: nil)
        guard let productDetailsRouter = productDetailsVC.router, var productDetailsDS = productDetailsRouter.dataStore else { return }
        
        if let dataStore = dataStore {
            passDataToProductDetails(source: dataStore, destination: &productDetailsDS)
            navigateToProductDetails(source: viewController, destination: productDetailsVC)
        }
    }
    
    func passDataToProductDetails(source: ProductListDataStore, destination: inout ProductDetailsDataStore) {
        destination.product = source.product
    }
    
    func navigateToProductDetails(source: ProductListViewController?, destination: ProductDetailsViewController) {
        source?.navigationController?.pushViewController(destination, animated: true)
    }

}
