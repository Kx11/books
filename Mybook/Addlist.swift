//
//  Addlist.swift
//  MyBooks
//
//  Created by 伊藤慶 on 2018/06/08.
//  Copyright © 2018年 伊藤慶. All rights reserved.
//

import UIKit
import CoreData
class Addlist: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate{
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var booklist:[Books] = []
    @IBOutlet weak var booktitle: UITextField!
    @IBOutlet weak var booknote: UITextView!
    @IBOutlet weak var bookphoto: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var bookswitch: UISwitch!
    var count:Int!
    var titlename:String!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(titlename)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        booknote.delegate = self
        booktitle.delegate = self
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  //
        kbToolBar.sizeToFit()  //
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(tapOkButton(_:)))
        kbToolBar.items = [spacer, commitButton]
        booktitle.inputAccessoryView = kbToolBar
        booknote.inputAccessoryView = kbToolBar
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Books")
        do {
            booklist = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Books]
        }
        catch {
            print("Fetching Failed")
        }
        if titlename != nil
        {
            for i in 0..<booklist.count {
                if booklist[i].title! == titlename {
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
            bookswitch.isOn = todo.favorite
            button.setTitle("完了", for: .normal)
        }else{
            booknote.text = ""
            button.setTitle("登録", for: .normal) 
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func tapOkButton(_ sender: UIButton){
        pulldownView()
        self.view.endEditing(true)
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        UIView.animate(withDuration: 0.3, delay: 0, options:UIViewAnimationOptions(), animations: { () -> Void in
            let size = self.view.frame.size
            self.view.frame = CGRect(x: 0, y: -32, width: size.width, height: size.height)
            self.view.layoutIfNeeded()
        }, completion: { (finished:Bool) -> Void in
        })
        return true
    }
    @IBAction func deleteb(_ sender: Any) {
        if titlename != nil{
            let todo = booklist[count]
            context.delete(todo)
            booklist.remove(at: count)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onClickMySwicth(sender: UISwitch){
        if sender.isOn {
            bookswitch.isOn = true
        }else {
            bookswitch.isOn = false
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: Any) {
        print(self.booklist.count)
        if booktitle.text != "" && bookphoto.image !=  nil{
            if count == nil{
                
                let todo = Books(context: self.context)
                
                todo.title = booktitle.text
                if booknote.text != ""{
                    todo.note = booknote.text
                }
                todo.photo = UIImageJPEGRepresentation(bookphoto.image!, 1.0)! as Data
                todo.favorite = bookswitch.isOn
                todo.id = randomString(length: 15)
                
                self.booklist.append(todo)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                print(self.booklist.count)
                self.dismiss(animated: true, completion: nil)
            }else{
                
                let todo = booklist[count]
                if booktitle.text != "" {
                    todo.title = booktitle.text
                }
                if booknote.text != ""{
                    todo.note = booknote.text
                }
                todo.photo = UIImageJPEGRepresentation(bookphoto.image!, 1.0)! as Data
                todo.favorite = bookswitch.isOn
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            let alertController:UIAlertController =
                UIAlertController(title:"本のタイトルを入力してください",
                                  message: "",
                                  preferredStyle: .alert)
            let cancelAction:UIAlertAction =
                UIAlertAction(title: "ok",
                              style: .cancel,
                              handler:{
                                (action:UIAlertAction!) -> Void in
                })
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if touch.view?.tag == 10 {
            let alertController:UIAlertController =
                UIAlertController(title:"画像選択",
                                  message: nil,
                                  preferredStyle: .alert)
            let defaultAction:UIAlertAction =
                UIAlertAction(title: "カメラ",
                              style: .default,
                              handler:{
                                (action:UIAlertAction!) -> Void in
                                self.camera()
                })
            
            let destructiveAction:UIAlertAction =
                UIAlertAction(title: "アルバム",
                              style: .default,
                              handler:{
                                (action:UIAlertAction!) -> Void in
                                self.library()
                })
            let cancelAction:UIAlertAction =
                UIAlertAction(title: "キャンセル",
                              style: .cancel,
                              handler:{
                                (action:UIAlertAction!) -> Void in
                })
            
            alertController.addAction(cancelAction)
            alertController.addAction(defaultAction)
            alertController.addAction(destructiveAction)
            present(alertController, animated: true, completion: nil)
            
            
        }
        view.endEditing(true)
        pulldownView()
        
    }

    func pulldownView(){
        if self.view.frame.origin != CGPoint(x: 0 , y:0){
            let size = self.view.frame.size
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
                self.view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                self.view.layoutIfNeeded()
            }) { (finished:Bool) -> Void in
            }
        }
    }
    func camera(){
        let sourceType:UIImagePickerControllerSourceType =
            UIImagePickerControllerSourceType.camera

        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera){

            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
        else{
            let alertController:UIAlertController =
                UIAlertController(title:"カメラが起動できませんでした",
                                  message: "",
                                  preferredStyle: .alert)
            let cancelAction:UIAlertAction =
                UIAlertAction(title: "ok",
                              style: .cancel,
                              handler:{
                                (action:UIAlertAction!) -> Void in
                })
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    func llibrary(){
        
    }
    //    //　撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage]
            as? UIImage {
            bookphoto.image = pickedImage
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func library(){
        let sourceType:UIImagePickerControllerSourceType =
            UIImagePickerControllerSourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable (
            UIImagePickerControllerSourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
        else{
            
        }
    }
    
}
