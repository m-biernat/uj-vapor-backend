@testable import App
import XCTVapor

final class KoszykTests: XCTestCase {
    let kategoria = Kategoria(title: "title 123")
    
    let produkt = Produkt(title: "title 123",
                          description: "desc 123",
                          image: "imgURL 123",
                          quantity: 123,
                          price: 123.456)
    
    let koszyk = Koszyk(client_id: UUID(uuidString: "00000000-1234-0000-0000-000000000000"),
                                        quantity: 123)
    
    func testCreate() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try kategoria.create(on: app.db).wait()
        produkt.$kategoria_id.id = kategoria.id!
        try produkt.create(on: app.db).wait()
        koszyk.$produkt_id.id = produkt.id!
        
        try app.test(.POST, "koszyk", beforeRequest: { req in
            try req.content.encode(koszyk)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode(Koszyk.self)
            XCTAssertEqual(result.quantity, produkt.quantity)
            try result.delete(on: app.db).wait()
        })
        
        try kategoria.delete(on: app.db).wait()
    }
    
    func testIndex() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try kategoria.create(on: app.db).wait()
        produkt.$kategoria_id.id = kategoria.id!
        try produkt.create(on: app.db).wait()
        koszyk.$produkt_id.id = produkt.id!
        try koszyk.create(on: app.db).wait()
        
        try app.test(.GET, "koszyk", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode([Koszyk].self)
            XCTAssertGreaterThan(result.count, 0)
        })
        
        try kategoria.delete(on: app.db).wait()
    }
    
    func testRead() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try kategoria.create(on: app.db).wait()
        produkt.$kategoria_id.id = kategoria.id!
        try produkt.create(on: app.db).wait()
        koszyk.$produkt_id.id = produkt.id!
        try koszyk.create(on: app.db).wait()

        try app.test(.GET, "koszyk/produkt/" + String(koszyk.id!), afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode(Koszyk.self)
            XCTAssertEqual(result, koszyk)
        })
        
        try kategoria.delete(on: app.db).wait()
    }
    
    func testUpdate() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try kategoria.create(on: app.db).wait()
        produkt.$kategoria_id.id = kategoria.id!
        try produkt.create(on: app.db).wait()
        koszyk.$produkt_id.id = produkt.id!
        try koszyk.create(on: app.db).wait()
        
        let expected = Koszyk(id: koszyk.id,
                              client_id: koszyk.client_id,
                              quantity: 321)
        expected.$produkt_id.id = produkt.id!

        try app.test(.PUT, "koszyk/produkt/" + String(koszyk.id!), beforeRequest: { req in
            try req.content.encode(expected)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode(Koszyk.self)
            XCTAssertEqual(result, expected)
        })
        
        try kategoria.delete(on: app.db).wait()
    }
    
    func testDelete() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try kategoria.create(on: app.db).wait()
        produkt.$kategoria_id.id = kategoria.id!
        try produkt.create(on: app.db).wait()
        koszyk.$produkt_id.id = produkt.id!
        try koszyk.create(on: app.db).wait()

        try app.test(.DELETE, "koszyk/produkt/" + String(koszyk.id!), afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
        
        try kategoria.delete(on: app.db).wait()
    }
    
    func testKlientRead() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try kategoria.create(on: app.db).wait()
        produkt.$kategoria_id.id = kategoria.id!
        try produkt.create(on: app.db).wait()
        koszyk.$produkt_id.id = produkt.id!
        try koszyk.create(on: app.db).wait()

        try app.test(.GET, "koszyk/" + String(koszyk.client_id!), afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode([Koszyk].self)
            XCTAssertGreaterThan(result.count, 0)
        })
        
        try kategoria.delete(on: app.db).wait()
    }
    
    func testKlientDelete() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try kategoria.create(on: app.db).wait()
        produkt.$kategoria_id.id = kategoria.id!
        try produkt.create(on: app.db).wait()
        koszyk.$produkt_id.id = produkt.id!
        try koszyk.create(on: app.db).wait()

        try app.test(.DELETE, "koszyk/" + String(koszyk.client_id!), afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
        
        try kategoria.delete(on: app.db).wait()
    }
}
