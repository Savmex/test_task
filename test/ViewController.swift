//
//  ViewController.swift
//  test
//
//  Created by Savik on 2/4/19.
//  Copyright © 2019 Macbook. All rights reserved.
//

import UIKit
import Foundation

//для многопоточности использовал OperationQueue т.к там можно отменять выполнение после его начала

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - variables
    var searchResults = [Item]()
    var operationQueue = OperationQueue()
    var progressView: UIProgressView?
    
    //MARK: - view controller methods
    override func viewDidLoad(){
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchLabelCell.self, forCellWithReuseIdentifier: "searchLabel")
        collectionView.register(SearchButtonCell.self, forCellWithReuseIdentifier: "searchButton")
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: "searchResult")
    }
    
    //MARK: - collection view methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return searchResults.count
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.frame.width, height: 40)
        case 1:
            return CGSize(width: collectionView.frame.width, height: 42)
        default:
            return CGSize(width: collectionView.frame.width, height: 60)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchLabel", for: indexPath) as! SearchLabelCell
            cell.targetForReturnButton = self
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                "searchButton", for: indexPath) as! SearchButtonCell
            cell.targetForButton = self
            progressView = cell.progressView
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchResult", for: indexPath) as! SearchResultCell
            cell.item = searchResults[indexPath.item]
            return cell
        }
        
    }
    //MARK: - search methods
    func getLabelText()-> String?{
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = collectionView.cellForItem(at: indexPath ) as! SearchLabelCell
        if let text = cell.searchLabel.text{
            return text
        }
        else{
            return nil
        }
    }
    
    func searchRequest(text: String){
        //AIzaSyBsnPhX_EwlimkglxKpjJe99lHBydcHuDs - ключ для приложения
        //012395726208297425069:_np83nffj40 - "search engine"
        //
        let urlAdress = "https://www.googleapis.com/customsearch/v1?key=AIzaSyBsnPhX_EwlimkglxKpjJe99lHBydcHuDs&cx=012395726208297425069:_np83nffj40&q=\(text)"
        if let url = URL(string: urlAdress){
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data{ //проверяем пришли ли данные
                    let operation = {       //создаем operation для асинхронного выполнения в operationQueue
                            OperationQueue.main.addOperation {      //т.к запрос завершился успешно очищаем collection view
                                self.searchResults.removeAll()
                                self.collectionView.reloadData()
                                self.progressView?.setProgress(0.4, animated: true)
                            }
                            do{
                                //парсинг данных json
                                let json = try(JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()))
                                let loadedData = json as? Dictionary<String, Any>
                                let items = loadedData!["items"] as? [Dictionary<String,Any>]
                                for item in items!{
                                    let newItem = Item(url: item["formattedUrl"] as! String, title: item["title"] as! String)
                                    self.searchResults.append(newItem)
                                    OperationQueue.main.addOperation {      //все действия с UI выполняются в main потоке
                                        self.progressView?.setProgress(0.7, animated: true)
                                        self.collectionView.reloadData()
                                    }
                                }
                            }catch let error{
                                print(error)
                                return
                            }
                    }
                    self.operationQueue.addOperation(operation) //отправляем operation в асинхронное выполнение
                    self.operationQueue.waitUntilAllOperationsAreFinished()
                    OperationQueue.main.addOperation {
                        self.progressView?.setProgress(1, animated: true)
                        self.progressView?.isHidden = true
                        self.changeButtonState()
                    }
                }
                else{
                    self.showToast(message: "No results")
                }
            }).resume()
        }
        else{
            progressView!.isHidden = true
            showToast(message: "Error")
            changeButtonState()
            searchResults.removeAll()
            collectionView.reloadData()
            return
        }
    }
    
    func changeButtonState(){
        let indexPath = IndexPath(row: 0, section: 1)
        let cell = collectionView.cellForItem(at: indexPath) as? SearchButtonCell
        if cell?.searchButton.backgroundColor == UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1){
            cell?.searchButton.backgroundColor = UIColor.red.withAlphaComponent(0.8)
            cell?.searchButton.setTitle("Stop", for: .normal)
        }
        else{
            //при нажатии кнопки во время поиска полностью все отменит
            operationQueue.cancelAllOperations()
            URLSession.shared.invalidateAndCancel()
            OperationQueue.main.cancelAllOperations()
            cell?.searchButton.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
            cell?.searchButton.setTitle("Search Google", for: .normal)
        }
    }
    
    //MARK: - other methods
    func hideKeyboard(){
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as? SearchLabelCell
        cell?.searchLabel.resignFirstResponder()
    }
    
    //MARK: - selectors
    @objc func searchButtonPressed(){
        if let text = getLabelText(){
            if text != ""{
                changeButtonState()
                hideKeyboard()
                searchRequest(text: text)
                progressView?.isHidden = false
                
            }
            else{
                searchResults.removeAll()
                collectionView.reloadData()
                showToast(message: "Enter text")
            }
        }
        else{
            return
        }
    }
}
