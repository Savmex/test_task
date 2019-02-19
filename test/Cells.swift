//
//  Cells.swift
//  test
//
//  Created by Savik on 2/4/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
class SearchLabelCell: UITableViewCell, UITextFieldDelegate{
    
    //MARK: - variables
    var targetForReturnButton: ViewController?
    
    let searchLabel: UITextField = {
        let label = UITextField()
        label.placeholder = "Search..."
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        return view
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        return view
    }()
    
    //MARK: - init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - textfield delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        targetForReturnButton?.searchButtonPressed()
        searchLabel.resignFirstResponder()
        return true
    }
    //MARK: - setup
    func setUp(){
        searchLabel.delegate =  self
        addSubview(searchLabel)
        addSubview(topLine)
        addSubview(bottomLine)
        addConstraintWithFormat(format: "H:|-10-[v0]-10-|", views: searchLabel)
        addConstraintWithFormat(format: "H:|[v0]|", views: topLine)
        addConstraintWithFormat(format: "H:|[v0]|", views: bottomLine)
        addConstraintWithFormat(format: "V:|-1-[v0(1)][v1(36)][v2(1)]-1-|", views: topLine,searchLabel,bottomLine)
    }
    
}

class SearchButtonCell: UITableViewCell{
    //MARK: - variables
    var targetForButton: ViewController?
    
    var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        return progressView
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Google Search", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        return view
    }()
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setup
    func setUp(){
        searchButton.addTarget(target, action: #selector(targetForButton?.searchButtonPressed), for: .touchDown)
        addSubview(searchButton)
        addSubview(bottomLine)
        addSubview(progressView)
        progressView.isHidden = true
        addConstraintWithFormat(format: "H:|-70-[v0]-70-|", views: searchButton)
        addConstraintWithFormat(format: "H:|[v0]|", views: bottomLine)
        addConstraintWithFormat(format: "H:|[v0]|", views: progressView)
        addConstraintWithFormat(format: "V:|-2-[v0(34)]-2-[v1(2)]-1-[v2(1)]|", views: searchButton, progressView,bottomLine)
    }
}

class SearchResultCell: UITableViewCell{
    //MARK: - variables
    var item: Item?{
        didSet{
            labelForTitle.text = item?.title
            labelForLink.text = item?.url
        }
    }
    
    let labelForTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let labelForLink: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        return label
    }()
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setup
    func setUp(){
        addSubview(labelForTitle)
        addSubview(labelForLink)
        addConstraintWithFormat(format: "H:|-2-[v0]-2-|", views: labelForTitle)
        addConstraintWithFormat(format: "H:|-2-[v0]-2-|", views: labelForLink)
        addConstraintWithFormat(format: "V:|-2-[v0(30)]-2-[v1(24)]-2-|", views: labelForTitle,labelForLink)
    }
}
