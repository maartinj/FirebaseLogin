//
//  SignUpView.swift
//  Firebase Login
//
//  Created by Marcin Jędrzejak on 03/01/2023.
//

import SwiftUI

// Film Part 8: https://www.youtube.com/watch?v=ng22GGzg5kI&list=PLBn01m5Vbs4B79bOmI3FL_MFxjXVuDrma&index=8

struct SignUpView: View {
    @EnvironmentObject var userInfo: UserInfo
    @State var user: UserViewModel = UserViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showError = false
    @State private var errorString = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    VStack(alignment: .leading) {
                        TextField("Full Name", text: self.$user.fullname)
                            .autocapitalization(.words)
                        if !user.validNameText.isEmpty {
                            Text(user.validNameText)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    VStack(alignment: .leading) {
                        TextField("Email Address", text: self.$user.email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        if !user.validEmailAddressText.isEmpty {
                            Text(user.validEmailAddressText)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    VStack(alignment: .leading) {
                        SecureField("Password", text: self.$user.password)
                        if !user.validPasswordText.isEmpty {
                            Text(user.validPasswordText)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    VStack(alignment: .leading) {
                        SecureField("Confirm Password", text: self.$user.confirmPassword)
                        if !user.passwordMatch(_confirmPW: user.confirmPassword) {
                            Text(user.validConfirmPasswordText)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                }
                .frame(width: 300)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                VStack(spacing: 20) {
                    Button {
                        FBAuth.createUser(withEmail: self.user.email,
                                          name: self.user.fullname,
                                          password: self.user.password) { (result) in
                            switch result {
                            case .failure(let error):
                                self.errorString = error.localizedDescription
                                self.showError = true
                            case .success( _):
                                print("Account creation successful")
                            }
                        }
                    } label: {
                        Text("Register")
                            .frame(width: 200)
                            .padding(.vertical, 15)
                            .background(Color.green)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .opacity(user.isSignInComplete ? 1 : 0.75)
                    }
                    .disabled(!user.isSignInComplete)
                    Spacer()
                }
                .padding()
            }
            .padding(.top)
            .alert(isPresented: $showError) {
                Alert(title: Text("Error creating account"), message: Text(self.errorString), dismissButton: .default(Text("OK")))
            }
            .navigationBarTitle("Sign Up", displayMode: .inline)
            .navigationBarItems(trailing: Button("Dismiss") {
                dismiss()
            })
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
