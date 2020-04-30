import Foundation

class VendingMachineProduct {
    var name: String
    var amount: Int
    var price: Double
    
    init(name: String, amount: Int, price: Double) {
        self.name = name
        self.amount = amount
        self.price = price
    }
}

enum VendingMachineError: Error {
    case souPobre
    case productNotFound
    case productUnavailable
    case insufficientMoney
    case productStuck
}

extension VendingMachineError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .souPobre:
            return "Parece que você não tem dinheiro e é uma pessoa pobre, então eu coloquei um dinheiro para você, tente de novo."
        case .productNotFound:
            return "Esse produto nesta máquina não existe."
        case .productUnavailable:
            return "Esse produto acabou na máquina,"
        case .insufficientMoney:
            return "Você não inseriu dinheiro suficiente."
        case .productStuck:
            return "O produto ficou preso dentro da máquina."
        }
    }
}

class VendingMachine {
    private var estoque: [VendingMachineProduct]
    private var money: Double
    
    init(products: [VendingMachineProduct]) {
        self.estoque = products
        self.money = 0
    }
    
    func getProduct(named name: String, with money: Double) throws {
        self.money += money
        if (self.money == 0) {
            self.money += 100
            throw VendingMachineError.souPobre
        }
        let produtoOptional = estoque.first { (produto) -> Bool in
            return produto.name == name
        }
        guard let produto = produtoOptional else { throw VendingMachineError.productNotFound}
        guard produto.amount > 0  else { throw VendingMachineError.productUnavailable }
        guard produto.price <= self.money else { throw VendingMachineError.insufficientMoney}
        
        self.money -= produto.price
        produto.amount -= 1
        
        if (Int.random(in: 0...100) < 10) {
            throw VendingMachineError.productStuck
        }
        if (self.money != 0.0) {
            let troco = getTroco()
            print("Seu troco é \(troco)")
        }
    }
    
    func getTroco() -> Double {
        let money = self.money
        self.money = 0
        return money
    }
}

let vendingMachine = VendingMachine(products: [
    VendingMachineProduct(name: "Carregador de iPhone", amount: 2, price: 150.00),
    VendingMachineProduct(name: "Funnions", amount: 5, price: 5.00),
    VendingMachineProduct(name: "Xiaomi Umbrella", amount: 3, price: 50.00),
    VendingMachineProduct(name: "Trator", amount: 1, price: 150000.00)
])

do {
    try vendingMachine.getProduct(named: "Xiaomi Umbrella", with: 0)
} catch {
    print(error.localizedDescription)
}

do {
    try vendingMachine.getProduct(named: "Funnions", with: 0)
} catch {
    print(error.localizedDescription)
}
