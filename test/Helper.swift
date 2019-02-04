//
//  Helper.swift
//  test
//
//  Created by Savik on 2/4/19.
//  Copyright © 2019 Macbook. All rights reserved.
//


import UIKit
extension UIView{
    func addConstraintWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String : UIView]()
        for (index,view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format,
                                                      options: NSLayoutConstraint.FormatOptions(),
                                                      metrics: nil,
                                                      views: viewsDictionary))
    }
}

struct Item{
    var url: String
    var title: String
}
