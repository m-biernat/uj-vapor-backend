import Fluent
import Vapor

struct KategoriaController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let kategorie = routes.grouped("kategoria")
        kategorie.get(use: index)
        kategorie.post(use: create)
        kategorie.get(":kategoriaID", use: read)
        kategorie.put(":kategoriaID", use: update)
        kategorie.delete(":kategoriaID", use: delete)
    }

    func index(req: Request) throws -> EventLoopFuture<[Kategoria]> {
        return Kategoria.query(on: req.db)
            .all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Kategoria> {
        let kategoria = try req.content.decode(Kategoria.self)
        return kategoria.save(on: req.db).map { kategoria }
    }
    
    func read(req: Request) throws -> EventLoopFuture<Kategoria> {
        return Kategoria.find(req.parameters.get("kategoriaID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func update(req: Request) throws -> EventLoopFuture<Kategoria> {
        let newKategoria = try req.content.decode(Kategoria.self)
        return Kategoria.find(req.parameters.get("kategoriaID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { kategoria in
                kategoria.title = newKategoria.title
                return kategoria.save(on: req.db)
                    .map { kategoria }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Kategoria.find(req.parameters.get("kategoriaID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
