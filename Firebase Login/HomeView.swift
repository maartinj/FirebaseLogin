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
    @State private var showErrorLogout = false
    @State private var errorStringLogout = ""
    
    @State private var showProfile = false
    @State private var canDelete = false
    @State private var deleteString = ""
    @State private var showErrorDelete = false
    
    var body: some View {
        NavigationStack {
            Text("Logged in as \(userInfo.user.name)")
                .navigationTitle("Firebase Login")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Log Out") {
                            FBAuth.logout { (result) in
                                switch result {
                                case .failure(let error):
                                    self.errorStringLogout = error.localizedDescription
                                    self.showErrorLogout = true
                                case .success( _):
                                    print("Logged out")
                                }
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showProfile = true
                        } label: {
                            Image(systemName: "person.crop.circle.fill")
                        }
                        .frame(width: 44, height: 44)
                    }
                }
                .sheet(isPresented: $showProfile, onDismiss: {
                    if canDelete {
                        FBFirestore.deleteUserData(uid: userInfo.user.uid) { result in
                            switch result {
                            case .success:
                                FBAuth.deleteUser { result in
                                    if case let .failure(error) = result {
                                        // print(error.localizedDescription)
                                        self.deleteString = error.localizedDescription
                                        showErrorDelete = true
                                    }
                                    if case let .success(deleteDone) = result {
                                        self.deleteString = "Account successfully deleted"
                                        showErrorDelete = deleteDone
                                    }
                                }
                            case .failure(let error):
                                // print(error.localizedDescription)
                                self.deleteString = error.localizedDescription
                                showErrorDelete = true
                            }
                        }
                    }
                }) {
                    ProfileView(canDelete: $canDelete)
                }
                .alert(isPresented: $showErrorDelete) {
                    Alert(title: Text("Notification delete account"), message: Text(self.deleteString), dismissButton: .default(Text("OK")))
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
                .alert(isPresented: $showErrorLogout) {
                    Alert(title: Text("Error on logging out"), message: Text(self.errorStringLogout), dismissButton: .default(Text("OK")))
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserInfo())
    }
}
