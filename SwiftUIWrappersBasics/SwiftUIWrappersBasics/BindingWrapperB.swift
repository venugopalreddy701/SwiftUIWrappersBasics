//
//  BindingWrapperB.swift
//  SwiftUIWrappersBasics
//
//  Created by Venugopal on 23/03/25.
//

// @Binding - For creating two-way connections between views


//The @Binding property wrapper creates a two-way connection to a state property owned by another view. It doesn't store data itself but provides a reference to the source of truth owned elsewhere.

//@Binding allows child views to modify state that belongs to parent views, creating a two-way connection rather than just reading the value.


//Key Points
//
//Reference with Dollar Sign: To pass a binding from a @State property, use the dollar sign prefix ($) which provides the binding reference.
//No Own Storage: @Binding doesn't store its own data; it's just a reference to data stored elsewhere.
//Two-way Connection: Changes made through a @Binding are reflected back to the original source of truth.
//Use Cases: Form controls, custom UI components, and any situation where a child view needs to modify state owned by a parent.
//Creating Bindings Programmatically: Can use Binding.constant() for read-only bindings or custom bindings with Binding(get:set:).
//Testing: For preview or testing, you can use .constant(value) to create a static binding.

import SwiftUI

struct BindingWrapperB: View {
    @State private var isToggled = false
        
        var body: some View {
            VStack {
                Text("Toggle is \(isToggled ? "ON" : "OFF")")
                    .font(.headline)
                    .padding()
                
                // Pass binding to child view
                ToggleButton(isToggled: $isToggled)
                
                // Another way to use the same binding
                Toggle("Manual Toggle", isOn: $isToggled)
                    .padding()
            }
            .padding()
        }
}

// Child view that receives the binding
struct ToggleButton: View {
    @Binding var isToggled: Bool
    
    var body: some View {
        Button(action: {
            // Can modify parent's state through binding
            isToggled.toggle()
        }) {
            Text("Toggle Switch")
                .padding()
                .background(isToggled ? Color.green : Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

#Preview {
    BindingWrapperB()
}
