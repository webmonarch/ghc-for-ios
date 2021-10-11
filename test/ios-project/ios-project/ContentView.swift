//
//  ContentView.swift
//  ios-project
//
//  Created by Eric Webb on 10/8/21.
//

import SwiftUI

struct ContentView: View {
    @Binding var message: String
    var body: some View {
        Text(message)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(message: .constant("Hello, SwiftUI"))
    }
}
