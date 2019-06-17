//
//  ProductsSliderView.swift
//  Test.AmeDigitalLodjinha
//
//  Created by Leandro Romano on 16/06/19.
//  Copyright © 2019 Leandro Romano. All rights reserved.
//

import UIKit
import SDWebImage

class ProductsSliderView: UIView {

    let kDeviceScreenWidthSize = UIScreen.main.bounds.width
    let kSliderHeight: CGFloat = CGFloat(200)
    
    let images: [String]
    
    init(images: [String]) {
        self.images = images
        super.init(frame: CGRect(x: 0, y: 0, width: kDeviceScreenWidthSize, height: kSliderHeight))
        self.setupViews()
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.kDeviceScreenWidthSize, height: self.kSliderHeight))
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: (self.kDeviceScreenWidthSize*CGFloat(self.images.count)), height: self.kSliderHeight)
        scrollView.isPagingEnabled = true
        
        for i in 0..<self.images.count {
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: self.images[i]), placeholderImage: UIImage(named: "logoSobre"))
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            
            let xPosition = self.kDeviceScreenWidthSize*CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            
            scrollView.addSubview(imageView)
        }
        
        return scrollView
    }()
    
    lazy var pageControlView: UIPageControl = {
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: 180, width: self.kDeviceScreenWidthSize, height: 10))
        pageControl.numberOfPages = self.images.count
        pageControl.currentPage = 0
        pageControl.tintColor = .gray
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        
        return pageControl
    }()
    
    private func setupViews() {
        self.addSubview(self.contentScrollView)
        self.addSubview(self.pageControlView)
    }
    
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}

extension ProductsSliderView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(self.contentScrollView.contentOffset.x / self.contentScrollView.frame.size.width)
        self.pageControlView.currentPage = Int(pageNumber)
    }
    
}
