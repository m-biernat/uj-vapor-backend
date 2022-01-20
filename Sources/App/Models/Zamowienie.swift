import Fluent
import Vapor

final class Zamowienie: Model, Content {
    static let schema = "zamowienie"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "client_id")
    var client_id: UUID?
    
    @Field(key: "price")
    var price: Double
    
    @Field(key: "date")
    var date: String
    
    @Field(key: "paid")
    var paid: Bool
    
    init() { }

    init(id: UUID? = nil, client_id: UUID?, price: Double, date: String, paid: Bool) {
        self.id = id
        self.client_id = client_id
        self.price = price
        self.date = date
        self.paid = paid
    }
}
