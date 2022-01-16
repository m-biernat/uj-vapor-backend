import Fluent
import Vapor

struct ZamowienieProduktController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let produkty = routes.grouped("zamowienie").grouped("produkt")
        produkty.get(use: index)
        produkty.post(use: create)
        produkty.get(":produktID", use: read)
        produkty.put(":produktID", use: update)
        produkty.delete(":produktID", use: delete)
    }

    func index(req: Request) throws -> EventLoopFuture<[ZamowienieProdukt]> {
        return ZamowienieProdukt.query(on: req.db)
            .all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<ZamowienieProdukt> {
        let produkt = try req.content.decode(ZamowienieProdukt.self)
        return produkt.save(on: req.db).map { produkt }
    }
    
    func read(req: Request) throws -> EventLoopFuture<ZamowienieProdukt> {
        return ZamowienieProdukt.find(req.parameters.get("produktID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func update(req: Request) throws -> EventLoopFuture<ZamowienieProdukt> {
        let newProdukt = try req.content.decode(ZamowienieProdukt.self)
        return ZamowienieProdukt.find(req.parameters.get("produktID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { produkt in
                produkt.produkt_id = newProdukt.produkt_id
                produkt.title = newProdukt.title
                produkt.quantity = newProdukt.quantity
                produkt.price = newProdukt.price
                produkt.zamowienie_id = newProdukt.zamowienie_id
                return produkt.save(on: req.db)
                    .map { produkt }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return ZamowienieProdukt.find(req.parameters.get("produktID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
