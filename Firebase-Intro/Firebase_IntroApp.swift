//
//  Firebase_IntroApp.swift
//  Firebase-Intro
//
//  Created by David Svensson on 2021-12-21.
//

import SwiftUI
import Firebase


@main
struct Firebase_IntroApp: App {
    
    init() {
        FirebaseApp.configure()
    }
        
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
