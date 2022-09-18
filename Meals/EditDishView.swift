//
//  EditDishView.swift
//  Meals
//
//  Created by Peng, Kevin [C] on 2022-09-17.
//

import SwiftUI

struct EditDishView: View {

    let dish: Dish

    @Environment(\.managedObjectContext) var viewContext
    @State private var name = ""
    @State private var alternativeName = ""
    @State private var instructions = ""
    @State private var error = ""
    @State private var showError = false
    @State private var isEditing = false

    var body: some View {
        VStack {
            HStack {
                text(label: "Name", binding: $name)
                text(label: "Alternative Name", binding: $alternativeName)
            }
            ScrollView {
                VStack {
                    IngredientsView(dish: dish)
                        .frame(minHeight: 100, maxHeight: 400)
                    text(label: instructions, binding: $instructions)
                    Text(instructions)
                        .frame(maxWidth: .infinity)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .onAppear(perform: populateExistingFields)
        .toolbar {
            Button("Add Ingredient", action: addItem)
            Button(isEditing ? "Save" : "Edit", action: handleEditSave)
            if isEditing {
                Button("Cancel") { isEditing = false }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {
                showError = false
            }
        }
    }

    @ViewBuilder
    func text(label: String, binding: Binding<String>) -> some View {
        if isEditing {
            TextField(label, text: binding)
        } else {
            Text(binding.wrappedValue)
        }
    }

    func handleEditSave() {
        if isEditing {
            save()
        }
        isEditing.toggle()
    }

    private func addItem() {
        withAnimation {
            let newItem = Ingredient(context: viewContext)
            newItem.name = "New Ingredient"
            newItem.addToDishes(dish)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    func populateExistingFields() {
        name = dish.name ?? ""
        alternativeName = dish.alternativeName ?? ""
        instructions = dish.instructions ?? ""
    }

    func save() {
        dish.name = name
        dish.alternativeName = alternativeName
        dish.instructions = instructions
        do {
            if viewContext.hasChanges {
                try viewContext.save()
            }
        } catch {
            self.error = error.localizedDescription
        }
    }
}

struct EditDishView_Previews: PreviewProvider {
    static var previews: some View {
        let dish: Dish = {
            let dish = Dish(context: PersistenceController.preview.container.viewContext)
            dish.name = "Hello!"
            return dish
        }()
        EditDishView(dish: dish)
    }
}
