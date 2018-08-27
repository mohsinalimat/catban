import XCTest
@testable import Catban

class TestLibrary_Ready:XCTestCase {
    private var library:Library!
    private var delegate:MockLibraryDelegate!
    
    override func setUp() {
        Factory.cache = MockCache.self
        Factory.database = MockDatabase.self
        library = Library()
        delegate = MockLibraryDelegate()
        library.delegate = delegate
        library.state = Library.stateReady
    }
    
    func testLoadUpdatesEmptyBoards() {
        let expect = expectation(description:String())
        delegate.onBoardsUpdated = {
            XCTAssertEqual(Thread.main, Thread.current)
            expect.fulfill()
        }
        DispatchQueue.global(qos:.background).async { do { try self.library.loadBoards() } catch {} }
        waitForExpectations(timeout:1, handler:nil)
    }
    
    func testLoadUpdatesNonEmptyBoards() {
        let expect = expectation(description:String())
        library.session.boards["a"] = Board()
        library.session.boards["b"] = Board()
        delegate.onBoardsUpdated = {
            XCTAssertEqual(self.library.boards.count, self.library.session.boards.count)
            XCTAssertEqual(Thread.main, Thread.current)
            expect.fulfill()
        }
        DispatchQueue.global(qos:.background).async { do { try self.library.loadBoards() } catch {} }
        waitForExpectations(timeout:1, handler:nil)
    }
    
    func testNewBoardAddsBoardAndNotifiesDelegate() {
        let expectLoad = expectation(description:String())
        let expectCreate = expectation(description:String())
        let expectSaveSession = expectation(description:String())
        (library.database as! MockDatabase).onCreate = { expectCreate.fulfill() }
        (library.cache as! MockCache).onSaveSession = { expectSaveSession.fulfill() }
        delegate.onCreated = {
            XCTAssertFalse(self.library.session.boards.isEmpty)
            XCTAssertFalse(self.library.boards.isEmpty)
            XCTAssertEqual(Thread.main, Thread.current)
            expectLoad.fulfill()
        }
        DispatchQueue.global(qos:.background).async { self.library.newBoard() }
        waitForExpectations(timeout:1, handler:nil)
    }
}