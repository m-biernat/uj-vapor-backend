import Fluent
import Vapor

struct ZamowienieController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let zamowienia = routes.grouped("zamowienie")
        zamowienia.get(use: index)
        zamowienia.post(use: create)
        zamowienia.get(":zamowienieID", use: read)
        zamowienia.put(":zamowienieID", use: update)
        zamowienia.delete(":zamowienieID", use: delete)
    }

    func index(req: Request) throws -> EventLoopFuture<[Zamowienie]> {
        return Zamowienie.query(on: req.db)
            .all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Zamowienie> {
        let zamowienie = try req.content.decode(Zamowienie.self)
        return zamowienie.save(on: req.db).map { zamowienie }
    }
    
    func read(req: Request) throws -> EventLoopFuture<Zamowienie> {
        return Zamowienie.find(req.parameters.get("zamowienieID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func update(req: Request) throws -> EventLoopFuture<Zamowienie> {
        let newZamowienie = try req.content.decode(Zamowienie.self)
        return Zamowienie.find(req.parameters.get("zamowienieID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { zamowienie in
                zamowienie.client_id = newZamowienie.client_id
                zamowienie.price = newZamowienie.price
                zamowienie.date = newZamowienie.date
                zamowienie.paid = newZamowienie.paid
                return zamowienie.save(on: req.db)
                    .map { zamowienie }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Zamowienie.find(req.parameters.get("zamowienieID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
