//
//  NewNoteViewController.swift
//  NoteBookSchool
//
//  Created by نجود  on 18/10/1443 AH.
//

import UIKit

class NewNoteViewController: UIViewController {

    // المتغير عشان اغير اسم الزر والنفقيشن ايتم
    var isCreation = true
    
    //عرفت متغير عشان لما اكون في شاشه التعديل يرسل العنوان والتفاصيل المكتوبه فيه قبل
    var editedNote : NoteBook?
    // متغير ايضا لابديت
    var editIndex : Int?
    
    
    @IBOutlet weak var newTitle: UITextField!
    
    @IBOutlet weak var newDetails: UITextView!
    
    
    @IBOutlet weak var changeNameButton: UIButton!
    
    @IBOutlet weak var imageNote: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if isCreation == false{
            
            changeNameButton.setTitle("Edit", for: .normal)
            
            navigationItem.title = "Edit Note"
            
            if let note = editedNote{
                newTitle.text = note.title
                
                newDetails.text = note.details
                
                imageNote.image = note.image
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeButton(_ sender: Any) {
        
    let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addButton(_ sender: Any) {
        if isCreation == true {
            
            // added
            let note = NoteBook(title: newTitle.text!, image: imageNote.image, details: newDetails.text)
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil , userInfo: ["addedTodo" : note])
        
            let alert = UIAlertController(title: "Done ", message: "successfull Added Note", preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
                self.tabBarController?.selectedIndex = 0
                
                
                
                // عندما اضيف المهمه وارجع ابغى اضيف مهمه ثانيه اخلي التكست فيلد فاضي مو مكتوب الكلام الي قبل
   
                
                self.newTitle.text = ""
                self.newDetails.text = ""

            })
            alert.addAction(closeAction)
            present(alert, animated: true, completion: nil)
            
            //عشان انتقل للصفحه عرض المهام بعد الظغط على الاليرت
          //  tabBarController?.selectedIndex = 0
            
            
            
        }else {
         // edit the current note 
            
            let note = NoteBook(title: newTitle.text!, image: imageNote.image, details: newDetails.text)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentEdited") , object: nil, userInfo: ["editedTodo": note , "editedIndex" : editIndex])
            
            
            let alert = UIAlertController(title: "Done Edited ", message: "successfull Edit Note", preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
                self.navigationController?.popViewController(animated: true)
                self.newTitle.text = ""
                self.newDetails.text = ""

            })
            alert.addAction(closeAction)
            present(alert, animated: true, completion: nil)
            
                
        }
        
    }
    
}

extension NewNoteViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
//  يتم استدعاء هذه الفانكشن اذا حدد المستخدم الصوره من البوم الكاميرا
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //عشان اوصل الى الصوره التي اختارها المستخدم استخدم البراميتر info وهو عباره عن دقشنري
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated: true, completion: nil)
        imageNote.image = image
    }
    
    
    
    
    
    
    
    
    
}









