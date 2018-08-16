import Foundation
import Catban
import CodableHero

class Cache:CacheService {
    private let codableHero:CodableHero
    
    required init() {
        self.codableHero = CodableHero()
    }
    
    func loadSession() throws -> Session {
        return try self.codableHero.load(path:Constants.session)
    }
    
    func save(session:Session) {
        do { try self.codableHero.save(model:session, path:Constants.session) } catch { }
    }
}

private struct Constants {
    static let session:String = "Session.catban"
}
