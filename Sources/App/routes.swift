import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    try app.register(collection: ProduktController())
    try app.register(collection: KategoriaController())
    try app.register(collection: KoszykController())
    try app.register(collection: ZamowienieController())
    try app.register(collection: ZamowienieProduktController())
}
