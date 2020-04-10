import UIKit
import FirebaseStorage
import Firebase

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var chatTextfield: UITextView!
    
   
    @IBOutlet weak var bubbleStackView: UIStackView!
    
    @IBOutlet weak var insideBubbleStackView: UIStackView!
    
    @IBOutlet weak var chatTextBubble: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chatTextBubble.layer.cornerRadius = 8
        
        userProfileImage.layer.cornerRadius = userProfileImage.frame.size.width/2
        userProfileImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    enum bubbleType {
        case incoming
        case outgoing
    }
    
    func setMessageData (message : Message){
        usernameLabel.text = message.senderName
        chatTextfield.text = message.senderMessage
        
        getUserProfileImage(userID: message.senderId!, imageView: userProfileImage)
    }
    
    func setBubbleRightOrLeft (type: bubbleType){
        if (type == .incoming) {
            bubbleStackView.alignment = .leading
            chatTextBubble.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            chatTextfield.textColor = .black
        insideBubbleStackView.addArrangedSubview(self.insideBubbleStackView.subviews[1])
           // userProfileImage.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            
        }
        else if (type == .outgoing) {
            bubbleStackView.alignment = .trailing
        insideBubbleStackView.addArrangedSubview(self.insideBubbleStackView.subviews[0])
            chatTextBubble.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            chatTextfield.textColor = .white
            
            
            
        }
    }
    
    func getUserProfileImage (userID: String, imageView: UIImageView) {
           
        let storageRef = Storage.storage().reference().child("profileImages").child("\(userID).jpg")
                   
               storageRef.getData(maxSize: 1000000 ) { data, error in
                          if let error = error {
                           print(" Error when downloading image: " , error.localizedDescription)
                          } else {
                           
                            // Data for "images/island.jpg" is returned
                           print (data!)
                            let image = UIImage(data: data!)
                           
                           imageView.image = image
                          }
                        }
        }


}
