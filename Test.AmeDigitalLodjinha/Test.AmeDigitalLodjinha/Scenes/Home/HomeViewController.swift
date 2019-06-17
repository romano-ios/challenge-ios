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
}

class HomeViewController: UITableViewController {
    
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

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

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: Do something

    //@IBOutlet weak var nameTextField: UITextField!
    
    private func setupView() {
        setupNavigationLogo()
        setupBanners()
    }

    private func setupNavigationLogo() {
        interactor?.setNavigationLogoView()
    }
    
    private func setupBanners() {
        interactor?.setBannersContentLoading()
        interactor?.getBannersContent()
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
    
    func displayBannersLoading() {
        let container: UIView = UIView()
        container.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 200)
        container.backgroundColor = Constants.mainColor
        
        let activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.center = container.center
        activityView.startAnimating()
        
        container.addSubview(activityView)
        
        self.tableView.tableHeaderView = container
    }
    
    func displayBanners(viewModel: Home.Banner.ViewModel) {
        let images: [String] = viewModel.banners.map { $0.photo }
        
        let sliderView = ProductsSliderView(images: images)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        
        // 1.
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        // headerView is your actual content.
        containerView.addSubview(sliderView)
        
        // 2.
        self.tableView.tableHeaderView = containerView
        // 3.
        containerView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        // 4.
        self.tableView.tableHeaderView?.layoutIfNeeded()
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
    }
    
}
