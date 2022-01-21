//
//  ItemsViewModel.swift
//  Firebase-Intro
//
//  Created by David Svensson on 2022-01-21.
//

import Foundation
import Firebase

class ItemsViewModel: ObservableObject {
    @Published var items = [Item]()
    
    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    
    
    func listenToFirestore(uid : String) {
        db.collection("users").document(uid).collection("items").addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else { return }
            
            if let err = err {
                print("Error getting document \(err)")
            } else {
                self.items.removeAll()
                for document in snapshot.documents {
                    let result = Result {
                        try document.data(as: Item.self)
                    }
                    switch result {
                    case .success(let item) :
                        if let item = item {
                            self.items.append(item)
                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding item: \(error)")
                    }
                }
            }
        }
    }
    
    func toggle(item: Item) {
        guard let uid = auth.currentUser?.uid else {return}
        
        if let id = item.id {
            db.collection("users").document(uid).collection("items").document(id).updateData(["done" : !item.done ] )
        }
    }
    
    func saveToFirestore(itemName: String) {
        guard let uid = auth.currentUser?.uid else {return}
        
        let item = Item(name: itemName)
        
        do {
            _ = try db.collection("users").document(uid).collection("items").addDocument(from: item)
        } catch {
            print("Error saving to DB")
        }
    }
    
    func deleteItem(at indexSet: IndexSet) {
        guard let uid = auth.currentUser?.uid else {return}
        
        for index in indexSet {
            let item = items[index]
            if let id = item.id {
                db.collection("users").document(uid).collection("items").document(id).delete()
            }
        }
    }
}
