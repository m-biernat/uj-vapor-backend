import Fluent
import Vapor

final class Produkt: Model, Content {
    static let schema = "produkt"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "description")
    var description: String
    
    @Field(key: "image")
    var image: String
    
    @Field(key: "quantity")
    var quantity: Int
    
    @Field(key: "price")
    var price: Double
    
    @Parent(key: "kategoria_id")
    var kategoria_id: Kategoria
    
    init() { }

    init(id: UUID? = nil, title: String, description: String, image: String, quantity: Int, price: Double) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.quantity = quantity
        self.price = price
    }
}

extension Produkt: Equatable {
    static func == (lhs: Produkt, rhs: Produkt) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.description == rhs.description &&
            lhs.image == rhs.image &&
            lhs.quantity == rhs.quantity &&
            lhs.price == rhs.price &&
            lhs.$kategoria_id.id == rhs.$kategoria_id.id
    }
}
