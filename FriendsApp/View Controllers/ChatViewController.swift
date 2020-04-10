//
//  ChatViewController.swift
//  FriendsApp
//
//  Created by Amad Walid on 2019-12-17.
//  Copyright © 2019 Amad Walid. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var messageTextField: UITextField!
    
    // to store the current active textfield
    var activeTextField : UITextField? = nil
    
    var chat : Chat?
    var chatMessages = [Message]()
    var lastMessage = ""
    var currentDate = ""
    
    
 
    @IBOutlet weak var chatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           
           NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
         
        messageTextField.delegate = self
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        chatTableView.allowsSelection = false
        observeMessages()
      
        if (chat?.receiverName != nil) {
            self.navigationItem.title = chat?.receiverName

        }
            
        else {
            self.navigationItem.title = chat?.senderName
            print ("Detta är null")
         }
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "person.badge.plus"), style: .plain, target: self, action: #selector(addButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
     
        /*getUserNameWithId(id: Auth.auth().currentUser!.uid) { (userName) in
        
        }*/
        // Do any additional setup after loading the view.
    }
    
  @objc func keyboardWillShow(notification: NSNotification) {
          

     if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
       
        print (self.view.frame.origin.y)
        
        if ( self.view.frame.origin.y >= 88 )  {
                // move the root view up by the distance of keyboard height
            print ("Gick ", self.view.frame.origin.y)
            print ("Keyboard ", keyboardSize.height)
            self.view.frame.origin.y -= keyboardSize.height - 40
            print ("Gick upp", self.view.frame.origin.y)
        }
        
        if (self.view.frame.origin.y <= 87 && self.view.frame.origin.y >= 60 ){
            print ("Inne på else", self.view.frame.origin.y)
             self.view.frame.origin.y -= keyboardSize.height
        }
        
        
         // if keyboard size is not available for some reason, dont do anything
      }
  }
    
    @objc func keyboardWillHide(notification: NSNotification) {
    // move back the root view origin to zero
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print ("Gick ner", self.view.frame.origin.y)
            
            if ( self.view.frame.origin.y <= -208  )  {
                self.view.frame.origin.y +=  keyboardSize.height - 40
                print ("Neutralläge", self.view.frame.origin.y)

            
    }
            else {
                self.view.frame.origin.y +=  keyboardSize.height
            }
    }
  }
    
    func textFieldShouldReturn(_ messageTextField: UITextField) -> Bool {
        self.view.endEditing(true)
        sendButtonTapped(messageTextField.text!)
        return true
    }
    
    
   
    @objc func addButtonTapped(_ sender: Any) {
        print("Funkar!!!!!")
    }
    
    //Observerar alla meddelanden som kommer in i db  presntera det i tableChattViewCell
    func observeMessages() {
        guard let chatId = self.chat?.chatId else{
            return
        }
        
        let dataRef = Database.database().reference()
         dataRef.child("rooms").child(chatId).child("messages").observe(.childAdded) { (DataSnapshot) in
            if let messageArray = DataSnapshot.value as? [String: Any] {
               
                
                guard let senderName = messageArray["senderName"] as? String, let senderMessage = messageArray["message"] as? String, let senderId = messageArray ["senderId"] as? String else {
                        return
                    }
                print (DataSnapshot)
                let message = Message.init(messageKey: DataSnapshot.key, senderName: senderName, senderMessage: senderMessage, senderId: senderId)
                self.chatMessages.append(message)
                self.scrollToBottom()
                self.chatTableView.reloadData()
            }
        }
       
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print(chatMessages.count)
        return chatMessages.count
      }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
        let message = self.chatMessages[indexPath.row]
        
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatTableViewCell
        
        cell.setMessageData(message: message)
    
        
        if (message.senderId == Auth.auth().currentUser!.uid){
           cell.setBubbleRightOrLeft(type: .outgoing)
        }
         else { cell.setBubbleRightOrLeft(type: .incoming)
         }
        return cell
      }
    
    // Scrollar till sista meddealndet i chatten
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatMessages.count-1, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
   /* func getUserNameWithId (id : String, completion: @escaping (_ userName: String?) -> () ){
       
        
            let dataRef = Database.database().reference()
            let user = dataRef.child("users").child(id)
            
        
        user.child("firstname").observeSingleEvent(of: .value, with: { (DataSnapshot) in
            if let userName = DataSnapshot.value as? String{
                completion(userName)
            }
            else{
                completion(nil)
            }
                
        })
    }*/
    
    
    
    func sendMessage (textMessage: String, completion: @escaping (_ isSuccess: Bool) -> () ){
            
            guard let currentUser = Auth.auth().currentUser?.uid else {
                return
            }
        
            let dataRef = Database.database().reference()
            let senderUser = dataRef.child("users").child(currentUser)
            
        
   
      
        func getLastMessage(receiverAndCurrentUserId: String) {
            let receiverAndCurrentUserId = receiverAndCurrentUserId
            
            let ref = Database.database().reference()
            ref.child("rooms").child(receiverAndCurrentUserId).child("messages").queryLimited(toLast: 1)
                .observe(.childAdded) { (snapshot) in
                    if let dataArray = snapshot.value as? [String: Any] {
                        self.lastMessage = dataArray ["message"] as! String
                      
                        //print ("Sista meddelandet är: " ,self.lastMessage)
                
                }
                 
                
            }
     
   
        }
        
        senderUser.observeSingleEvent(of: .value, with: { (DataSnapshot) in
        
                let userArray = DataSnapshot.value as? [String : Any]
                
                if let firstname = userArray?["firstname"] as? String,
                 let lastname = userArray? ["lastname"] as? String, let userID = Auth.auth().currentUser?.uid {
                    let senderName = firstname + " "+lastname
                    let messageArray: [String: Any] = ["senderName" : senderName, "message" : textMessage, "senderId" : userID]
                    //Sparar mottagarensid till chatten för att sedan lägger till chatten till mottageren också
                    var receiverUserId = self.chat?.receiverId
                    
                    //när en inloggad user får ett meddealnde från någon annan kommer receiverUserId vara nil då det finns en chat som är redan aktiv mellan dessa 2, vi lägger därför den inloggade användarens id som receiver ifall då det redan finns aktiv chatt mellan dessa 2 användare
                    if receiverUserId == nil {
                        receiverUserId = Auth.auth().currentUser?.uid
                    }
                    
                    let receiverUser = dataRef.child("users").child(receiverUserId!)
                    
                  //  let senderAndReceiverId = currentUser + receiverUserId!
                                                    
                    
                   
                    if let chatId = self.chat?.chatId {
                        let currentChat = dataRef.child("rooms").child(chatId)
                     getLastMessage(receiverAndCurrentUserId: chatId)
                       /*Lägger till messages i valda rummet*/ currentChat.child("messages").childByAutoId().setValue(messageArray) { (Error, DatabaseReference) in
                            if Error == nil {
                                completion (true)
                                print ("Message added to DB")
                                self.messageTextField.text = ""
                                
                                
                                
                                
                        
                         
                               /* Lägger till den skapde chatten till användaren som har skickat meddelandet   user.child("mychatrooms").child(chatId).setValue(["chatroomId" : chatId, "roomname" : self.chat?.roomName])*/
                                                     
                                
                                
                               /* Lägger till varje meddealnde under ett specifiktrum som har ett rumid som består av sendarens och mottagerensid
                                */
                              
                                senderUser.child("mychatrooms").child(chatId).setValue(["chatroomId" : chatId, "receiverName" : self.chat?.receiverName, "receiverId" : self.chat?.receiverId, "senderName" : senderName, "senderId" : currentUser, "lastMessage" : self.lastMessage, "messageDate" : self.currentDate ])
                                                               
                                receiverUser.child("mychatrooms").child(chatId).setValue(["chatroomId" : chatId, "senderName" : senderName, "senderId" : currentUser, "receiverName" : self.chat?.receiverName, "receiverId" : self.chat?.receiverId, "lastMessage" : self.lastMessage, "messageDate" : self.currentDate ])
                    
                            } else{
                                completion(false)
                            }
                        }
                    }
                }
            })
        
    }
    
    func getCurrentDate (){
        
        //Gets the current date and time
        let currenDateTime = Date()
        
        //Initialzzers the date formatter and set the style
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        //formatter.timeStyle = .medium
        
        //Gets the date strgin from the date object
        let dateTimeString = formatter.string(from: currenDateTime)
        
        currentDate = dateTimeString
    }
    
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        getCurrentDate()
        guard let message = self.messageTextField.text, messageTextField.text!.isEmpty == false  else {
            return
        }
        sendMessage(textMessage: message) { (isSuccess) in
            if (isSuccess){
                   
            }
            
        }
    }
    
}
