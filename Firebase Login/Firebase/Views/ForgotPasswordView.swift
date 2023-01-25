//
//  ForgotPasswordView.swift
//  Firebase Login
//
//  Created by Marcin Jędrzejak on 03/01/2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State var user: UserViewModel = UserViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var showAlert = false
    @State private var errorString: String?
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter email address", text: $user.email)
                    .textInputAutocapitalization(.none)
                    .keyboardType(.emailAddress)
                Button {
                    FBAuth.resetPassword(email: self.user.email) { (result) in
                        switch result {
                        case .failure(let error):
                            self.errorString = error.localizedDescription
                        case .success( _):
                            break
                        }
                        self.showAlert = true
                    }
                } label: {
                    Text("Reset")
                        .frame(width: 200)
                        .padding(.vertical, 15)
                        .background(Color.green)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .opacity(user.isEmailValid(_email: user.email) ? 1 : 0.75)
                }
                .disabled(!user.isEmailValid(_email: user.email))
                Spacer()
            }
            .padding(.top)
            .frame(width: 300)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .navigationBarTitle("Request a password reset", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Password Reset"),
                      message: Text(self.errorString ?? "Success. Reset email sent successfully. Check your email"),
                      dismissButton: .default(Text("OK")) {
                    dismiss()
                })
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
