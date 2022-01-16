import Fluent

struct CreateZamowienie: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("zamowienie")
            .id()
            .field("client_id", .uuid, .required)
            .field("price", .double, .required)
            .field("date", .datetime, .required)
            .field("paid", .bool, .required)
            .create()
        
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("zamowienie").delete()
    }
}
