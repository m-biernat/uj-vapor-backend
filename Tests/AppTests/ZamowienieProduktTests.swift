@testable import App
import XCTVapor

final class ZamowienieProduktTests: XCTestCase {
    let zamowienie = Zamowienie(client_id: UUID(uuidString: "00000000-1234-0000-0000-000000000000"),
                                price: 123.456,
                                date: "2022-01-22T22:00:00+00:00",
                                paid: false)
    
    let zamowienieProdukt = ZamowienieProdukt(produkt_id: UUID(uuidString: "00000000-0000-0000-4321-000000000000"),
                                              title: "title 123",
                                              quantity: 123,
                                              price: 123.456)

    func testCreate() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try zamowienie.create(on: app.db).wait()
        zamowienieProdukt.$zamowienie_id.id = zamowienie.id!
        
        try app.test(.POST, "zamowienie/produkt", beforeRequest: { req in
            try req.content.encode([zamowienieProdukt])
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let results = try res.content.decode([ZamowienieProdukt].self)
            XCTAssertGreaterThan(results.count, 0)
            try results.forEach { try $0.delete(on: app.db).wait() }
        })
        
        try zamowienie.delete(on: app.db).wait()
    }
    
    func testIndex() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try zamowienie.create(on: app.db).wait()
        zamowienieProdukt.$zamowienie_id.id = zamowienie.id!
        try zamowienieProdukt.create(on: app.db).wait()
        
        try app.test(.GET, "zamowienie/produkt", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode([ZamowienieProdukt].self)
            XCTAssertGreaterThan(result.count, 0)
        })
        
        try zamowienie.delete(on: app.db).wait()
    }
    
    func testRead() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try zamowienie.create(on: app.db).wait()
        zamowienieProdukt.$zamowienie_id.id = zamowienie.id!
        try zamowienieProdukt.create(on: app.db).wait()

        try app.test(.GET, "zamowienie/produkt/" + String(zamowienieProdukt.id!), afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode(ZamowienieProdukt.self)
            XCTAssertEqual(result, zamowienieProdukt)
        })
        
        try zamowienie.delete(on: app.db).wait()
    }
    
    func testUpdate() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try zamowienie.create(on: app.db).wait()
        zamowienieProdukt.$zamowienie_id.id = zamowienie.id!
        try zamowienieProdukt.create(on: app.db).wait()
        
        let expected = ZamowienieProdukt(id: zamowienieProdukt.id,
                                         produkt_id: zamowienieProdukt.produkt_id,
                                         title: "title 321",
                                         quantity: 321,
                                         price: 654.321)
        expected.$zamowienie_id.id = zamowienie.id!

        try app.test(.PUT, "zamowienie/produkt/" + String(zamowienieProdukt.id!), beforeRequest: { req in
            try req.content.encode(expected)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode(ZamowienieProdukt.self)
            XCTAssertEqual(result, expected)
        })
        
        try zamowienie.delete(on: app.db).wait()
    }
    
    func testDelete() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try zamowienie.create(on: app.db).wait()
        zamowienieProdukt.$zamowienie_id.id = zamowienie.id!
        try zamowienieProdukt.create(on: app.db).wait()

        try app.test(.DELETE, "zamowienie/produkt/" + String(zamowienieProdukt.id!), afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
        
        try zamowienie.delete(on: app.db).wait()
    }
    
    func testKlientRead() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try zamowienie.create(on: app.db).wait()
        zamowienieProdukt.$zamowienie_id.id = zamowienie.id!
        try zamowienieProdukt.create(on: app.db).wait()

        try app.test(.GET, "zamowienie/produkt/klient/" + String(zamowienie.client_id!), afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode([ZamowienieProdukt].self)
            XCTAssertGreaterThan(result.count, 0)
        })
        
        try zamowienie.delete(on: app.db).wait()
    }
}
