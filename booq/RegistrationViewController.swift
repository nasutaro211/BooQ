//
//  RegistrationViewController.swift
//  Pods-booq
//
//  Created by 中田　優樹 on 2018/03/19.
//

import UIKit
import Alamofire

class RegistrationViewController: UIViewController,UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    var books:[VolumeInfo] = []
    
    @IBOutlet var logLable: PaddingLabel!
    
    override func viewDidLoad() {
        searchBar.delegate = self
        super.viewDidLoad()
        logLable.isHidden = true

        searchBar.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            searchBar.isUserInteractionEnabled = true
        }
        self.bringDataToBooksWith(searchBar.text!)
    }

    func bringDataToBooksWith(_ q:String){
        guard let encodedKeyword = q.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            print("無効なURL")
            return
        }
        let url = "https://www.googleapis.com/books/v1/volumes?q=" + encodedKeyword + "&printType=books&maxResults=40"
        Alamofire.request(url).response { response in
            if let data = response.data, let responseData:ResponseData = try? JSONDecoder().decode(ResponseData.self, from: data){
                for item in responseData.items{
                    if let identifiers = item.volumeInfo.industryIdentifiers{
                        //isbnがついていたらappend
                        if self.checkContainISBN(identifers: identifiers){
                            var itemCopy = item
                            itemCopy.volumeInfo.isbn = self.returnISBN(identifers: identifiers)
                            self.books.append(itemCopy.volumeInfo)
                        }
                    }
                }
                self.showBookInfoResult(self.books)
            }else{
                //ここでないよラベル表示
                    self.logLable.alpha = 0
                    self.logLable.isHidden = false
                    UIView.animate(withDuration: 0.4, animations: {
                        self.logLable.alpha = 1
                    }, completion:nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        UIView.animate(withDuration: 0.4, animations: {
                            self.logLable.alpha = 0
                        }, completion:  {
                            (value: Bool) in
                            self.logLable.isHidden = true
                        })
                    })
                print("ないよ")
            }
        }
    }
    
    func checkContainISBN(identifers: [IndustryIdentifier]?) -> Bool{
        if identifers != nil{
            for identifer in identifers!{
                if identifer.type == "ISBN_13"{
                    return true
                }
            }
        }
        return false
    }
    
    func returnISBN(identifers: [IndustryIdentifier]?) -> String{
        for identifer in identifers!{
            if identifer.type == "ISBN_13"{
                return identifer.identifier
            }
        }
        return ""
    }
    
    func showBookInfoResult(_ bookinfos : [VolumeInfo] ) {
        // メインスレッドで処理を実行する
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toResultView", sender: bookinfos)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchBar.resignFirstResponder()
        if segue.identifier == "toResultView"{
            let resultView = segue.destination as! SearchResultViewController
            resultView.books = sender as! Array<VolumeInfo>
        }
    }
    
    
    @IBAction func backToTab(_ sender: Any) {
        self.isEditing = false
        performSegue(withIdentifier: "backToTabfr", sender: nil)
    }
    
    

    
    
    
    
    
}
