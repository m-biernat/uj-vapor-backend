import Fluent
import Vapor

struct ProduktController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let produkty = routes.grouped("produkt")
        produkty.get(use: index)
        produkty.post(use: create)
        produkty.get(":produktID", use: read)
        produkty.put(":produktID", use: update)
        produkty.delete(":produktID", use: delete)
    }

    func index(req: Request) throws -> EventLoopFuture<[Produkt]> {
        return Produkt.query(on: req.db)
            .all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Produkt> {
        let produkt = try req.content.decode(Produkt.self)
        return produkt.save(on: req.db).map { produkt }
    }
    
    func read(req: Request) throws -> EventLoopFuture<Produkt> {
        return Produkt.find(req.parameters.get("produktID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func update(req: Request) throws -> EventLoopFuture<Produkt> {
        let newProdukt = try req.content.decode(Produkt.self)
        return Produkt.find(req.parameters.get("produktID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { produkt in
                produkt.title = newProdukt.title
                produkt.description = newProdukt.description
                produkt.image = newProdukt.image
                produkt.quantity = newProdukt.quantity
                produkt.price = newProdukt.price
                produkt.$kategoria_id.id = newProdukt.$kategoria_id.id
                return produkt.save(on: req.db)
                    .map { produkt }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Produkt.find(req.parameters.get("produktID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
