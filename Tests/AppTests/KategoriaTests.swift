@testable import App
import XCTVapor

final class KategoriaTests: XCTestCase {
    let kategoria = Kategoria(title: "title 123")
    
    func testCreate() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.test(.POST, "kategoria", beforeRequest: { req in
            try req.content.encode(kategoria)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode(Kategoria.self)
            XCTAssertEqual(result.title, kategoria.title)
            try result.delete(on: app.db).wait()
        })
    }
    
    func testIndex() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try kategoria.create(on: app.db).wait()
        
        try app.test(.GET, "kategoria", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode([Kategoria].self)
            XCTAssertGreaterThan(result.count, 0)
        })
        
        try kategoria.delete(on: app.db).wait()
    }
    
    func testRead() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try kategoria.create(on: app.db).wait()

        try app.test(.GET, "kategoria/" + String(kategoria.id!), afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode(Kategoria.self)
            XCTAssertEqual(result, kategoria)
        })
        
        try kategoria.delete(on: app.db).wait()
    }
    
    func testUpdate() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try kategoria.create(on: app.db).wait()
        let expected = Kategoria(id: kategoria.id, title: "title 321")

        try app.test(.PUT, "kategoria/" + String(kategoria.id!), beforeRequest: { req in
            try req.content.encode(expected)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let result = try res.content.decode(Kategoria.self)
            XCTAssertEqual(result, expected)
        })
        
        try kategoria.delete(on: app.db).wait()
    }
    
    func testDelete() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try kategoria.create(on: app.db).wait()

        try app.test(.DELETE, "kategoria/" + String(kategoria.id!), afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
        
        try kategoria.delete(on: app.db).wait()
    }
}
