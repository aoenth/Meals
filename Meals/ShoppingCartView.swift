//
//  ShoppingCartView.swift
//  Meals
//
//  Created by Peng, Kevin [C] on 2022-09-17.
//

import SwiftUI

struct ShoppingCartView: View {

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest
    private var items: FetchedResults<Ingredient>

    @State private var error = ""
    @State private var showError = false

    init() {
        let request = Ingredient.fetchRequest()
        request.predicate = NSPredicate(format: "isInShoppingCart = true")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Ingredient.name, ascending: true)]
        _items = FetchRequest(fetchRequest: request)
    }

    var body: some View {
        NavigationView {
            List(items) { item in
                HStack {
                    Text(item.name!)
                    Button(action: { remove(ingredient: item) }) {
                        Label("Remove", systemImage: "cart.badge.minus")
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Add all to Fridge", action: addAllToFridge)
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") {
                    showError = false
                }
            }
        }
    }

    func addAllToFridge() {
        items.forEach { item in
            item.isInShoppingCart = false
            item.isInFridge = true
        }

        saveData()
    }

    func remove(ingredient: Ingredient) {
        ingredient.isInShoppingCart = false
    }

    func saveData() {
        do {
            if viewContext.hasChanges {
                try viewContext.save()
            }
        } catch {
            self.error = error.localizedDescription
            showError = true
        }
    }
}

struct ShoppingCartView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingCartView()
    }
}
