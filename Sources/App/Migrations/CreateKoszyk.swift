import Fluent

struct CreateKoszyk: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("koszyk")
            .id()
            .field("client_id", .uuid, .required)
            .field("quantity", .int, .required)
            .field("produkt_id", .uuid, .required)
            .foreignKey("produkt_id", references: Produkt.schema, .id, onDelete: .cascade, onUpdate: .noAction)
            .create()
        
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("koszyk").delete()
    }
}
