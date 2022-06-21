//
//  NoteBookViewController.swift
//  NoteBookSchool
//
//  Created by نجود  on 20/09/1443 AH.
//

import UIKit
import CoreData

class NoteBookViewController: UIViewController {
    
    var noteArray : [NoteBook] = [
    
    ]
    
    
    @IBOutlet weak var noteBookTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // عشان ابني فانكشن للبيانات المحفوظه في core data
        
        self.noteArray =  getTodos()
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
            
            storeNota(todo: myNote)
        }
        print(noteArray.count)
      
      //  print(notification.userInfo?["addedTodo"])
        
    }
    @objc func currentEdited(notification : Notification){
        
        if let mynotes =  notification.userInfo?["editedTodo"] as? NoteBook{
            
            if let index = notification.userInfo?["editedIndex"] as? Int{
                
                noteArray[index] = mynotes
                noteBookTableView.reloadData()
                
                // استدعاء داله التعديل تبع core data
                
                updateNote(todo: mynotes, index: index)
            }
            
        }
       
        
        
    }
    @objc func deletedNote(notification : Notification){
        
        if let index =  notification.userInfo?["deletedIndex"] as? Int{
            
            
                
            noteArray.remove(at: index)
                noteBookTableView.reloadData()
           deleteTodo(index: index)
          
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
  //تحويل todo الى entity فقط ويحفظها في قاعده البيانات من دون عرضها في الشاشه .
    func storeNota(todo : NoteBook){
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    
        
        let mangeContext = appdelegate.persistentContainer.viewContext
        
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "NoteBooks", in: mangeContext) else { return  }
        
        let todoObject = NSManagedObject.init(entity: todoEntity, insertInto: mangeContext)
        // حفظ العنوان
        todoObject.setValue(todo.title, forKey: "title")
        // حفظ التفاصيل
        todoObject.setValue(todo.details, forKey: "details")
        
        
        //عشان احفظ التعديلات
       
        do{
       try mangeContext.save()
            
            print ("success,,,,,,,,,,,,,")
        }catch{
            
         print("error,,,,,,,,,,,,,,,,,")
            
            
        }
        
        
    }
    
   //لتعديل البيانات في core data
    func updateNote(todo : NoteBook , index : Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
         
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteBooks" )
        
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
        
           result[index].setValue(todo.title, forKey: "title")
            result[index].setValue(todo.details, forKey: "details")
            
            
            //ممكن استخدم do catch وكمان ممكن بس try  لاني بداخل do  اصلا
           try context.save()
         }catch{
             
            print ("error ,,,,,,,,,,,,,,,,,,,,,,")
             
         }
        }
    }
    
    
func deleteTodo( index : Int){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
     
    
    let context = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteBooks" )
    
    do{
        let result = try context.fetch(fetchRequest) as! [NSManagedObject]
    
       let todoDelete = result[index]
        context.delete(todoDelete)
        try context.save()
      }catch{
          
         print ("error ,,,,,,,,,,,,,,,,,,,,,,")
          
      }
     }
 
        
    
    
    
    
    //لعرض البيانات من core data
    func getTodos()-> [NoteBook]{
        
        var notes: [NoteBook] = []
        //عشان اوصل لقاعده البيانات اولا استخدم appdelegate
       guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return[]}
        
        let context = appDelegate.persistentContainer.viewContext
        //طلب دخول لقاعده البيانات وقراءه بيانات
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteBooks" )
        
        // عشان انفذ الطلب واعرضه
        do{
            //احول الريسلت الي شي اعرفه واستفيد منه الي هو nsmangeobject
           let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for mangeTodo in result{
                let title = mangeTodo.value(forKey: "title") as? String
              let details = mangeTodo.value(forKey: "details")  as? String
                
                let todo = NoteBook(title: title ?? "" , image: nil, details:  details ?? "")
                
                notes.append(todo)
            }
            
        }catch{
            
           print ("error ,,,,,,,,,,,,,,,,,,,,,,")
            
        }
        return notes
    }
    
    
    

