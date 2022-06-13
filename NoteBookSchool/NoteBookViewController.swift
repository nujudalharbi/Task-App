//
//  NoteBookViewController.swift
//  NoteBookSchool
//
//  Created by نجود  on 20/09/1443 AH.
//

import UIKit

class NoteBookViewController: UIViewController {
    
    var noteArray = [
        NoteBook(title: "......" , image: UIImage(named: "Image-1") , details: "........................"),
        NoteBook(title: "..,,,," , image: UIImage(named: "Image-2") , details: ",,,,,,,,,,,,,,,,,,,,,,"),
        NoteBook(title: "/////" , image: UIImage(named: "Image-3")),
        NoteBook(title: "mmmmm" , image: UIImage(named: "Image-4"))
    
    ]
    
    
    @IBOutlet weak var noteBookTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // استقبال الاشعار الذي ارسلته من داله postللاضافه
//      new note
        NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdded), name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil)
        
        
       
        //ارسال اشعار للتعديل
//       edit note
        NotificationCenter.default.addObserver( self , selector: #selector(currentEdited), name: NSNotification.Name(rawValue: "CurrentEdited"), object: nil)
        
        
//        delete note
        NotificationCenter.default.addObserver( self , selector: #selector(deletedNote), name: NSNotification.Name(rawValue: "deletedNote"), object: nil)
        
        noteBookTableView.dataSource = self
        noteBookTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @objc func newTodoAdded(notification: Notification){
        var note = notification.userInfo?["addedTodo"] as? NoteBook
        if let myNote = note{
            
            noteArray.append(myNote)
            noteBookTableView.reloadData()
        }
        print(noteArray.count)
      
      //  print(notification.userInfo?["addedTodo"])
        
    }
    @objc func currentEdited(notification : Notification){
        
        if let mynotes =  notification.userInfo?["editedTodo"] as? NoteBook{
            
            if let index = notification.userInfo?["editedIndex"] as? Int{
                
                noteArray[index] = mynotes
                noteBookTableView.reloadData()
            }
            
        }
       
        
        
    }
    @objc func deletedNote(notification : Notification){
        
        if let index =  notification.userInfo?["deletedIndex"] as? Int{
            
            
                
            noteArray.remove(at: index)
                noteBookTableView.reloadData()
           
            
        }
       
        
        
    }
}


extension NoteBookViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"NoteID" ) as! NoteBookCell
    
        
        cell.noteTitleLable.text = noteArray[indexPath.row].title
        
        
        if noteArray[indexPath.row].image != nil {
            
            cell.noteImage.image = noteArray[indexPath.row].image
            
        }else{
            
            cell.noteImage.image = UIImage(named: "Image-4")
            
        }
        
        cell.noteImage.layer.cornerRadius = cell.noteImage.frame.width / 2
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        يخفي التظليل في خليه التيبل فيو
        noteBookTableView.deselectRow(at: indexPath, animated: true)
        
        
        let note = noteArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsID") as? DetailsNoteViewController
        if let viewController = vc {
            
        
            viewController.notes = note
            // عملت مساواه المتغير اندكس بالاندكس باث عشان الاب ديت ويكون في نفس الخليه التغيير
            viewController.index = indexPath.row
            
            navigationController?.pushViewController(viewController, animated: true)
        }}
    
    
}
