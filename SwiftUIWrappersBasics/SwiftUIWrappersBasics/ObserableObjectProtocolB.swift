//
//  ObserableObjectProtocolB.swift
//  SwiftUIWrappersBasics
//
//  Created by Venugopal on 23/03/25.
//

import SwiftUI

//ObservableObject Protocol
//ObservableObject is a protocol in SwiftUI that enables a reference type (class) to be observed for changes by SwiftUI views. It's a fundamental part of SwiftUI's reactive architecture.
//Purpose
//The ObservableObject protocol allows objects to announce when changes occur, triggering SwiftUI views to update. It works hand-in-hand with property wrappers like @StateObject, @ObservedObject, and @EnvironmentObject.

//Key Features
//
//Publisher: ObservableObject conforms to the Combine framework and provides an objectWillChange publisher that emits before any changes occur.
//@Published: This property wrapper automatically triggers the objectWillChange publisher when the property changes.
//Reference Type Only: Only classes can conform to ObservableObject, not structs or enums.
//Manual Notification: You can manually call objectWillChange.send() for properties not marked with @Published or for custom change logic.
//Integration with SwiftUI: Used with @StateObject, @ObservedObject, and @EnvironmentObject to create reactive UI that updates when data changes.
//Data Flow: Creates a unidirectional data flow, where changes to the model trigger updates to the view.

import Combine
import SwiftUI

class WeatherModel: ObservableObject {
    // @Published automatically notifies observers when changed
    @Published var temperature: Double = 72.0
    @Published var condition: String = "Sunny"
    @Published var humidity: Int = 45
    
    // You can also use objectWillChange.send() manually
    var location: String = "San Francisco" {
        willSet {
            // Manually notify observers before changing
            objectWillChange.send()
        }
    }
    
    func updateWeather() {
        // In real app, this would fetch from an API
        temperature = Double.random(in: 65...95)
        humidity = Int.random(in: 30...90)
        
        let conditions = ["Sunny", "Cloudy", "Rainy", "Stormy", "Snowy"]
        condition = conditions.randomElement() ?? "Sunny"
    }
}

struct ObserableObjectProtocolB: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ObserableObjectProtocolB()
}
