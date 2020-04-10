import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var button_userProfileInfo: UINavigationItem!
    
    
    
    @IBOutlet weak var chatTable: UITableView!
    
    var chats = [Chat]()
    var getImg = UIImage.init()
    
    @IBOutlet weak var chatNameTextField: UITextField!
    
    
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        observeMyChats()
        chatTable.reloadData()
        self.chatTable.backgroundView = UIImageView(image: UIImage(named: "Background"))
        
        self.chatTable.delegate = self
        self.chatTable.dataSource = self
        self.chats.removeAll()
        
           
           // Do any additional setup after loading the view.
       }
    //Observerar alla rum som finns/skapas i db
  /* func observeChat() {
        let databaseRef = Database.database().reference()
        databaseRef.child("rooms").observe(.childAdded) { (snapshot) in
            if let dataArray = snapshot.value as? [String: Any] {
                if let roomName = dataArray ["roomName"] as? String {
                    let room = Chat.init(chatId: snapshot.key, roomName: roomName)
                    self.chats.append(room)
                    self.chatTable.reloadData()
                }
            }
        }
    }*/
    
    
    //Observerar alla mina rum(chatter) som finns/skapas i db
    func observeMyChats(){
         navigationBarTitle.title = "Chattar"
        var chatID = ""
         let databaseRef = Database.database().reference()
       
        databaseRef.child("users").child(FireBaseModel.currentUserId()).child("mychatrooms").observe(.childAdded) { (snapshot) in
             if let dataArray = snapshot.value as? [String: Any]
                 {  let messageDate = dataArray ["messageDate"] as? String
                    let lastMessage = dataArray ["lastMessage"] as? String
                    let receiverName = dataArray ["receiverName"] as? String
                    let receiverId = dataArray ["receiverId"] as? String
                    let chatCreatedBy = dataArray ["chatCreatedBy"] as? String
                    chatID = snapshot.key
                    
                    let senderId = dataArray ["senderId"] as? String
                    let senderName = dataArray ["senderName"] as? String
                                  
                    if (FireBaseModel.currentUserId() != receiverId){
              /* Tar chatID som parameter och returnerar sista meddealndet i chatten */
                   
                    let chat = Chat.init(chatId: snapshot.key, receiverName: receiverName, receiverId: receiverId, lastMessage: lastMessage, messagedate: messageDate)
                    //print ("ChatID är: " , snapshot.key)
                    self.chats.append(chat)
                    self.chatTable.reloadData()
                  
                    }
                    else{
                        
                        let chat = Chat.init(chatId: snapshot.key, receiverId: receiverId,senderName: senderName, senderId: senderId, lastMessage: lastMessage, messagedate: messageDate)
                        //print ("ChatID är: " , snapshot.key)
                        self.chats.append(chat)
                        self.chatTable.reloadData()
                                        
                    
                    }
             
           // print ("chatID är:      ", chatID)
        }
        }
     }
   
    
    func getSenderInfo(){
        let databaseRef = Database.database().reference()
            let currentUserId = (Auth.auth().currentUser?.uid)!
        
            let user = databaseRef.child("users").child(currentUserId)
        user.observeSingleEvent(of: .value) { (dataSnapshot) in
           
                let userArray = dataSnapshot.value as? [String : Any]
                if let firstName = userArray?["firstname"] as? String,
                    let lastName = userArray? ["lastname"] as? String {
                    return _ = firstName + " " + lastName
                }
        }
    }
    
    func observeAllContacts() {
        navigationBarTitle.title = "All Contacts"
            let databaseRef = Database.database().reference()
            let currentUserId = (Auth.auth().currentUser?.uid)!
        
           databaseRef.child("users").observe(.childAdded) { (snapshot) in
                if let dataArray = snapshot.value as? [String: Any] {
                    if let receiverName = dataArray ["firstname"] as? String,
                        let lastname = dataArray ["lastname"]
                        as? String, let receiverId = dataArray ["userId"]
                        as? String  {
                        // den inloggade kommer inte vara med på listan alla användare
                        let receiverFullName = receiverName + " " + lastname
                        if (currentUserId != snapshot.key){
                            
                        let receiverAndCurrentUserId = snapshot.key + currentUserId
                            let room = Chat.init(chatId: receiverAndCurrentUserId, receiverName: receiverFullName, receiverId: receiverId, senderName: "", image: self.getImg)
                        self.chats.append(room)
                        self.chatTable.reloadData()
                      
                     }
                    }
                }
            }
        }
  
    
       
    override func viewDidAppear(_ animated: Bool) {
        if (FireBaseModel.currentUserId() == "") {
            openLoginView()
        }
        
    }
  
//Går in på den valda chatten
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatSelected = self.chats[indexPath.row]
        let chatView = self.storyboard?.instantiateViewController(identifier: "ChatView") as! ChatViewController
        
        chatView.chat = chatSelected
        self.navigationController?.pushViewController(chatView, animated: true)
    }
    //höjden till cellen
   func tableView(_ tableView: UITableView,
    heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "ChatCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! HomeCellViewControllerTableViewCell
                   
               
        let chat = self.chats[indexPath.row]
        
        cell.setCell(chat: chat)
        return cell
    }
    
    func openLoginView(){
      let loginView = self.storyboard?.instantiateViewController(identifier: Constans.Storyboard.loginView) as? ViewController
                 
             self.view.window?.rootViewController = loginView
             self.view.window?.makeKeyAndVisible()
      }
    

    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        

        func SignOutUser (){
            let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
               
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
        }; openLoginView()
        
    }
    
    

    @IBAction func userProfileButtonTapped(_ sender: Any) {
        
        let userInfoViewController = self.storyboard?.instantiateViewController(identifier: Constans.Storyboard.userProfileInfo) as? UserProfilInfo
            
        self.view.window?.rootViewController = userInfoViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func chatsButtonTaped(_ sender: Any) {
        observeMyChats()
        self.chats.removeAll()
    }
    
    @IBAction func contactsButtonTapped(_ sender: Any) {
        observeAllContacts()
        self.chats.removeAll()

    }
    
    
    @IBAction func createChatButtonTapped(_ sender: Any) {
        
        guard let chatTextFiled = self.chatNameTextField.text, self.chatNameTextField.text?.isEmpty == false else {
            return
        }
        let userId = Auth.auth().currentUser?.uid
        
        let databaseRef = Database.database().reference()
        
        let addChatToUser = databaseRef.child("users").child(userId!)
        
       
        let room = databaseRef.child("rooms").childByAutoId()
       
        let dataArray : [String : Any ] = ["roomName" : chatTextFiled ]
        print (dataArray["roomname"] as Any)
        room.setValue(dataArray) { (Error, DatabaseReference) in
            
            if (Error == nil){
                self.chatNameTextField.text = ""
                addChatToUser.child("mychatrooms").childByAutoId().setValue(["chatroomId" : room.key, "roomname" : chatTextFiled])
            }
            
            else {
                print ("Couldn't creathe the Chat")
            }
        }
        
        
        
    }
    
}
