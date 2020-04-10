//
//  FireBaseModel.swift
//  FriendsApp
//
//  Created by Amad Walid on 2020-02-13.
//  Copyright © 2020 Amad Walid. All rights reserved.
//

import Foundation
import Firebase

class FireBaseModel {
    
    static func currentUserId()-> String {
        
        return Auth.auth().currentUser!.uid
        
    }
    
   /* static func getUserData() {
        let currentUser = (Auth.auth().currentUser?.uid)!
        let dataRef = Database.database().reference()
        let user = dataRef.child("users").child(currentUser)
        
        var fn = ""
        var ln = ""
        var ue = ""
        user.observe(.value) { (DataSnapshot) in
            let userArray = DataSnapshot.value as? [String : Any]
                              
            fn = userArray?["firstname"] as! String
            ln = userArray? ["lastname"] as! String
            ue = userArray? ["mail"] as! String
            
        }
    }*/
  
}
    
    

