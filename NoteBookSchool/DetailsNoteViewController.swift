//
//  DetailsNoteViewController.swift
//  NoteBookSchool
//
//  Created by نجود  on 13/10/1443 AH.
//

import UIKit

class DetailsNoteViewController: UIViewController {
      
    var notes  : NoteBook!
    // متفير عشان التعديل (الاب ديت)
    var index : Int!
    
    @IBOutlet weak var imageDetails: UIImageView!
    @IBOutlet weak var titleDetails: UILabel!
    
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        if notes.image != nil {
            
            imageDetails.image = notes.image
        }else{
            imageDetails.image = UIImage(named: "Image-4")
            
            
        }
        
        
       setupUI()
        // Do any additional setup after loading the view.
        
        
        NotificationCenter.default.addObserver( self , selector: #selector(currentEdited), name: NSNotification.Name(rawValue: "CurrentEdited"), object: nil)
        
    }
    
    
    @objc func currentEdited(notification : Notification){
        
        if let mynotes =  notification.userInfo?["editedTodo"] as? NoteBook{
          
                
            self.notes = mynotes
            setupUI()
        }
       
        
        
    }
    
    
    func setupUI(){
        
         titleDetails.text = notes.title
         detailsLabel.text = notes.details
        
        
    }
    
    
    
    
    
    

    @IBAction func editButton(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "new&edit") as? NewNoteViewController
        
        if let viewController = vc {   navigationController?.pushViewController( viewController , animated: true)
            
            
            //لان استخدممت نفس شاشه الاضافة في التعديل فيلزم تغيير اسم الزر من اضافة الى تعديل الطريقه اعرف متغير في شاشه التفاصيل isCreation اذا كان خطا فالمعنى انو جاي من شاشه التعديل 
            viewController.isCreation = false
            // هينا عشان اعبي وارسل نفس المعلومات الموجوده في النوت الى الشاشه الثانيه وتكون نفسها
            viewController.editedNote = notes
            
            viewController.editIndex = index
        }
     
        
        
    }
    

    @IBAction func deleteButton(_ sender: Any) {
        let confirmAlert = UIAlertController(title: "Attention", message: "Ara you sure you want to delete the note ??", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "sure delete", style: .destructive, handler: {
            alert in
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deletedNote"), object: nil, userInfo: ["deletedIndex": self.index])
            
            let alert = UIAlertController(title: "done", message: "done of delete successfull", preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "done", style: .default,  handler: { alert in
                self.navigationController?.popViewController(animated: true)
            })
            
            alert.addAction(closeAction)
            self.present(alert, animated: true, completion: nil)
        })
        
        confirmAlert.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "cancel", style: .default, handler: nil)
        confirmAlert.addAction(cancelAction)
        
        present(confirmAlert, animated: true, completion: nil)
       
    
    }
}
