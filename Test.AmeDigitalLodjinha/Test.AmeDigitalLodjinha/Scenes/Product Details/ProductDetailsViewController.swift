//
//  ProductDetailsViewController.swift
//  Test.AmeDigitalLodjinha
//
//  Created by Leandro Romano on 20/06/19.
//  Copyright (c) 2019 Leandro Romano. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ProductDetailsDisplayLogic: class {
    func displayProductDetails(viewModel: ProductDetails.ViewModel)
    func displayReserveProductButton()
}

class ProductDetailsViewController: UIViewController {

    var interactor: ProductDetailsBusinessLogic?
    var router: (NSObjectProtocol & ProductDetailsRoutingLogic & ProductDetailsDataPassing)?

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
        let interactor = ProductDetailsInteractor()
        let presenter = ProductDetailsPresenter()
        let router = ProductDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        requestProductDetails()
    }
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productOldPriceLabel: UILabel!
    @IBOutlet weak var productCurrentPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    func requestProductDetails() {
        interactor?.requestProductDetails()
    }
    
}

extension ProductDetailsViewController: ProductDetailsDisplayLogic {
    
    func displayProductDetails(viewModel: ProductDetails.ViewModel) {
        title = viewModel.category
        productImageView.sd_setImage(with: URL(string: viewModel.imageUrl), placeholderImage: UIImage(named: "noProductPlaceholder"))
        productNameLabel.text = viewModel.name
        productOldPriceLabel.text = "De: \(LodjinhaUtils.convertMoneyToString(viewModel.oldPrice))"
        productCurrentPriceLabel.text = "Por: \(LodjinhaUtils.convertMoneyToString(viewModel.currentPrice))"
        productDescriptionLabel.attributedText = viewModel.description.htmlToAttributedString
        productDescriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    func displayReserveProductButton() {
        guard let window = UIApplication.shared.keyWindow else { return }
        let componentHeight: CGFloat = 74
        var yPosition = window.frame.size.height - componentHeight
        
        if #available(iOS 11.0, *) {
            yPosition -= window.safeAreaInsets.bottom
        }
        
        let reserveProductView = ReserveProductView(frame: CGRect(x: 0, y: yPosition, width: window.frame.size.width, height: componentHeight))
        self.view.addSubview(reserveProductView)
    }
    
}