//
//  ReAuthenticateView.swift
//  Firebase Login
//
//  Created by Marcin Jędrzejak on 26/01/2023.
//

import SwiftUI

// Film Firebase Account Deletion SwiftUI (21:17): https://youtu.be/Ro2BEKoclRY?list=PLBn01m5Vbs4B79bOmI3FL_MFxjXVuDrma&t=1211

struct ReAuthenticateView: View {
    @Binding var providers: [FBAuth.ProviderType]
    @Binding var canDelete: Bool
    @State private var password = ""
    @State private var errorText = ""
    
    var body: some View {
        ZStack {
            Color(.gray).opacity(0.4)
                .ignoresSafeArea()
            VStack {
                if providers.count == 2 {
                    Text("Choose the option that you used to log in")
                        .frame(height: 60)
                        .padding(.horizontal)
                }
                ForEach(providers, id: \.self) { provider in
                    if provider == .apple {
                        SignInWithAppleButtonView(handleResult: handleResult)
                            .padding(.top)
                    } else {
                        VStack {
                            SecureField("Enter your password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button("Authenticate") {
                                FBAuth.reauthenticateWithPassword(password: password) { result in
                                    handleResult(result: result)
                                }
                            }
                            .padding(.vertical, 15)
                            .frame(width: 200)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .opacity(password.isEmpty ? 0.6 : 1)
                            .disabled(password.isEmpty)
                        }
                        .padding()
                    }
                }
                Text(errorText)
                    .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)
                Button("Cancel") {
                    withAnimation {
                        providers = []
                    }
                }
                .padding(8)
                .foregroundColor(.primary)
                .background(Color(.secondarySystemBackground))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                Spacer()
            }
            .frame(width: 250, height: providers.count == 2 ? 350 : 230)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 20)
        }
    }
    
    func handleResult(result: Result<Bool, Error>) {
        switch result {
        case .success:
            // Reauthenticated now so you can delete
            canDelete = true
            withAnimation {
                providers = []
            }
        case .failure(let error):
            errorText = error.localizedDescription
        }
    }
}

struct ReAuthenticateView_Previews: PreviewProvider {
    static var previews: some View {
        ReAuthenticateView(providers: .constant([.apple, .password]), canDelete: .constant(false))
    }
}
