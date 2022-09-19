//
//  EditIngredientView.swift
//  Meals
//
//  Created by Peng, Kevin [C] on 2022-09-17.
//

import SwiftUI

struct EditIngredientView: View {

    let ingredient: Ingredient

    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var alternativeName = ""
    @State private var error = ""
    @State private var showError = false
    @State private var isEditing = false

    var body: some View {
        VStack {
            if isEditing {
                TextField("Name", text: $name)
                TextField("Alternative Name", text: $alternativeName)
                VStack {
                    Button("Save", action: save)
                    Button("Delete", action: delete)
                    Button("Cancel", action: close)
                }
            } else {
                VStack {
                    HStack {
                        Text(name)
                        Text(alternativeName)
                    }
                    Button("Add to Shopping Cart", action: addToShoppingCart)
                    Button("Edit", action: edit)
                    Button("Delete", action: delete)
                    Button("Cancel", action: close)
                }
            }
        }
        .padding()
        .onAppear(perform: populateExistingFields)
        .alert("Error", isPresented: $showError) {
            Button("OK") {
                showError = false
            }
        }
    }

    func populateExistingFields() {
        name = ingredient.name ?? ""
        alternativeName = ingredient.alternativeName ?? ""
    }

    func edit() {
        isEditing = true
    }

    func save() {
        ingredient.name = name
        ingredient.alternativeName = alternativeName
        saveData()
        close()
    }

    func delete() {
        viewContext.delete(ingredient)
        saveData()
        close()
    }

    func close() {
        presentationMode.wrappedValue.dismiss()
    }

    func addToShoppingCart() {
        ingredient.isInShoppingCart = true
        saveData()
        close()
    }

    private func saveData() {
        do {
            if viewContext.hasChanges {
                try viewContext.save()
            }
        } catch {
            self.error = error.localizedDescription
        }
    }
}

struct EditIngredientView_Previews: PreviewProvider {
    static var previews: some View {
        let ingredient: Ingredient = {
            let ingredient = Ingredient(context: PersistenceController.preview.container.viewContext)
            ingredient.name = "Hello!"
            return ingredient
        }()
        EditIngredientView(ingredient: ingredient)
    }
}
