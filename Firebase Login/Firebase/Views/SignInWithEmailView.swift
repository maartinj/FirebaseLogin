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
    
    var body: some View {
        VStack {
            TextField("Email Address", text: self.$user.email)
                .textInputAutocapitalization(.none)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $user.password)
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
                    // Sign In Action
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
        }
    }
}

struct SignInWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithEmailView(showSheet: .constant(true), action: .constant(.signUp))
    }
}
