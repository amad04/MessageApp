import UIKit
import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class UserProfilInfo: UIViewController {
   
    @IBOutlet weak var label_fn: UILabel!
    
    @IBOutlet weak var label_ln: UILabel!
    
    @IBOutlet weak var label_email: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var imagePicker : UIImagePickerController!
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
        setUp()
        getUserData()
        getUserProfileImage()
        FireBaseModel.getUserData()
        
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector (changeImageButton(_:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        
       // profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2

        profileImageView.clipsToBounds = true
        
        
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
         // Do any additional setup after loading the view.
     }
    
    func setUp(){
          label_ln.alpha = 0
          label_fn.alpha = 0
          label_email.alpha = 0
      }
    
    
    func uploadProfileImage (_ image: UIImage, completion: @escaping ((_ url : URL?) ->    ())){
        
        
        let storageRef = Storage.storage().reference().child("profileImages").child("\(Auth.auth().currentUser!.uid).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.25) else {
            return
        }
            
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            
            if error == nil{
                
                storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                print ("Downloadurl in uploadProfileImage: " , url!)
                    // Uh-oh, an error occurred!
                  return
                }
                   /* if (downloadURL != nil) {
                    let ref = Database.database().reference()
                    let userId = Auth.auth().currentUser?.uid
                        //self.imageUrl = url!.absoluteString;
                        print("absoluteString", url?.absoluteString)
                        print("absoluteURL", url?.absoluteURL)
                        print ("ImageUrl", self.imageUrl)
                        /* ref.child("users").child(userId!).updateChildValues(["imageUrl" : url?.absoluteString]) */
                    }*/
            }
                print ("Kollar URL: ",storageRef.downloadURL)
            }
            else{
                print ("Somthink went wrong :/", error?.localizedDescription as Any)
            }
        }
    }
    
    
    func getUserData(){
        let currentUser = (Auth.auth().currentUser?.uid)!
        let dataRef = Database.database().reference()
        
        let user = dataRef.child("users").child(currentUser)
              
               
                   user.observe(.value) { (DataSnapshot) in
                       let userArray = DataSnapshot.value as? [String : Any]
                       
                       if let firstName = userArray?["firstname"] as? String,
                        let lastName = userArray? ["lastname"] as? String, let userEmail = userArray? ["mail"] as? String {
                                self.showUserData(firstName , lastName , userEmail )
                       
                            }
                    }
        }
    
    func getUserProfileImage () {
    
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
    let storageRef = Storage.storage().reference().child("profileImages").child("\(userID).jpg")
               
               
               //Storage.storage().reference().child("users/\(currentUser).png")
                      

           storageRef.getData(maxSize: 1000000 ) { data, error in
                      if let error = error {
                       print(" Error when downloading image: " , error.localizedDescription)
                      } else {
                       
                        // Data for "images/island.jpg" is returned
                      // print (data)
                        let image = UIImage(data: data!)
                       
                       self.profileImageView.image = image
                      }
                    }
    }
    func showUserData(_ fn: String, _ ln: String, _ em: String) {
     
         label_fn.text = "Firstname: " + fn
         label_fn.alpha = 1
         
         label_ln.text = "Lastname: " + ln
         label_ln.alpha = 1
         
         label_email.text = "Email: " + em
         label_email.alpha = 1
        profileImageView.startAnimating()
     }
    
    @IBAction func changeImageButton(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        let chatViewController =
            self.storyboard?.instantiateViewController(identifier: Constans.Storyboard.chatViewController)
        
        
        //Make it a Root page
        self.view.window?.rootViewController = chatViewController
        self.view.window?.makeKeyAndVisible()
    }
    


}

extension UserProfilInfo : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info [UIImagePickerController.InfoKey.editedImage] as? UIImage {
                  self.profileImageView.image = pickedImage
            
            uploadProfileImage(self.profileImageView.image!) { (url) in
                     if (url != nil){
                       //  print ("url är ", url?.absoluteString)
                     }
                 }
              }
        
              picker.dismiss(animated: true, completion: nil)
        
    }
      
    
    
}


// let myArray = [   "👽", "🐱", "🐔", "🐶", "🦊", "🐵", "🐼", "🐷", "💩", "🐰", "🤖", "🦄", "🐻", "🐲", "🦁", "💀", "🐨", "🐯", "👻", "🦖",]
