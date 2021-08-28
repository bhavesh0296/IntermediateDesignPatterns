/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Facade
 - - - - - - - - - -
 ![Multicast Delegate Diagram](Facade_Diagram.png)
 
 The facade pattern is a structural pattern that provides a simple interface to a complex system. It involves two types:
 
 1. The **facade** provides simple methods to interact with the system. This allows consumers to use the facade instead of knowing about and interacting with multiple classes in the system.
 
 2. The **dependencies** are objects owned by the facade. Each dependency performs a small part of a complex task.
 
 ## Code Example
 */
import UIKit

public struct Customer {
    public let identifier: String
    public let name: String
    public let address: String
}

extension Customer: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    public static func ==(lhs: Customer, rhs: Customer) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

public struct Product {
    public let identifier: String
    public let name: String
    public let cost: Double
}

extension Product: Hashable {
    public func hasher(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    public static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

public class InventoryDatabase {
    public var inventory: [Product: Int] = [:]

    public init(inventory: [Product: Int]) {
        self.inventory = inventory
    }
}

public class ShippingDatabase {
    public var pendingShippments: [Customer: [Product]] = [:]
}

public class OrderFacade {
    public let inventoryDatabase: InventoryDatabase
    public let shippingDatabase: ShippingDatabase

    public init(inventoryDatabase: InventoryDatabase,
                shippingDatabase: ShippingDatabase) {

        self.inventoryDatabase = inventoryDatabase
        self.shippingDatabase = shippingDatabase
    }

    public func placeOrder(for product: Product,
                           by customer: Customer) {

        print("Place order for \(product.name) by \(customer.name)")

        let count = inventoryDatabase.inventory[product, default: 0]
        guard count > 0 else {
            print("\(product.name) is out of Stock :( ")
            return
        }

        inventoryDatabase.inventory[product] = count - 1

        var shipments = shippingDatabase.pendingShippments[customer, default: []]
        shipments.append(product)
        shippingDatabase.pendingShippments[customer] = shipments

        print("Order placed for \(product.name) by \(customer.name)")
    }
}

let rayDoodle = Product(identifier: "product-001", name: "Ray Doodle", cost: 0.25)

let vickiPoodle = Product(identifier: "product-002", name: "Vicki Poddle", cost: 1000)

let inventaryDatabase = InventoryDatabase(inventory: [rayDoodle: 100,
                                                      vickiPoodle: 2])

let orderFacade = OrderFacade(inventoryDatabase: inventaryDatabase, shippingDatabase: ShippingDatabase())

let customer = Customer(identifier: "customer-001", name: "Bhavesh", address: "New Delhi")

orderFacade.placeOrder(for: rayDoodle, by: customer)
