//
//  SignInWithEmailView.swift
//  Firebase Login
//
//  Created by Marcin Jędrzejak on 03/01/2023.
//

import SwiftUI

struct SignInWithEmailView: View {
    @EnvironmentObject var userInfo: UserInfo
    @State var user: UserViewModel = UserViewModel()
    @Binding var showSheet: Bool
    @Binding var action: LoginView.Action?
    
    @State private var showAlert = false
    @State private var authError: EmailAuthError?
    
    var body: some View {
        VStack {
            TextField("Email Address", text: self.$user.email)
                .textInputAutocapitalization(.none)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $user.password)
                .textFieldStyle(.roundedBorder)
            HStack {
                Spacer()
                Button {
                    self.action = .resetPW
                    self.showSheet = true
                } label: {
                    Text("Forgot Password")
                }

            }
            .padding(.bottom)
            VStack(spacing: 10) {
                Button {
                    FBAuth.authenticate(withEmail: self.user.email,
                                        password: self.user.password) { (result) in
                        switch result {
                        case .failure(let error):
                            self.authError = error
                            self.showAlert = true
                        case .success( _):
                            print("Signed in")
                        }
                    }
                } label: {
                    Text("Login")
                        .padding(.vertical, 15)
                        .frame(width: 200)
                        .background(Color.green)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .opacity(user.isLogInComplete ? 1 : 0.7)
                }
                .disabled((!user.isLogInComplete))
                Button {
                    self.action = .signUp
                    self.showSheet = true
                } label: {
                    Text("Sign Up")
                        .padding(.vertical, 15)
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login Error"), message: Text(self.authError?.localizedDescription ?? "Unknown error"), dismissButton: .default(Text("OK")) {
                    if self.authError == .incorrectPassword {
                        self.user.password = ""
                    } else {
                        self.user.password = ""
                        self.user.email = ""
                    }
                })
            }
        }
        .padding(.top, 100)
        .frame(width: 300)
    }
}

struct SignInWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithEmailView(showSheet: .constant(true), action: .constant(.signUp))
    }
}
