//
//  PortfolioDataService.swift
//  Crypto
//
//  Created by Pratyush  on 6/19/21.
//

import Foundation
import SwiftUI
import CoreData

class PortfolioDataService: ObservableObject {
    
    static let instance = PortfolioDataService()
    private let entityName: String = "PortfolioEntity"
    private let container: NSPersistentContainer
    @Published var fetchedPorfolio: [PortfolioEntity] = []
    
    private init() {
        container = NSPersistentContainer(name: "PortfolioContainer")
        container.loadPersistentStores { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        getPortfolio()
    }
}

//MARK:- User intent
extension PortfolioDataService {
    func updatePorfolio(coin: Coin, amount: Double) {
        if let entity = fetchedPorfolio.first(where: { $0.coinID == coin.id } ) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
}

//MARK:- Private helpers
private extension PortfolioDataService {
    
    func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            fetchedPorfolio = try container.viewContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func add(coin: Coin, amount: Double) {
        let entity: PortfolioEntity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func applyChanges() {
        save()
        getPortfolio()
    }
    
}
