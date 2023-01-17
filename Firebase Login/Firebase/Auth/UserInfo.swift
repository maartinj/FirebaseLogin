//
//  UserInfo.swift
//  Firebase Login
//
//  Created by Marcin Jędrzejak on 02/01/2023.
//

import Foundation
import FirebaseAuth

class UserInfo: ObservableObject {
    enum FBAuthState {
        case undefined, signedOut, signedIn
    }
    
    @Published var isUserAuthenticated: FBAuthState = .undefined
    @Published var user: FBUser = .init(uid: "", name: "", email: "")
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    func configureFirebaseStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ _, user in
            guard let _ = user else {
                self.isUserAuthenticated = .signedOut
                return
            }
            self.isUserAuthenticated = .signedIn
//            FBFirestore.retrieveFBUser(uid: user.uid) { (result) in
//                switch result {
//                case .failure(let error):
//                    print(error.localizedDescription)
//                case .success(let user):
//                    self.user = user
//                }
//            }
        })
    }
}
