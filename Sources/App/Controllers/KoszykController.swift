import Fluent
import Vapor

struct KoszykController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let koszyki = routes.grouped("koszyk")
        koszyki.get(use: index)
        koszyki.post(use: create)
        koszyki.get(":clientID", use: getKoszyk)
        koszyki.delete(":clientID", use: deleteKoszyk)
        
        let produkty = koszyki.grouped("produkt")
        produkty.get(":koszykID", use: read)
        produkty.put(":koszykID", use: update)
        produkty.delete(":koszykID", use: delete)
    }

    func index(req: Request) throws -> EventLoopFuture<[Koszyk]> {
        return Koszyk.query(on: req.db)
            .all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Koszyk> {
        let koszyk = try req.content.decode(Koszyk.self)
        return koszyk.save(on: req.db).map { koszyk }
    }
    
    func read(req: Request) throws -> EventLoopFuture<Koszyk> {
        return Koszyk.find(req.parameters.get("koszykID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func update(req: Request) throws -> EventLoopFuture<Koszyk> {
        let newKoszyk = try req.content.decode(Koszyk.self)
        return Koszyk.find(req.parameters.get("koszykID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { koszyk in
                koszyk.quantity = newKoszyk.quantity
                return koszyk.save(on: req.db)
                    .map { koszyk }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Koszyk.find(req.parameters.get("koszykID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    
    func getKoszyk(req: Request) throws -> EventLoopFuture<[Koszyk]> {
        return Koszyk.query(on: req.db)
            .filter(\.$client_id == req.parameters.get("clientID"))
            .all()
    }
    
    func deleteKoszyk(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Koszyk.query(on: req.db)
            .filter(\.$client_id == req.parameters.get("clientID"))
            .all()
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
