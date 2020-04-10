import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseStorage


class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userProfileImage: UIImageView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    var imagePicker : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector (changeProfileImageTapped))
        userProfileImage.isUserInteractionEnabled = true
        userProfileImage.addGestureRecognizer(imageTap)
        userProfileImage.layer.cornerRadius = userProfileImage.frame.size.width/2
        
        
        
        userProfileImage.clipsToBounds = true
        
        
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    @IBAction func changeProfileImageTapped(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ emailTextField: UITextField) -> Bool {
              self.view.endEditing(true)
             // sendButtonTapped(messageTextField.text!)
              return true
       }
    
    func setUpElements() {
        errorLabel.alpha = 0
        
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleFilledButton(signUpButton)
        
        
    }

    func validateFields() -> String?{
        
        if firstNameTextField.text?.trimmingCharacters (in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            showAlert ("Please fill in all fields")
        }
        
        let cleanpassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanpassword) == false {
            
           // showAlert ("Pleace make sure the password is at least 8 characters, contain a speical charcter and a number")
        }
        return nil
    }
    
    //Allert funktion som tar emot ett error-meddelande
   func showAlert(_ error : String){
          
         let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
             
             alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                  NSLog("The \"OK\" alert occured.")
                  }))
         
            self.present(alert, animated: true, completion: nil)
    }
  
    
    @IBAction func signUpTapped(_ sender: Any) {
     

        
        let error = validateFields()
        
        if let e = error {
            
            showAlert(e)
        }
        
        else {
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            if Auth.auth().currentUser?.email == email {

                self.showAlert("Error creating the user")
            }
            
            else {
                
                
          
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    self.showAlert("User with email: " + email + " is already exist")
                    
                }
                else {
                    
                    guard let userId = Auth.auth().currentUser?.uid else {
                        return
                        
                    }
                   
                 
                    
                    let reference = Database.database().reference()
                    
                    let userdetails = reference.child("users").child(userId)
                    userdetails.setValue(["firstname" : firstName, "lastname" : lastName, "mail" : email, "userId" : userId]) { (error: Error?, ref: DatabaseReference) in
                        if error != nil {
                          //  print ("Problem med att lagra userinfo")
                            self.showAlert(error!.localizedDescription)
                        }
                        else{
                            print ("Anvädarinfo har sparats!")
                            
                            
                            
                        }
                        
                        
                    }
             
                    self.saveFirData()
                    self.transitionToHome()
                   
                }
            }
        }
                          
            
    }        //Validate the fields
}  //Create the user
        //Transition to HomeScreen
    
   /*func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }*/
    
  
    
    func saveFirData(){
        self.uploadProfileImage(self.userProfileImage.image!) { (url) in
            if (url == nil){
                print ("url är null ", url!)
            }
            
            self.saveImage(profileURL: url!) { success in
                if (success != nil){
                    print ("Fungerar")
                }
                else{
                    print ("Något fel, verkar som om metoden inte anropas!")
                }
                
            }
        
        }
       
    }
    
    func uploadProfileImage (_ image: UIImage, completion: @escaping ((_ url : URL?) ->	())){
        
        
        let storageRef = Storage.storage().reference().child("profileImages").child("\(Auth.auth().currentUser!.uid).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.25) else {
            return
        }
            
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            
            if error == nil{
                
                storageRef.downloadURL { (url, error) in
                    guard url != nil else {
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
            }
            else{
                print ("Something went wrong :/", error?.localizedDescription as Any)
            }
        }
    }
    //Lägger till en länk till imageurl och sparar den till under användarens info
    func saveImage(profileURL : URL, completion: @escaping ((_ url : URL?) ->())){
        
        let curretUser = Auth.auth().currentUser?.uid
        let userRef = Database.database().reference().child("users").child(curretUser!)
        userRef.updateChildValues(["imageURL" : profileURL.absoluteString] as [String : Any])
        print("ProfileURL in SaveImage" , profileURL.absoluteString)
        
    }
    
    func transitionToHome() {
         
        /*let chatViewController =
                     self.storyboard?.instantiateViewController(identifier: Constans.Storyboard.chatViewController)
                 
                 
                 //Make it a Root page
                 self.view.window?.rootViewController = chatViewController
                 self.view.window?.makeKeyAndVisible()
        */
       let chatViewController = storyboard?.instantiateViewController(identifier: Constans.Storyboard.chatViewController) 
        
        //Make it a Root page
        view.window?.rootViewController = chatViewController
        view.window?.makeKeyAndVisible()
    }
    
    
}

extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
     
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info [UIImagePickerController.InfoKey.editedImage] as? UIImage {
                  self.userProfileImage.image = pickedImage
              }
              picker.dismiss(animated: true, completion: nil)
        
    }
      
    
    
}
