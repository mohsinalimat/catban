import UIKit
import CleanArchitecture
import Catban

class BoardPresenter:Presenter {
    var interactor:BoardInteractor!
    var viewModels:ViewModels!
    private(set) var state:BoardState = BoardStateDefault()
    
    required init() { }
    
    func detach(item:BoardCardView) {
        interactor.detach(card:item.card, column:item.column)
        item.column = nil
    }
    
    func attach(item:BoardCardView, after:BoardItemView) {
        interactor.attach(card:item.card, column:after.column, after:after.card)
        item.column = after.column
    }
    
    func delete() {
        interactor.delete()
    }
    
    @objc func edit() {
        interactor.edit()
    }
    
    @objc func info() {
        Application.router.dismiss(animated:false)
        interactor.info()
    }
    
    @objc func share() {
        Application.router.dismiss(animated:false)
        interactor.share()
    }
    
    @objc func newColumn() {
        interactor.newColumn()
    }
    
    @objc func editColumn(view:BoardItemView) {
        interactor.editColumn(column:view.column!)
    }
    
    @objc func newCard(view:BoardItemView) {
        interactor.newCard(column:view.column!)
    }
    
    @objc func editCard(view:BoardCardView) {
        interactor.editCard(column:view.column!, card:view.card!)
    }
    
    func search(text:String) {
        state = BoardStateSearch(text:text)
        updateViewModel()
    }
    
    func clearSearch() {
        state = BoardStateDefault()
        updateViewModel()
    }
    
    func updateProgress() {
        DispatchQueue.global(qos:.background).async { [weak self] in
            guard let stats = self?.interactor.makeStats() else { return }
            var viewModel = BoardProgress()
            viewModel.progress = stats.progress
            viewModel.columns = stats.columns
            self?.viewModels.update(viewModel:viewModel)
        }
    }
    
    func didAppear() {
        updateViewModel()
        updateProgress()
    }
    
    private func updateViewModel() {
        var viewModel = BoardTitle()
        viewModel.title = interactor.board.text
        viewModels.update(viewModel:viewModel)
    }
}
