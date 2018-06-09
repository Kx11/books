//
//  favoritebook.swift
//  MyBooks
//
//  Created by 伊藤慶 on 2018/06/09.
//  Copyright © 2018年 伊藤慶. All rights reserved.
//

import UIKit
import CoreData
import Accounts

class favoritebook: UIViewController {
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var booklist:[Books] = []
    @IBOutlet weak var booktitle: UITextField!
    @IBOutlet weak var booknote: UITextView!
    @IBOutlet weak var bookphoto: UIImageView!
   
    var count:Int!
    var titlename:String!
    var switchs:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Books")
        print(titlename)
        do {
            booklist = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Books]
        }
        catch {
            print("Fetching Failed")
        }
        for i in 0..<booklist.count {
            if booklist[i].id! == titlename {
                count = i
                break
            }
        }
        print(count)
        let todo = booklist[count]
        if let title = todo.title{
            booktitle?.text = title
        }
        if let note = todo.note{
            booknote?.text = note
        }
        if let photo = todo.photo{
            bookphoto?.image = UIImage(data: photo)
        }
    }
    var img:UIImage = UIImage(named:"2.png")!

    @IBAction func share(sender: UIButton) {
        // 共有する項目
        let shareText = "わたしのお勧めする本は"+booktitle.text!+"です"
        let fugaStringURL:String = "http://amazon.jp/gp/search?ie=UTF8&keywords="+booktitle.text!
        let shareWebsite = NSURL(string:fugaStringURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
//        let shareImage = bookphoto.image!
            print("これはサンプルです")
            let activityItems = [shareText, shareWebsite!] as [Any]
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
     
        
    }


}
