@testable import App
import XCTVapor

final class ProduktTests: XCTestCase {
    let kategoria = Kategoria(title: "title 123")
    
    let produkt = Produkt(title: "title 123",
                          description: "desc 123",
                          image: "imgURL 123",
                          quantity: 123,
                          price: 123.456)
    
    func testCreate() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try kategoria.create(on: app.db).wait()
        produkt.$kategoria_id.id = kategoria.id!
        
        try app.test(.POST, "produkt", beforeRequest: { req in
            try req.content.encode(produkt)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode(Produkt.self)
            XCTAssertEqual(result.title, produkt.title)
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
        
        try app.test(.GET, "produkt", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode([Produkt].self)
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

        try app.test(.GET, "produkt/" + String(produkt.id!), afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode(Produkt.self)
            XCTAssertEqual(result, produkt)
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
        
        let expected = Produkt(id: produkt.id,
                               title: "title 321",
                               description: "desc 321",
                               image: "img",
                               quantity: 321,
                               price: 654.321)
        expected.$kategoria_id.id = kategoria.id!

        try app.test(.PUT, "produkt/" + String(produkt.id!), beforeRequest: { req in
            try req.content.encode(expected)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode(Produkt.self)
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

        try app.test(.DELETE, "produkt/" + String(produkt.id!), afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
        
        try kategoria.delete(on: app.db).wait()
    }
}
