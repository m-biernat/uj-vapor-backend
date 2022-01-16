import Fluent

struct CreateZamowienieProdukt: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("zamowienieProdukt")
            .id()
            .field("produkt_id", .uuid, .required)
            .field("title", .string, .required)
            .field("quantity", .int, .required)
            .field("price", .double, .required)
            .field("zamowienie_id", .uuid, .required)
            .foreignKey("zamowienie_id", references: Zamowienie.schema, .id, onDelete: .cascade, onUpdate: .noAction)
            .create()
        
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("zamowienieProdukt").delete()
    }
}
