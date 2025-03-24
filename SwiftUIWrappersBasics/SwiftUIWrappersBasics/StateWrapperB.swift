//
//  StateWrapperB.swift
//  SwiftUIWrappersBasics
//
//  Created by Venugopal on 23/03/25.
//

//The @State property wrapper is one of the most fundamental state management tools in SwiftUI. It's designed for simple local state that's owned and managed by a specific view.
//Purpose
//@State creates a source of truth for value types (like structs, strings, integers) that is stored separately from the view struct itself. When a @State property changes, SwiftUI automatically recomputes the view body.

// @State - For simple local state management within a view

import SwiftUI

struct StateWrapperB: View {
    @State private var count = 0
        
        var body: some View {
            VStack {
                Text("Count: \(count)")
                    .font(.title)
                    .padding()
                
                HStack {
                    Button("Decrement") {
                        count -= 1
                    }
                    .padding()
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(8)
                    
                    Button("Increment") {
                        count += 1
                    }
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
}

#Preview {
    StateWrapperB()
}
