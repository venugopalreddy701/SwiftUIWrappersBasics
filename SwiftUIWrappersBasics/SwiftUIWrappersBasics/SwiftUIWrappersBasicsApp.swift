//
//  SwiftUIWrappersBasicsApp.swift
//  SwiftUIWrappersBasics
//
//  Created by Venugopal on 23/03/25.
//

import SwiftUI

// In your main app file, inject the environment object

@main
struct SwiftUIWrappersBasicsApp: App {
    // Create the object at the app level
        @StateObject private var appSettings = AppSettings()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            // Inject it into the environment for all child views
                           .environmentObject(appSettings)
        }
    }
}
