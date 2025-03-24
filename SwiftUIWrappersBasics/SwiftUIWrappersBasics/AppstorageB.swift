//
//  AppstorageB.swift
//  SwiftUIWrappersBasics
//
//  Created by Venugopal on 24/03/25.
//
//
//The @AppStorage property wrapper provides a convenient way to read and write values to UserDefaults directly from your SwiftUI views.
//Purpose
//@AppStorage creates a property that automatically syncs with UserDefaults, allowing you to persist simple data between app launches without needing to manually interact with the UserDefaults API.

//Key Points
//
//Persistence: Data persists between app launches in UserDefaults.
//Automatic Syncing: Values are automatically read from and written to UserDefaults.
//Default Values: Provide a default value that's used if the key doesn't exist in UserDefaults.
//Custom UserDefaults: Can specify a custom UserDefaults suite (useful for App Groups).
//Type Constraints: Limited to certain types that UserDefaults supports.
//Key Naming: Keys are strings and should be unique across your app.
//View Updates: When the value changes, any view reading the @AppStorage property will automatically update.
//Storage Limitations: UserDefaults is meant for small amounts of data; don't use it for large data sets.
//Performance: Avoid using in views that render frequently, as it involves disk I/O.


import SwiftUI

struct AppstorageB: View {
    // Store values in standard UserDefaults
       @AppStorage("username") private var username = "Guest"
       @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false
       @AppStorage("refreshInterval") private var refreshInterval = 60.0
       @AppStorage("notificationsEnabled") private var notificationsEnabled = true
       @AppStorage("lastOpenedDate") private var lastOpenedDate: Double = Date().timeIntervalSince1970
       
       // You can also specify a custom UserDefaults store
       @AppStorage("selectedTab", store: UserDefaults(suiteName: "group.com.yourapp.shared"))
       private var selectedTab = 0
       
       var body: some View {
           Form {
               Section(header: Text("Profile")) {
                   TextField("Username", text: $username)
                   Text("Last opened: \(Date(timeIntervalSince1970: lastOpenedDate).formatted())")
                       .font(.caption)
                       .foregroundColor(.secondary)
               }
               
               Section(header: Text("Appearance")) {
                   Toggle("Dark Mode", isOn: $isDarkModeEnabled)
               }
               
               Section(header: Text("App Settings")) {
                   Toggle("Enable Notifications", isOn: $notificationsEnabled)
                   
                   VStack(alignment: .leading) {
                       Text("Refresh Interval: \(Int(refreshInterval)) seconds")
                       Slider(value: $refreshInterval, in: 30...300, step: 15) {
                           Text("Refresh Interval")
                       }
                   }
               }
               
               Button("Reset to Defaults") {
                   username = "Guest"
                   isDarkModeEnabled = false
                   refreshInterval = 60.0
                   notificationsEnabled = true
                   // Set last opened to current time
                   lastOpenedDate = Date().timeIntervalSince1970
               }
           }
           .navigationTitle("Settings")
           .onAppear {
               // Update the last opened date whenever the view appears
               lastOpenedDate = Date().timeIntervalSince1970
           }
           .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
       }
}
//
//Supported Types
//@AppStorage works with these types out of the box:
//
//Int
//Double
//String
//Bool
//URL
//Data
//Any type that conforms to RawRepresentable where RawValue is one of the above types (like enums)
//
//For other types, you'll need to use Data and encode/decode manually or use a different persistence method.

// To store custom types, you need to make them codable
struct Theme: Codable, RawRepresentable {
    var primaryColor: String
    var secondaryColor: String
    var fontName: String
    
    // Implement RawRepresentable for @AppStorage compatibility
    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let theme = try? JSONDecoder().decode(Theme.self, from: data) else {
            return nil
        }
        self = theme
    }
    
    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let string = String(data: data, encoding: .utf8) else {
            return ""
        }
        return string
    }
    
    // Convenience init
    init(primaryColor: String, secondaryColor: String, fontName: String) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.fontName = fontName
    }
}

struct ThemeSettingsView: View {
    @AppStorage("userTheme") private var userTheme = Theme(
        primaryColor: "#FF0000",
        secondaryColor: "#0000FF",
        fontName: "Helvetica"
    )
    
    var body: some View {
        Form {
            Section(header: Text("Theme Settings")) {
                TextField("Primary Color", text: $userTheme.primaryColor)
                TextField("Secondary Color", text: $userTheme.secondaryColor)
                TextField("Font Name", text: $userTheme.fontName)
            }
        }
        .navigationTitle("Theme")
    }
}

#Preview {
    AppstorageB()
}
