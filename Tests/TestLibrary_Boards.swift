import XCTest
@testable import Catban

class TestLibrary_Boards:XCTestCase {
    private var library:Library!
    private var delegate:MockLibraryDelegate!
    private var cache:MockCache!
    private var database:MockDatabase!
    
    override func setUp() {
        super.setUp()
        Factory.cache = MockCache.self
        Factory.database = MockDatabase.self
        self.library = Library()
        self.delegate = MockLibraryDelegate()
        self.library.delegate = self.delegate
        self.cache = self.library.cache as? MockCache
        self.database = self.library.database as? MockDatabase
        self.library.session = Session()
        self.library.state = Library.stateReady
    }
    
    func testAddBoardSavesSession() {
        let expect:XCTestExpectation = self.expectation(description:"Session not saved")
        self.cache.onSaveSession = {
            XCTAssertFalse(self.library.session.boards.isEmpty, "Failed to add board")
            expect.fulfill()
        }
        DispatchQueue.global(qos:DispatchQoS.QoSClass.background).async {
            self.library.addBoard(identifier:String())
        }
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
    
    func testAddBoardNotRepeating() {
        let expect:XCTestExpectation = self.expectation(description:"Session not saved")
        let identifier:String = "hello world"
        self.library.session.add(board:identifier)
        self.cache.onSaveSession = {
            XCTAssertEqual(self.library.session.boards.count, 1, "Should be only 1 board")
            expect.fulfill()
        }
        self.library.addBoard(identifier:identifier)
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
    
    func testSaveBoardCallsDatabase() {
        let board:Board = Board()
        self.library.session.update(identifier:"a", board:board)
        let originalSyncstamp:Date = board.syncstamp
        let expect:XCTestExpectation = self.expectation(description:"Not saved")
        self.database.onSave = {
            XCTAssertNotEqual(originalSyncstamp, board.syncstamp, "Failed to update syncstamp")
            expect.fulfill()
        }
        self.library.save(board:board)
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
    
    func testDeleteBoardCallsCache() {
        let board:Board = Board()
        self.library.session.update(identifier:"a", board:board)
        let expect:XCTestExpectation = self.expectation(description:"Not deleted")
        self.cache.onSaveSession = {
            XCTAssertTrue(self.library.session.boards.isEmpty, "Not removed from session")
            XCTAssertTrue(self.library.boards.isEmpty, "Not removed boards")
            expect.fulfill()
        }
        self.library.delete(board:board)
        self.waitForExpectations(timeout:0.3, handler:nil)
    }
}