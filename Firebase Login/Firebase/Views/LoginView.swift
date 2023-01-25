//
//  LoginView.swift
//  Firebase Login
//
//  Created by Marcin Jędrzejak on 03/01/2023.
//

import SwiftUI

// Film Firebase Sign In with Email/Apple in SwiftUI - iOS 14 Update (4:10): https://www.youtube.com/watch?v=zzn0HkjmaLo&list=PLBn01m5Vbs4B79bOmI3FL_MFxjXVuDrma&index=11&ab_channel=StewartLynch

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
