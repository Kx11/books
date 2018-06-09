//
//  favoritelist.swift
//  MyBooks
//
//  Created by 伊藤慶 on 2018/06/09.
//  Copyright © 2018年 伊藤慶. All rights reserved.
//

import UIKit
import CoreData

class favoritelist: UIViewController {

    var searchResults:[String] = []
    var idResults:[String] = []
    var titlename: String!
    @IBOutlet weak var tableView: UITableView!
    var booklist:[Books] = []
    var bo = true
    var fcount:Int = 0
    var counts:Int = 0
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentOffset = CGPoint(x: 0,y :42)
    }
 
    
    @IBAction func amazon(_ sender: Any) {
        let cell = (sender as AnyObject).superview??.superview as! UITableViewCell
        guard let row = self.tableView.indexPath(for: cell)?.row else {
            return
        }
        print(row)
        var search:String!
       
            print(booklist[row].title!)
            search = booklist[row].title!
        
        let fugaStringURL:String = "http://amazon.jp/gp/search?ie=UTF8&keywords="+search
        let url = NSURL(string:fugaStringURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url! as URL)
        } else {
            UIApplication.shared.openURL(url! as URL)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Books")
        do {
            booklist = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Books]
        }
        catch {
            print("Fetching Failed")
        }
        print(self.booklist.count)
        fcount = 0
        idResults.removeAll()
        for i in 0..<booklist.count {
            if booklist[i].favorite == true{
                fcount = fcount + 1
                print(booklist[i].id!)
                print(booklist[i].title!)
                idResults.append(booklist[i].id!)
            }
        }
        tableView.reloadData()
    }
    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "adds", sender: nil)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adds" {
            let nv = segue.destination as! favoritebook
            if  let indexPath = self.tableView.indexPathForSelectedRow {
                print(indexPath)
                nv.titlename = titlename
            }else{
                nv.titlename = nil
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if touch.view?.tag == 10 {
            print("asdf")
        }
    }
    
}

extension favoritelist: UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
            titlename = idResults[indexPath.row]
        
        print("asdf")
        print(titlename)
        if titlename != "" {
            performSegue(withIdentifier: "adds",sender: nil)
        }
        print(tableView.tag)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            print(booklist.count)
            return fcount
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
       
            print(indexPath.row)
            for ic in 0..<booklist.count {
            if idResults[indexPath.row] == booklist[ic].id {
                print(booklist[ic].id!)
                print(idResults[indexPath.row])
                print(booklist[ic].title!)
            let imageView = cell.viewWithTag(4) as! UIImageView
            imageView.image = UIImage(data: booklist[ic].photo!)
            let label1 = cell.viewWithTag(5) as! UILabel
            label1.text = booklist[ic].title
            
            let fbutton = cell.viewWithTag(6) as! UIButton
            let bimage = UIImage(named:"star2") //
            fbutton.setBackgroundImage(bimage, for: .normal)
                break
            
        }
            
        }
        return cell
    }
 
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let todo = booklist[indexPath.row]
            context.delete(todo)
            booklist.remove(at: indexPath.row)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        tableView.reloadData()
    }
}

