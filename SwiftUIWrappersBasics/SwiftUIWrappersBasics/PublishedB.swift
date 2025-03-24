//
//  PublishedB.swift
//  SwiftUIWrappersBasics
//
//  Created by Venugopal on 24/03/25.
//

import Combine
import SwiftUI

//The @Published property wrapper is used inside of classes that conform to ObservableObject to automatically announce when changes to a property occur.
//Purpose
//@Published marks properties in an observable object that, when changed, should trigger the object's objectWillChange publisher to emit a new value, notifying any SwiftUI views observing this object to update.

//Key Points
//
//Observable Objects Only: @Published is designed to be used inside classes that conform to ObservableObject.
//Automatic Publishing: When a @Published property changes, it automatically triggers the objectWillChange publisher.
//Under the Hood: It uses the Combine framework to wrap the property in a publisher.
//Property Observers: Works similarly to Swift property observers (willSet/didSet) but is integrated with Combine.
//Efficiency: Multiple changes to different @Published properties in the same execution cycle may be batched by SwiftUI for efficiency.
//State Notification: SwiftUI views that observe an object via @ObservedObject, @StateObject, or @EnvironmentObject automatically update when @Published properties change.
//Manual Alternative: If you don't want to use @Published, you can manually call objectWillChange.send() in a property's willSet observer.
//Value Types: Works with any value type, but reference types like classes should be used carefully as changes to their properties won't automatically trigger updates.

class WeatherViewModel: ObservableObject {
    // These properties will automatically publish changes
    @Published var temperature: Double = 72.0
    @Published var condition: String = "Sunny"
    @Published var humidity: Int = 45
    @Published var windSpeed: Double = 5.0
    @Published var isLoading: Bool = false
    
    // This property won't automatically publish changes
    var lastUpdated: Date = Date()
    
    func updateWeather() {
        isLoading = true
        
        // Simulate API call with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Update the properties - each change will trigger objectWillChange
            self.temperature = Double.random(in: 65...95)
            self.windSpeed = Double.random(in: 0...15)
            self.humidity = Int.random(in: 30...90)
            
            let conditions = ["Sunny", "Cloudy", "Rainy", "Stormy", "Snowy"]
            self.condition = conditions.randomElement() ?? "Sunny"
            
            self.lastUpdated = Date()
            self.isLoading = false
        }
    }
}

struct PublishedB: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Current Weather")
                .font(.largeTitle)
                .bold()
            
            if viewModel.isLoading {
                ProgressView("Updating weather...")
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        weatherIcon
                        Text("\(Int(viewModel.temperature))°F")
                            .font(.system(size: 50, weight: .medium))
                    }
                    
                    Text("Condition: \(viewModel.condition)")
                    Text("Humidity: \(viewModel.humidity)%")
                    Text("Wind: \(String(format: "%.1f", viewModel.windSpeed)) mph")
                    
                    Text("Last updated: \(viewModel.lastUpdated.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            }
            
            Button("Refresh Weather") {
                viewModel.updateWeather()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(viewModel.isLoading)
        }
        .padding()
    }
    
    var weatherIcon: some View {
        Image(systemName: iconName)
            .font(.system(size: 40))
            .foregroundColor(iconColor)
            .frame(width: 60, height: 60)
    }
    
    var iconName: String {
        switch viewModel.condition {
        case "Sunny": return "sun.max.fill"
        case "Cloudy": return "cloud.fill"
        case "Rainy": return "cloud.rain.fill"
        case "Stormy": return "cloud.bolt.fill"
        case "Snowy": return "snow"
        default: return "sun.max.fill"
        }
    }
    
    var iconColor: Color {
        switch viewModel.condition {
        case "Sunny": return .yellow
        case "Cloudy": return .gray
        case "Rainy": return .blue
        case "Stormy": return .purple
        case "Snowy": return .cyan
        default: return .yellow
        }
    }
}

#Preview {
    PublishedB()
}
