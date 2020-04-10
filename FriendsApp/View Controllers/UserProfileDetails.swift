//
//  UserProfileDetails.swift
//  FriendsApp
//
//  Created by Amad Walid on 2019-12-04.
import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore



struct UserProfileDetails: View {
    @State private var showLinkTarget = false
    @State var fname = "hghg"
    @State var lname = ""
    @State var email = ""
    
    
    func getUserData(){

    let user = Auth.auth().currentUser?.email
    let db = Firestore.firestore()
        
        db.collection("users").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil{
                for document in snapshot!.documents {
                    if user == (document.get("mail") as! String){
                        let firstName = document.get("firstname")
                        let lastName = document.get("lastname")
                        let userEmail = document.get("mail")
                        
                        
                        self.showUserData(firstName as! String, lastName as! String, userEmail as! String)
                        break
                    }
                }
            }
        }
    }


    func showUserData(_ fn: String, _ ln: String, _ em: String) {
    
        fname = fn
        
        lname = ln
        
        email = em
        //label_email.alpha = 1
        
    }
    var body: some View {
       
        
        NavigationView {
            
            

            
            VStack() {
                Text("Förnamn \(fname) ").padding()
                Text ("Efternamn: \(lname)").padding()
            Text ("Email \(email)").padding()
            Button( action: {self.getUserData()}) {
                Text(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/)
            }
            }.padding()
        }.navigationBarItems(
        trailing: Button(action: {
            SignOutUser()
        
            
        }) {
        Image (systemName: "person").foregroundColor(Color.gray)
        })
        .navigationBarTitle("History")
    }
}

struct UserProfileDetails_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileDetails()
    }
}
