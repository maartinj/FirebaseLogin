//
//  UserInfo.swift
//  Firebase Login
//
//  Created by Marcin Jędrzejak on 02/01/2023.
//

import Foundation

class UserInfo: ObservableObject {
    enum FBAuthState {
        case undefined, signedOut, signedIn
    }
    
    @Published var isUserAuthenticated: FBAuthState = .undefined
    
    func configureFirebaseStateDidChange() {
        self.isUserAuthenticated = .signedOut
//        self.isUserAuthenticated = .signedIn
    }
}
