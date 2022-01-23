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
        
        produkty.grouped("klient").get(":klientID", use: getOrderDetails)
    }

    func index(req: Request) throws -> EventLoopFuture<[ZamowienieProdukt]> {
        return ZamowienieProdukt.query(on: req.db)
            .all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<[ZamowienieProdukt]> {
        let produkty = try req.content.decode([ZamowienieProdukt].self)
        
        return produkty.map { produkt in
            produkt.save(on: req.db).map { produkt }
        }
        .flatten(on: req.eventLoop)
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
                produkt.$zamowienie_id.id = newProdukt.$zamowienie_id.id
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
    
    func getOrderDetails(req: Request) throws -> EventLoopFuture<[ZamowienieProdukt]> {
        return ZamowienieProdukt.query(on: req.db)
            .join(Zamowienie.self, on: \ZamowienieProdukt.$zamowienie_id.$id == \Zamowienie.$id)
            .filter(Zamowienie.self, \.$client_id == req.parameters.get("klientID"))
            .all()
    }
}
