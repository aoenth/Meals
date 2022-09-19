//
//  SelectIngredientsView.swift
//  Meals
//
//  Created by Peng, Kevin [C] on 2022-09-18.
//

import SwiftUI

struct SelectIngredientsView: View {

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest
    private var items: FetchedResults<Ingredient>

    let dish: Dish?
    let didSelect: (Ingredient) -> Void


    init(dish: Dish?, didSelect: @escaping (Ingredient) -> Void) {
        let request = Ingredient.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Ingredient.name, ascending: true)]
        _items = FetchRequest(fetchRequest: request)
        self.dish = dish
        self.didSelect = didSelect
    }

    var body: some View {
        List {
            ForEach(items) { item in
                HStack {
                    if let ingredients = dish?.ingredients, ingredients.contains(item) {
                        Image(systemName: "checkmark")
                    }
                    Button(item.name!) {
                        didSelect(item)
                    }
                    .border(borderColor(item), width: borderWidth(item))
                }
            }
        }
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

struct SelectIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectIngredientsView(dish: nil) { _ in  }
    }
}
