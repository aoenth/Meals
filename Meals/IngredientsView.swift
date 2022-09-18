//
//  IngredientsView.swift
//  Meals
//
//  Created by Peng, Kevin [C] on 2022-09-17.
//

import SwiftUI
import CoreData

struct IngredientsView: View {

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest
    private var items: FetchedResults<Ingredient>

    let dish: Dish?

    @State private var editingIngredient: Ingredient?
    @State private var error = ""
    @State private var showError = false

    init(dish: Dish?) {
        let request = Ingredient.fetchRequest()
        if let dish = dish, let name = dish.name {
            request.predicate = NSPredicate(format: "dishes.name contains[cd] %@", name)
        }
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Ingredient.name, ascending: true)]
        _items = FetchRequest(fetchRequest: request)
        self.dish = dish
    }

    var body: some View {
        ForEach(items) { item in
            Button(item.name ?? "New Ingredient") {
                editingIngredient = item
            }
            .border(borderColor(item), width: borderWidth(item))
        }
        .onDelete(perform: deleteItems)
        .toolbar {
            ToolbarItem {
                if dish == nil {
                    Button("Add New Ingredient", action: addNewIngredient)
                }
            }
        }
        .sheet(item: $editingIngredient) { ingredient in
            EditIngredientView(ingredient: ingredient)
        }
        .alert(error, isPresented: $showError) {
            Button("OK") {
                showError.toggle()
            }
        }
    }

    func addNewIngredient() {
        let ingredient = Ingredient(context: viewContext)

        if let dish = dish {
            dish.addToIngredients(ingredient)
        }

        editingIngredient = ingredient
    }

    private func borderColor(_ item: Ingredient) -> Color {
        switch (item.isInFridge, item.isInShoppingCart) {
        case (true, true):
            return Color.red
        case (true, false):
            return Color.green
        case (false, true):
            return Color.yellow
        case (false, false):
            return Color.clear
        }
    }

    private func borderWidth(_ item: Ingredient) -> CGFloat {
        switch (item.isInFridge, item.isInShoppingCart) {
        case (false, false):
            return 0
        default:
            return 1
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            if let dish = dish {
                offsets.forEach {
                    dish.removeFromIngredients(items[$0])
                }
            } else {
                offsets.map { items[$0] }.forEach(viewContext.delete)
            }

            saveData()
        }
    }

    func saveData() {
        do {
            if viewContext.hasChanges {
                try viewContext.save()
            }
        } catch {
            self.error = error.localizedDescription
            showError.toggle()
        }
    }
}

struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        let dish: Dish = {
            let dish = Dish(context: PersistenceController.preview.container.viewContext)
            dish.name = "Hello!"
            return dish
        }()
        IngredientsView(dish: dish)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
