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

    @State private var editingIngredient: Ingredient?

    init(dish: Dish?) {
        let request = Ingredient.fetchRequest()
        if let dish = dish, let name = dish.name {
            request.predicate = NSPredicate(format: "dishes.name contains[cd] %@", name)
        }
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Ingredient.name, ascending: true)]
        _items = FetchRequest(fetchRequest: request)
    }

    var body: some View {
        List {
            ForEach(items) { item in
                Button(item.name!) {
                    editingIngredient = item
                }
                .border(Color.green, width: item.isInShoppingCart ? 1 : 0)
            }
            .onDelete(perform: deleteItems)
        }
        .sheet(item: $editingIngredient) { ingredient in
            EditIngredientView(ingredient: ingredient)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

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
