@testable import App
import XCTVapor

final class ZamowienieTests: XCTestCase {
    let zamowienie = Zamowienie(client_id: UUID(uuidString: "00000000-1234-0000-0000-000000000000"),
                                price: 123.456,
                                date: "2022-01-22T22:00:00+00:00",
                                paid: false)
    
    func testCreate() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.test(.POST, "zamowienie", beforeRequest: { req in
            try req.content.encode(zamowienie)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode(Zamowienie.self)
            XCTAssertEqual(result.client_id, zamowienie.client_id)
            try result.delete(on: app.db).wait()
        })
    }
    
    func testIndex() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try zamowienie.create(on: app.db).wait()
        
        try app.test(.GET, "zamowienie", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode([Zamowienie].self)
            XCTAssertGreaterThan(result.count, 0)
        })
        
        try zamowienie.delete(on: app.db).wait()
    }
    
    func testRead() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try zamowienie.create(on: app.db).wait()

        try app.test(.GET, "zamowienie/" + String(zamowienie.id!), afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode(Zamowienie.self)
            XCTAssertEqual(result, zamowienie)
        })
        
        try zamowienie.delete(on: app.db).wait()
    }
    
    func testUpdate() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try zamowienie.create(on: app.db).wait()
        let expected = Zamowienie(id: zamowienie.id,
                                  client_id: zamowienie.client_id,
                                  price: 654.321,
                                  date: zamowienie.date,
                                  paid: true)

        try app.test(.PUT, "zamowienie/" + String(zamowienie.id!), beforeRequest: { req in
            try req.content.encode(expected)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode(Zamowienie.self)
            XCTAssertEqual(result, expected)
        })
        
        try zamowienie.delete(on: app.db).wait()
    }
    
    func testDelete() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try zamowienie.create(on: app.db).wait()

        try app.test(.DELETE, "zamowienie/" + String(zamowienie.id!), afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
        
        try zamowienie.delete(on: app.db).wait()
    }
    
    func testKlientRead() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try zamowienie.create(on: app.db).wait()

        try app.test(.GET, "zamowienie/klient/" + String(zamowienie.client_id!), afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode([Zamowienie].self)
            XCTAssertGreaterThan(result.count, 0)
            
        })
        
        try zamowienie.delete(on: app.db).wait()
    }
}
