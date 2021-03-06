import UIKit
import Catban
import MarkdownHero

class BoardDrawer {
    weak var firstColumn:BoardItemView?
    weak var nextColumn:BoardItemView?
    weak var view:BoardView! { didSet { hero.font = .systemFont(
        ofSize:CGFloat(view.presenter.cardsFont), weight:.light) } }
    
    private weak var nextItem:BoardItemView?
    private let hero = Hero()
    private let options = NSStringDrawingOptions([.usesFontLeading, .usesLineFragmentOrigin])
    private let size = CGSize(width:BoardDrawer.columnWidth, height:10000)
    private static let columnWidth:CGFloat = 270
    
    func draw() {
        clearContent()
        view.presenter.board.columns.forEach { column in
            makeHeader(column:column)
            column.cards.forEach{ card in
                view.presenter.state.makeCard(drawer:self, column:column, card:card)
            }
            view.presenter.state.makeNewCard(drawer:self, column:column)
        }
        view.presenter.state.makeNewColumn(drawer:self)
    }
    
    func makeCard(column:Column, card:Card) {
        let text = hero.parse(string:card.content)
        let textSize = text.boundingRect(with:size, options:options, context:nil).size
        let textWidth = min(ceil(textSize.width + 10), BoardDrawer.columnWidth)
        let item = BoardCardView()
        item.column = column
        item.card = card
        item.label.attributedText = text
        item.add(target:view.presenter, selector:#selector(view.presenter.editCard(view:)))
        item.dragGesture.addTarget(view, action:#selector(view.dragCard(pan:)))
        item.longGesture.addTarget(view, action:#selector(view.long(gesture:)))
        addItem(item:item)
        layout(item:item, height:ceil(textSize.height) + 10, width:textWidth)
    }
    
    func makeNewCard(column:Column) {
        let item = BoardButtonView()
        item.column = column
        item.image.image = #imageLiteral(resourceName: "assetNew.pdf").withRenderingMode(.alwaysTemplate)
        item.add(target:view.presenter, selector:#selector(view.presenter.newCard(view:)))
        addItem(item:item)
        layout(item:item, height:40, width:40)
    }
    
    func makeNewColumn() {
        let item = BoardButtonView()
        item.image.image = #imageLiteral(resourceName: "assetNew.pdf").withRenderingMode(.alwaysTemplate)
        item.add(target:view.presenter, selector:#selector(view.presenter.newColumn))
        addColumn(item:item)
        layout(item:item, height:40, width:40)
    }
    
    private func makeHeader(column:Column) {
        let item = BoardHeaderView()
        item.column = column
        item.label.text = column.name
        item.add(target:view.presenter, selector:#selector(view.presenter.editColumn(view:)))
        addColumn(item:item)
        layout(item:item, height:40, width:BoardDrawer.columnWidth)
    }
    
    private func clearContent() {
        firstColumn = nil
        view.content.subviews.forEach { view in view.removeFromSuperview() }
    }
    
    private func layout(item:BoardItemView, height:CGFloat, width:CGFloat) {
        nextItem = item
        view.content.addSubview(item)
        item.top = item.topAnchor.constraint(equalTo:view.content.topAnchor)
        item.left = item.leftAnchor.constraint(equalTo:view.content.leftAnchor)
        item.width = item.widthAnchor.constraint(equalToConstant:width)
        item.height = item.heightAnchor.constraint(equalToConstant:height)
        item.top.isActive = true
        item.left.isActive = true
        item.width.isActive = true
        item.height.isActive = true
    }
    
    private func addItem(item:BoardItemView) {
        item.up = nextItem
        nextItem!.down = item
    }
    
    private func addColumn(item:BoardItemView) {
        if firstColumn == nil {
            firstColumn = item
        }
        nextColumn?.right = item
        nextColumn = item
    }
}
