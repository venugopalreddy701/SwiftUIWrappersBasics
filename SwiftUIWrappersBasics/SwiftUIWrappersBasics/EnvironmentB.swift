//
//  EnvironmentB.swift
//  SwiftUIWrappersBasics
//
//  Created by Venugopal on 24/03/25.
//

//The @Environment property wrapper lets you read values from the SwiftUI environment, which contains system-wide settings and values provided by SwiftUI.
//Purpose
//@Environment provides a way to access built-in values that SwiftUI manages, such as color scheme, locale, calendar, and more. It also lets you access custom values that you've added to the environment.

//
//@Environment(\.colorScheme) var colorScheme         // Light or dark mode
//@Environment(\.sizeCategory) var sizeCategory       // Dynamic Type size
//@Environment(\.locale) var locale                   // Current locale
//@Environment(\.calendar) var calendar               // Current calendar
//@Environment(\.timeZone) var timeZone               // Current time zone
//@Environment(\.layoutDirection) var layoutDirection // LTR or RTL
//@Environment(\.presentationMode) var presentation   // Manage presentation mode
//@Environment(\.editMode) var editMode               // For List editing mode
//@Environment(\.horizontalSizeClass) var hSizeClass  // Compact or regular width
//@Environment(\.verticalSizeClass) var vSizeClass    // Compact or regular height
//@Environment(\.isEnabled) var isEnabled             // Control enabled state
//@Environment(\.dismiss) var dismiss                 // Dismiss presented view

//Key Points
//
//System Values: Primarily used to access system-provided values that may change at runtime.
//Read-Only vs. Read-Write: Most environment values are read-only, but some (like editMode) can be modified.
//Custom Keys: You can create custom environment keys for your own environment values.
//Scope: Environment values are set for a view and all of its child views.
//Adaptivity: Excellent for creating adaptive interfaces that respond to system settings.
//Efficiency: More efficient than repeatedly passing the same value to many views.
//When to Use: Use for accessing system settings or for values that many views across different parts of your app need to access.
//@Environment - For reading values from the environment

import SwiftUI

struct EnvironmentB: View {
    // Access the content size category from the environment
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.locale) var locale
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    // You can also access custom environment values
    @Environment(\.myCustomValue) var customValue
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Current Environment Settings")
                .font(.headline)
            
            Group {
                Text("Color Scheme: \(colorScheme == .dark ? "Dark" : "Light")")
                Text("Dynamic Type Size: \(sizeCategory.description)")
                Text("Locale: \(locale.identifier)")
                Text("Size Class: \(horizontalSizeClass == .compact ? "Compact" : "Regular")")
            }
            .padding()
            .background(colorScheme == .dark ? Color.gray.opacity(0.3) : Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            // Adaptive layout based on environment
            if horizontalSizeClass == .compact {
                VStack {
                    settingsButton
                    infoButton
                }
            } else {
                HStack {
                    settingsButton
                    infoButton
                }
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color.black : Color.white)
        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
    }
    
    var settingsButton: some View {
        Button("Settings") {
            // Action
        }
        .padding()
        .frame(minWidth: 100)
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
    
    var infoButton: some View {
        Button("Info") {
            // Action
        }
        .padding()
        .frame(minWidth: 100)
        .background(Color.green)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}
}

// To create custom environment values, you need to:
// 1. Define a key
struct MyCustomKey: EnvironmentKey {
    static let defaultValue: String = "Default Value"
}

// 2. Extend EnvironmentValues to access your key
extension EnvironmentValues {
    var myCustomValue: String {
        get { self[MyCustomKey.self] }
        set { self[MyCustomKey.self] = newValue }
    }
}

// 3. Optionally, add a View extension for easy modification
extension View {
    func myCustomValue(_ value: String) -> some View {
        environment(\.myCustomValue, value)
    }
}

// Usage of custom environment value
struct ParentView: View {
    var body: some View {
        EnvironmentB()
            .environment(\.myCustomValue, "Custom Value")
            // OR using the extension
            .myCustomValue("Custom Value")
    }
}

#Preview {
    EnvironmentB()
}
