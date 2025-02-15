//
//  ProductListModels.swift
//  Test.AmeDigitalLodjinha
//
//  Created by Leandro Romano on 22/06/19.
//  Copyright (c) 2019 Leandro Romano. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

enum ProductList {
  
    class Response: Codable {
        let offset: Int
        let total: Int
        let data: [ProductModel]
        
        init(offset: Int, total: Int, data: [ProductModel]) {
            self.offset = offset
            self.total = total
            self.data = data
        }
    }
    
    struct ViewModel {
        let bestSellers: [ProductViewModel]
    }

}
