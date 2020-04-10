import UIKit
import FirebaseStorage
import FirebaseAuth
class HomeCellViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var cellProfileImage: UIImageView!
    
    @IBOutlet weak var cellUserName: UILabel!
    
    @IBOutlet weak var cellUserMessage: UILabel!
    
    @IBOutlet weak var cellMessageDate: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       // cellProfileImage.layer.cornerRadius = 10
              
        cellProfileImage.layer.cornerRadius = cellProfileImage.frame.size.width/2
        
        cellProfileImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell (chat : Chat){
     //   print ("Image: ", chat.image)
        //cellProfileImage.image = chat.image
        if (chat.senderId != nil){
            cellUserName.text = chat.senderName
            cellUserMessage.text = chat.lastMessage
            cellMessageDate.text = chat.messagedate
            getUserProfileImage(userID: chat.senderId!, imageView: cellProfileImage)
          
                   //cellUserMessage.text = chat.chatId
        }
        
        else {
            cellUserName.text = chat.receiverName
            cellUserMessage.text = chat.lastMessage 
            cellMessageDate.text = chat.messagedate
            getUserProfileImage(userID: chat.receiverId!, imageView: cellProfileImage)
                   //cellUserMessage.text = chat.chatId
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
