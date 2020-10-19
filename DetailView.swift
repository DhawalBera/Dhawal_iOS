//
//  DetailView.swift
//  LocalizationDemo
//
//  Created by Dhawal Bera on 20/10/20.
//  Copyright © 2020 Dhawal Bera. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    @State var identifier = "en"
    
    var body: some View {
        
        Group{
            Button(action: {
                Bundle.set(language: .indian(.hindi))
                self.identifier = "hi"
            }) {
                Text(Bundle.main.localizedString(forKey: "HELLO", value: "Hello", table: nil))
            }
            
            
            Button(action: {
                Bundle.set(language: .indian(.english))
                
                self.identifier = "en-IN"
            }) {
                Text(Bundle.main.localizedString(forKey: "HI", value: "Hello", table: nil))
            }
        }
        .environment(\.locale, .init(identifier: identifier))
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
