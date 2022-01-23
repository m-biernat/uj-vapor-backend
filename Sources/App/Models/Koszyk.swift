import Fluent
import Vapor

final class Koszyk: Model, Content {
    static let schema = "koszyk"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "client_id")
    var client_id: UUID?
    
    @Parent(key: "produkt_id")
    var produkt_id: Produkt
    
    @Field(key: "quantity")
    var quantity: Int
    
    init() { }

    init(id: UUID? = nil, client_id: UUID?, quantity: Int)
    {
        self.id = id
        self.client_id = client_id
        self.quantity = quantity
    }
}

extension Koszyk: Equatable {
    static func == (lhs: Koszyk, rhs: Koszyk) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.client_id == rhs.client_id &&
            lhs.$produkt_id.id == rhs.$produkt_id.id &&
            lhs.quantity == rhs.quantity
    }
}
