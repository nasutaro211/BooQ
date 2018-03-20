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
    
    override func viewDidLoad() {
        searchBar.delegate = self
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.bringDataToBooksWith(searchBar.text!)
        

    }
    
    func bringDataToBooksWith(_ q:String){
        guard let encodedKeyword = q.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            print("無効なURL")
            return
        }
        let url = "https://www.googleapis.com/books/v1/volumes?q=" + encodedKeyword
            Alamofire.request(url).response { response in
                if let data = response.data, let responseData:ResponseData = try? JSONDecoder().decode(ResponseData.self, from: data){
                    
                    for item in responseData.items{
                        self.books.append(item.volumeInfo)
                    }
                    if self.books.count != 0{
                        print(self.books[0].title)
                    }
                    self.showBookInfoResult(self.books)
                    
                }
            }
        }
    
    func showBookInfoResult(_ bookinfos : [VolumeInfo] ) {
        // メインスレッドで処理を実行する
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toResultView", sender: bookinfos)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultView"{
            let resultView = segue.destination as! SearchResultViewController
            resultView.books = sender as! Array<VolumeInfo>
        }
    }
    
    
    
    

    
    
    
    
    
}
