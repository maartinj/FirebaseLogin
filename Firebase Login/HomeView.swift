//
//  HomeView.swift
//  Firebase Login
//
//  Created by Marcin Jędrzejak on 03/01/2023.
//

import SwiftUI
import Firebase

struct HomeView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    
    var body: some View {
        NavigationStack {
            Text("Logged in as \(userInfo.user.name)")
                .navigationTitle("Firebase Login")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Log Out") {
                            self.userInfo.isUserAuthenticated = .signedOut
                        }
                    }
                }
                .onAppear {
                    guard let uid = Auth.auth().currentUser?.uid else {
                        return
                    }
                    FBFirestore.retrieveFBUser(uid: uid) { (result) in
                        switch result {
                        case .failure(let error):
                            print(error.localizedDescription)
                            // Display some kind of alert to your user here. (It shouldn't happen)
                        case .success(let user):
                            self.userInfo.user = user
                        }
                    }
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
