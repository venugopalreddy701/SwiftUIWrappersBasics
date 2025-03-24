//
//  ObservedObjectB.swift
//  SwiftUIWrappersBasics
//
//  Created by Venugopal on 23/03/25.
//


//The @ObservedObject property wrapper is used to subscribe to an observable object that is created and owned elsewhere.
//Purpose
//@ObservedObject allows a view to observe changes to an external observable object without taking ownership of it. When published properties of the observed object change, the view will automatically update.
//
//Key Points
//
//External Ownership: Unlike @StateObject, @ObservedObject doesn't create or own the object. It's passed in from elsewhere.
//Potential Reinitialization: Objects passed to @ObservedObject might be recreated when the parent view is recomputed, which could lead to state loss if not properly managed.
//Dependency Injection: Perfect for dependency injection patterns where objects are created at a higher level and passed down.
//View Hierarchy: Typically used in child views that receive observable objects from parent views.
//Comparison with StateObject: Use @StateObject for creating and owning objects, use @ObservedObject for using objects created elsewhere.
//When to Use: Use when you need to observe an object that is passed to a view rather than created by it.
//@ObservedObject - For subscribing to external observable objects
//
import SwiftUI

// First, define an observable object
class UserSettings: ObservableObject {
    @Published var username: String = "Guest"
    @Published var isLoggedIn: Bool = false
    @Published var prefersDarkMode: Bool = false
    
    func login(with name: String) {
        username = name
        isLoggedIn = true
    }
    
    func logout() {
        username = "Guest"
        isLoggedIn = false
    }
}

// This parent view creates and owns the object
struct ObservedObjectB: View {
    // Creates and owns the settings object
        @StateObject private var settings = UserSettings()
        
        var body: some View {
            VStack {
                if settings.isLoggedIn {
                    Text("Welcome, \(settings.username)!")
                        .font(.headline)
                    
                    // Pass the object to child views
                    ProfileView(settings: settings)
                    
                    Button("Logout") {
                        settings.logout()
                    }
                    .padding()
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(8)
                } else {
                    LoginView(settings: settings)
                }
            }
            .preferredColorScheme(settings.prefersDarkMode ? .dark : .light)
        }
}

// This child view observes but doesn't own the object
struct ProfileView: View {
    // Observes the object but doesn't own it
    @ObservedObject var settings: UserSettings
    
    var body: some View {
        VStack {
            Text("Profile Settings")
                .font(.title)
                .padding()
            
            Toggle("Dark Mode", isOn: $settings.prefersDarkMode)
                .padding()
            
            Text("Other profile options would go here")
                .foregroundColor(.secondary)
                .padding()
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}


// Another child view
struct LoginView: View {
    @ObservedObject var settings: UserSettings
    @State private var inputName: String = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $inputName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Login") {
                settings.login(with: inputName)
            }
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
            .disabled(inputName.isEmpty)
        }
        .padding()
    }
}


#Preview {
    ObservedObjectB()
}
