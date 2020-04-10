import UIKit
import FirebaseAuth
import SwiftUI

class LogInViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    
    @IBOutlet weak var signinButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        emailTextField.delegate = self
        passWordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passWordTextField)
        
        Utilities.styleFilledButton(signinButton)
        
    }
    
    func textFieldShouldReturn(_ emailTextField: UITextField) -> Bool {
           self.view.endEditing(true)
          // sendButtonTapped(messageTextField.text!)
           return true
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func signinButtonTapped(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passWordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (resualt, error) in
            
            if error != nil {
                
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                
                
               // self.errorLabel.text = error!.localizedDescription
               // self.errorLabel.alpha = 1
            }
            
            else {
                print ("Inloggad!!!")
                

                let chatViewController =
                    self.storyboard?.instantiateViewController(identifier: Constans.Storyboard.chatViewController)
                
                
                //Make it a Root page
                self.view.window?.rootViewController = chatViewController
                self.view.window?.makeKeyAndVisible()
                    
                
               /* let homeViewController =
                    
                    self.storyboard?.instantiateViewController(identifier: Constans.Storyboard.homeViewController) as? HomeViewController
               
                //Make it a Root page
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()*/
                
            }
        }
    }
}
