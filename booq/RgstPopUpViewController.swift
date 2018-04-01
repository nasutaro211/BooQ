//
//  RgstPopUpViewController.swift
//  
//
//  Created by 中田　優樹 on 2018/03/29.
//

//
//  rgstPopUpViewController.swift
//  Alamofire
//
//  Created by 中田　優樹 on 2018/03/29.
//

import UIKit
import RealmSwift
import Flurry_iOS_SDK

class RgstPopUpViewController: UIViewController {
    @IBOutlet var publishedDate: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bookImageView: UIImageView!
    
    var theBook: VolumeInfo!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(theBook.title != nil){titleLabel.text = theBook.title}
        if(theBook.authors != nil){authorLabel.text = theBook.authors![0]}else{authorLabel.text = ""}
        if(theBook.publishedDate != nil){publishedDate.text = theBook.publishedDate}
        var url:URL = URL(string: "http://illustrain.com/img/work/2016/illustrain10-hon01.png")!
        if(theBook.imageLinks != nil && theBook.imageLinks!["thumbnail"] != nil){url = URL(string: theBook.imageLinks!["thumbnail"]!)!}
        bookImageView.sd_setImage(with: url, completed: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushedPeke(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pushedRgstButton(_ sender: Any) {
        let realm = try! Realm()
        do{
            try realm.write {
                guard realm.object(ofType: Book.self, forPrimaryKey: theBook.isbn) == nil else{return}
                let book = Book()
                book.ISBN = theBook.isbn!
                if theBook.title != nil{book.title = theBook.title!}
                if let imageLinks = theBook.imageLinks, let imageLink = imageLinks["thumbnail"]{
                    book.imageLink = imageLink
                }
                realm.add(book)
            }
        }catch let error{
            print(error)
        }
        Flurry.logEvent("AddBook")
        performSegue(withIdentifier: "backToTab", sender: nil)
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            if tag == 1 {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

