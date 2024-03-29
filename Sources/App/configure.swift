import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateProdukt())
    app.migrations.add(CreateKategoria())
    app.migrations.add(CreateKoszyk())
    app.migrations.add(CreateZamowienie())
    app.migrations.add(CreateZamowienieProdukt())
    // register routes
    try routes(app)
}
