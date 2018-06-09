//
//  ListView.swift
//  MyBooks
//
//  Created by 伊藤慶 on 2018/06/08.
//  Copyright © 2018年 伊藤慶. All rights reserved.
//

import UIKit
import CoreData
class ListView: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    var booklist:[Books] = []
    var searchBar = UISearchBar()
    var searchResults:[String] = []
    var titlename: String!
    var bo = true
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:42)
        searchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: 89)
        searchBar.searchBarStyle = UISearchBarStyle.default
        searchBar.showsSearchResultsButton = false
        searchBar.placeholder = "検索"
        searchBar.setValue("キャンセル", forKey: "_cancelButtonText")
        searchBar.tintColor = UIColor.red
        tableView.contentOffset = CGPoint(x: 0,y :42)
        tableView.tableHeaderView = searchBar
    }
    @IBAction func aaa(_ sender: Any) {
        if bo == true{
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.tableView.contentOffset = CGPoint(x: 0,y :0)
        },completion:nil);
            bo = false
        }else{
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                self.tableView.contentOffset = CGPoint(x: 0,y :42)
            },completion:nil);
            bo = true
        }
    }

    @IBAction func amazon(_ sender: Any) {
        let cell = (sender as AnyObject).superview??.superview as! UITableViewCell
        guard let row = self.tableView.indexPath(for: cell)?.row else {
            return
        }
        print(row)
        var search:String!
        if searchBar.text != "" {
            print(searchResults[row])
            search = searchResults[row]
        }else{
            print(booklist[row].title!)
            search = booklist[row].title!
        }
       
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
            tableView.reloadData()
        }
        catch {
            print("Fetching Failed")
        }
        print(self.booklist.count)

    }
    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "add", sender: nil)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add" {
            let nv = segue.destination as! Addlist
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

extension ListView: UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
  
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchBar.text != "" {
            titlename = searchResults[indexPath.row]
        }else{
        titlename = booklist[indexPath.row].title!
        }
        print("asdf")
        print(titlename)
        if titlename != "" {
            performSegue(withIdentifier: "add",sender: nil)
        }
        print(tableView.tag)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text != "" {
            return searchResults.count
        } else {
            return booklist.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell

        if searchBar.text != "" {
            let label1 = cell.viewWithTag(5) as! UILabel
            label1.text = searchResults[indexPath.row]
        } else {

            let imageView = cell.viewWithTag(4) as! UIImageView
            imageView.image = UIImage(data: booklist[indexPath.row].photo!)

            let label1 = cell.viewWithTag(5) as! UILabel
            label1.text = booklist[indexPath.row].title
            
            let fbutton = cell.viewWithTag(6) as! UIButton
            if booklist[indexPath.row].favorite == true {
                let bimage = UIImage(named:"star2") //
                fbutton.setBackgroundImage(bimage, for: .normal)
            }else{
                fbutton.setBackgroundImage(nil, for: .normal)
            }
            
        }
        return cell
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.showsCancelButton = true
        var book:[String] = []
        for i in 0..<booklist.count {
            book.append(booklist[i].title!)
        }
        self.searchResults = book.filter{
            // 大文字と小文字を区別せずに検索
            $0.lowercased().contains(searchBar.text!.lowercased())
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        searchBar.text = ""
        self.tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
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



