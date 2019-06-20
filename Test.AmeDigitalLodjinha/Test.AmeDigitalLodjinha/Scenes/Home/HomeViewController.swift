//
//  HomeViewController.swift
//  Test.AmeDigitalLodjinha
//
//  Created by Leandro Romano on 14/06/19.
//  Copyright (c) 2019 Leandro Romano. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HomeDisplayLogic: class {
    func displayNavigationLogo()
    func displayBannersLoading()
    func displayBanners(viewModel: Home.Banner.ViewModel)
    func displayBannersError(_ error: Error)
    func displayNewData()
    func displayBestSellerDetails()
}

class HomeViewController: UITableViewController {
    
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupView()
    }
    
    private func setupView() {
        setupNavigationLogo()
        setupBanners()
        setupCategories()
        setupBestSellers()
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(
            UINib(nibName: String(describing: ProductTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: CellsIdentifiers.productCell.rawValue
        )
        tableView.register(
            UINib(nibName: String(describing: CategoryTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: CellsIdentifiers.categoryCell.rawValue
        )
    }

    private func setupNavigationLogo() {
        interactor?.setNavigationLogoView()
    }
    
    private func setupBanners() {
        interactor?.setBannersContentLoading()
        interactor?.getBannersContent()
    }
    
    private func setupCategories() {
        interactor?.getCategories()
    }
    
    private func setupBestSellers() {
        interactor?.getBestSellers()
    }

}

extension HomeViewController: HomeDisplayLogic {
    
    func displayNavigationLogo() {
        let logoNavbar = UIImage(named: "logoNavbar")
        if let logo = logoNavbar {
            let imageView = UIImageView(image: logo)
            self.navigationItem.titleView = imageView
        }
    }
    
    func displayNewData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func displayBestSellerDetails() {
        router?.routeToBestSellerDetails()
    }
    
}
