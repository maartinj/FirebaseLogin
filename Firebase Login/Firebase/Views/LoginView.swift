//
//  LoginView.swift
//  Firebase Login
//
//  Created by Marcin Jędrzejak on 03/01/2023.
//

import SwiftUI

struct LoginView: View {
    enum Action {
        case signUp, resetPW
    }
    @State private var showSheet = false
    @State private var action: Action?
    
    var body: some View {
        VStack {
            SignInWithEmailView(showSheet: $showSheet, action: $action)
            SignInWithAppleButtonView()
            Spacer()
        }
            .sheet(isPresented: $showSheet) { [action] in
                if action == .signUp {
                    SignUpView()
                } else {
                    ForgotPasswordView()
                }
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
