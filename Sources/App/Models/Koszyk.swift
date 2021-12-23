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
