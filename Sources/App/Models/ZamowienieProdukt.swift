import Fluent
import Vapor

final class ZamowienieProdukt: Model, Content {
    static let schema = "zamowienieProdukt"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "produkt_id")
    var produkt_id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "quantity")
    var quantity: Int
    
    @Field(key: "price")
    var price: Double
    
    @Parent(key: "zamowienie_id")
    var zamowienie_id: Zamowienie
    
    init() { }

    init(id: UUID? = nil, produkt_id: UUID?, title: String, quantity: Int, price: Double) {
        self.id = id
        self.produkt_id = produkt_id
        self.title = title
        self.quantity = quantity
        self.price = price
    }
}
