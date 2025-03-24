//
//  StateObjectB.swift
//  SwiftUIWrappersBasics
//
//  Created by Venugopal on 23/03/25.
//

// @StateObject - For managing lifecycle of observable objects owned by a view

//The @StateObject property wrapper is used to create and manage an observable object that's owned by a SwiftUI view. It ensures the object persists for the lifetime of the view across view updates.
//                                                                                                                                                    
//StateObject creates and maintains a reference to an observable object, ensuring it's only initialized once during the life of the view, even when the view body is recomputed multiple times.
//
//Key Points
//
//Life Cycle: @StateObject is initialized exactly once for each instance of the view.
//iOS 14+: Introduced in iOS 14 as an improvement over using @ObservedObject for object creation.
//Owner Relationship: The view that declares a @StateObject is the owner of that object.
//Observable Objects: Works with classes that conform to the ObservableObject protocol.
//When to Use: Use @StateObject when the view is responsible for creating the object. Use @ObservedObject when the object is created and owned elsewhere.
//SwiftUI Updates: When a @Published property changes in the object, SwiftUI automatically updates the view.
//Performance Consideration: Avoids recreating the object unnecessarily when the view body is recomputed.



import SwiftUI

struct StateObjectB: View {
    // Create and own the observable object
        @StateObject private var taskManager = TaskManager()
        @State private var newTask = ""
        
        var body: some View {
            VStack {
                HStack {
                    TextField("New task", text: $newTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        if !newTask.isEmpty {
                            taskManager.addTask(newTask)
                            newTask = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title)
                    }
                }
                .padding()
                
                List {
                    ForEach(taskManager.tasks.indices, id: \.self) { index in
                        Text(taskManager.tasks[index])
                    }
                    .onDelete { indices in
                        indices.forEach { taskManager.removeTask(at: $0) }
                    }
                }
                
                // Pass the manager to a child view
                TaskCountView(taskManager: taskManager)
            }
        }
}

// A child view that doesn't own the TaskManager
struct TaskCountView: View {
    // Use ObservedObject since this view doesn't own the object
    @ObservedObject var taskManager: TaskManager
    
    var body: some View {
        Text("You have \(taskManager.tasks.count) tasks")
            .padding()
            .foregroundColor(.secondary)
    }
}


// First, create a class that conforms to ObservableObject
class TaskManager: ObservableObject {
    // @Published automatically notifies observers when value changes
    @Published var tasks: [String] = []
    
    func addTask(_ task: String) {
        tasks.append(task)
    }
    
    func removeTask(at index: Int) {
        guard index < tasks.count else { return }
        tasks.remove(at: index)
    }
}

#Preview {
    StateObjectB()
}
