import Foundation

final public class Board:Codable {
    public var name = String()
    public private(set) var columns = [Column]()
    var syncstamp = Date()
    
    public func addColumn(text:String) {
        let column = Column()
        column.name = text
        columns.append(column)
    }
    
    public func delete(column:Column) {
        columns.removeAll { item -> Bool in item === column }
    }
    
    public func moveRight(card:Card) {
        for index in 0 ..< columns.count - 1 {
            if columns[index].cards.contains(where: { item in item === card } ) {
                columns[index].delete(card:card)
                columns[index + 1].makeFirst(card:card)
                break
            }
        }
    }
}
