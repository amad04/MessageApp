//
//  ListViewSwiftUi.swift
//  FriendsApp
//
//  Created by Amad Walid on 2019-12-02.
//  Copyright © 2019 Amad Walid. All rights reserved.
//

import UIKit
import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore


struct ChatViewRow  {

    let profileImage: Image
    let profileName : String
    let profilDescription : String
}


func SignOutUser (){
    let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
}

struct ListViewSwiftUi: View {
     @State private var showLinkTarget = true
    
    var body: some View {
        
        VStack {
          
            List{
                    HStack {
                        HStack {

                            Image("user-profile")
                                       .resizable() .frame(width:
                                        70,height: 70)
                                        .clipShape(Circle())
                                            
                                        .shadow(radius: 10) .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                        
                                        
                                    VStack (alignment: .leading) {
                                        HStack {
                                            Text ("Micke").bold()
                                            Spacer()
                                        Text("2019-12-05")
                                        }
                                        Text ("Tja, ser att det går bra för dig 👽 ")
                                        }
                                   
                                    }

                                }
                                HStack {
                                    Image(systemName: "heart.fill")
                                                  .resizable() .frame(width: 70, height: 70) .clipShape(Circle())
                                                   .shadow(radius: 10)
                                                   .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                                    .foregroundColor(.red)
                                                   
                                                   VStack (alignment: .leading) {
                                                   
                                                   
                                                   Text ("Anotha").bold()
                                                   Text ("Hej, hur mår du? 🐱")
                                                   }
                                }
                                HStack {
                                        Image(systemName: "person.crop.circle")
                                                  .resizable() .frame(width: 70, height: 70) .clipShape(Circle())
                                                   .shadow(radius: 10)
                                                   .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                                   
                                                   
                                                   VStack (alignment: .leading) {
                                                   
                                                   
                                                   Text ("Magnus").bold()
                                                   Text ("Tja, jobbar du?")
                                                   }
                                
                                }
            }.navigationBarTitle("ChatView")
            
            
            .navigationBarItems(
            trailing: Button(action: {
                NavigationLink(destination: UserProfileDetails(), isActive: self.$showLinkTarget ) {
                   Spacer().fixedSize()
                }
                
                
            }) {
            Image (systemName: "person").foregroundColor(Color.gray)
        })
        }

        /*sheet(isPresented: $isActive) {
            UserProfileDetails()*/
        }
     
        
    }
                        
               
                    
                         /*.navigationBarItems(
                            trailing: Button(action: {
                                SignOutUser()
                                
                                
                            }) {
                            Image (systemName: "person").foregroundColor(Color.gray)
                            }) */

struct ListViewSwiftUi_Previews: PreviewProvider {
    static var previews: some View {
        ListViewSwiftUi()
    }
}


