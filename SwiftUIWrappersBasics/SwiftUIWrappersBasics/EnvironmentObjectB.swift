//
//  EnvironmentObjectB.swift
//  SwiftUIWrappersBasics
//
//  Created by Venugopal on 23/03/25.
//

import SwiftUI
//
//The @EnvironmentObject property wrapper provides a way to share data across many views in your SwiftUI application without explicitly passing it through each view in the hierarchy.
//Purpose
//@EnvironmentObject creates a dependency on an observable object that a parent view (typically the root view) injects into the environment. Any child view in the hierarchy can then access this shared data without it being explicitly passed down.
//Key Points
//
//Dependency Injection: Allows for dependency injection without explicitly passing objects through initializers.
//Single Instance: All views access the same instance of the object, creating a shared data store.
//Environment Propagation: The object is automatically available to all child views in the hierarchy.
//Implicit Dependency: Creates an implicit dependency - views will crash at runtime if the environment object isn't provided.
//App-wide State: Ideal for app-wide state like user settings, authentication status, theme data, etc.
//Performance: More efficient than passing the same object through many view initializers.
//Testability: When testing, you'll need to inject the environment object for preview or testing purposes using .environmentObject().
//Error Handling: If you forget to inject the environment object, you'll get a runtime crash, not a compile-time error.

// @EnvironmentObject - For accessing shared data throughout the app

// First, create an observable object to share throughout the app
class AppSettings: ObservableObject {
    @Published var themeColor: Color = .blue
    @Published var fontSize: CGFloat = 16
    @Published var username: String = ""
    @Published var isPremiumUser: Bool = false
    
    func upgradeToPremiun() {
        isPremiumUser = true
    }
}

// A deeply nested view can directly access the app settings
struct EnvironmentObjectB: View {
    // Access the environment object - no need to pass it through init
    @EnvironmentObject var appSettings: AppSettings
    
    var body: some View {
        VStack {
                    Text("Welcome, \(appSettings.username.isEmpty ? "Guest" : appSettings.username)")
                        .font(.system(size: appSettings.fontSize))
                        .padding()
                    
                    Text("Home Screen Content")
                        .foregroundColor(appSettings.themeColor)
                    
                    if !appSettings.isPremiumUser {
                        Button("Upgrade to Premium") {
                            appSettings.upgradeToPremiun()
                        }
                        .padding()
                        .background(appSettings.themeColor.opacity(0.2))
                        .cornerRadius(8)
                    }
                    
                    // Pass to another view without explicit parameter
                    DetailView()
                }
    }
}


// Settings view to modify the shared settings
struct SettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @State private var tempUsername: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Profile")) {
                TextField("Username", text: $tempUsername)
                    .onAppear { tempUsername = appSettings.username }
                
                Button("Save Username") {
                    appSettings.username = tempUsername
                }
            }
            
            Section(header: Text("Appearance")) {
                ColorPicker("Theme Color", selection: $appSettings.themeColor)
                
                Slider(value: $appSettings.fontSize, in: 12...24, step: 1) {
                    Text("Font Size: \(Int(appSettings.fontSize))")
                }
            }
            
            Section(header: Text("Status")) {
                Text("Account Type: \(appSettings.isPremiumUser ? "Premium" : "Free")")
            }
        }
        .navigationTitle("Settings")
    }
}

// Even deeply nested views can access the environment object
struct DetailView: View {
    @EnvironmentObject var appSettings: AppSettings
    
    var body: some View {
        Text("Detail View")
            .font(.system(size: appSettings.fontSize))
            .foregroundColor(appSettings.themeColor)
            .padding()
    }
}


#Preview {
    EnvironmentObjectB()
}
