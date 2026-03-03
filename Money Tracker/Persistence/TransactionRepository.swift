//
//  TransactionRepository.swift
//  Money Tracker
//
//  Created by Zeeshan Waheed on 03/03/2026.
//

import CoreData

final class TransactionRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Create
    
    func save(_ transaction: Transaction) throws {
        let cdTransaction = CDTransaction(context: context)
        
        cdTransaction.id = transaction.id
        cdTransaction.amount = transaction.amount
        cdTransaction.date = transaction.date
        cdTransaction.type = transaction.type == .income ? "income" : "expense"
        cdTransaction.categoryIcon = transaction.category
        
        try context.save()
    }
    
    // MARK: - Read
    
    func fetchAll() throws -> [Transaction] {
        let request: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let results = try context.fetch(request)
        
        return results.map { cd in
            Transaction(
                id: cd.id!,
                amount: cd.amount,
                date: cd.date!,
                type: cd.type == "income" ? .income : .expense,
                category: cd.categoryIcon!
            )
        }
    }
    
    // MARK: - Update
    func update(_ transaction: Transaction) throws {
        
        let request: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", transaction.id as CVarArg)
        
        if let existing = try context.fetch(request).first {
            existing.amount = transaction.amount
            existing.date = transaction.date
            existing.type = transaction.type == .income ? "income" : "expense"
            existing.categoryIcon = transaction.category
            
            try context.save()
        }
    }
        
    
    // MARK: - Delete
    
    func delete(id: UUID) throws {
        let request: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        if let result = try context.fetch(request).first {
            context.delete(result)
            try context.save()
        }
    }
}
