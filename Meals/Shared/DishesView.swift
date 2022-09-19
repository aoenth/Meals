//
//  DishesView.swift
//  Meals
//
//  Created by Peng, Kevin [C] on 2022-09-17.
//

import SwiftUI
import CoreData

struct DishesView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Dish.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Dish>

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            EditDishView(dish: item)
                        } label: {
                            Text(item.name!)
                        }
                        .contextMenu(ContextMenu {
                            Button("Delete") { deleteItem(item )}
                        })
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        let newItem = Dish(context: viewContext)
        newItem.name = "New Dish"
    }

    private func performAddItem() {
        withAnimation {
            let newItem = Dish(context: viewContext)
            newItem.name = ""

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

    private func deleteItem(_ item: Dish) {
        withAnimation {
            viewContext.delete(item)

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

struct DishesView_Previews: PreviewProvider {
    static var previews: some View {
        DishesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
