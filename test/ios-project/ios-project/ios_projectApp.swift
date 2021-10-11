//
//  ios_projectApp.swift
//  ios-project
//
//  Created by Eric Webb on 10/8/21.
//

import SwiftUI

@main
struct ios_projectApp: App {
    @State private var message: String
    
    init() {
        hs_init(nil, nil)
        
        print("ios_projectApp init")
        
        message = String(cString: hello())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(message: $message)
        }
    }
}
