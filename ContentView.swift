//
//  ContentView.swift
//  LocalizationDemo
//
//  Created by Dhawal Bera on 19/10/20.
//  Copyright © 2020 Dhawal Bera. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let arrLanguage : [Language] = [.indian(.hindi), .indian(.english)]
    var body: some View {
        NavigationView{
            List{
                ForEach(arrLanguage, id: \.code){ lang in
                    NavigationLink(destination: DetailView()) {
                        Text(Bundle.main.localizedString(forKey: "HELLO", value: "Hello", table: nil))
                        /*Button(action: {
                            Bundle.set(language: lang)
                            //SceneDelegate.shared?.window?.rootViewController = UIHostingController(rootView: self)
                        }) {
                            Text(Bundle.main.localizedString(forKey: "HELLO", value: "Hello", table: nil))
                        }*/
                    }
                    
                }
            }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
