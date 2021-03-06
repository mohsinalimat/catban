import Foundation

class LibraryDefault:LibraryState {
    func loadBoards(context:Library) throws { throw Exception.noSession }
    func newBoard(context:Library) throws { throw Exception.noSession }
    func addBoard(context:Library, url:String) throws { throw Exception.noSession }
    func merge(context:Library, boards:[String]) throws { throw Exception.noSession }
    
    func loadSession(context:Library) {
        context.queue.async { [weak self] in
            do {
                self?.loaded(context:context, session:try context.cache.loadSession())
            } catch {
                self?.avoidBackup()
                self?.loaded(context:context, session:Session())
            }
        }
    }
    
    private func loaded(context:Library, session:Session) {
        context.session = session
        context.saveSession()
        context.state = Library.stateReady
        DispatchQueue.main.async { context.delegate?.librarySessionLoaded() }
    }
    
    private func avoidBackup() {
        var url = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)[0]
        var resources = URLResourceValues()
        resources.isExcludedFromBackup = true
        try! url.setResourceValues(resources)
    }
}
