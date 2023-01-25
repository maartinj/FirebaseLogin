//
//  SignInWithAppleButtonView.swift
//  Firebase Login
//
//  Created by Marcin Jędrzejak on 25/01/2023.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonView: View {
    
    @State private var currentNonce: String?
    
    var body: some View {
        SignInWithAppleButton(.continue,
            onRequest: { request in
            let nonce = FBAuth.randomNonceString()
            currentNonce = nonce
            request.requestedScopes = [.fullName, .email]
            request.nonce = FBAuth.sha256(nonce)
            },
            onCompletion: { result in
            switch result {
            case .success(let authResult):
                switch authResult.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    guard let nonce = currentNonce else {
                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                    }
                    guard let appleIDToken = appleIDCredential.identityToken else {
                        print("Unable to fetch identity token")
                        return
                    }
                    guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                        return
                    }
                    
                    FBAuth.signInWithApple(idTokenString: idTokenString, nonce: nonce) { (result) in
                        switch result {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .success(let authDataResult):
                            let signInWithAppleResult = (authDataResult, appleIDCredential)
                            FBAuth.handle(signInWithAppleResult) { (result) in
                                switch result {
                                case .failure(let error):
                                    print(error.localizedDescription)
                                case .success( _):
                                    print("Successful Login")
                                
                                }
                            }
                        
                        }
                    }
                default:
                    break
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            }
        )
        .frame(width: 200, height: 50)
        .signInWithAppleButtonStyle(.whiteOutline)
    }
}

struct SignInWithAppleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithAppleButtonView()
    }
}
