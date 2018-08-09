import UIKit
import CleanArchitecture

class ScanPresenter:Presenter {
    weak var interactor:LibraryInteractor!
    var viewModels:ViewModels!
    private let qr:Qr
    
    required init() {
        self.qr = Qr()
    }
    
    func read(string:String) {
        let components:[String] = string.components(separatedBy:ShareConstants.prefix)
        if components.count == 2 && !components[1].isEmpty {
            let identifier:String = components[1]
            if self.interactor.duplicated(identifier:identifier) {
                self.show(message:NSLocalizedString("ScanPresenter.duplicate", comment:String()), icon:#imageLiteral(resourceName: "assetError.pdf"))
            } else {
                self.interactor.addBoard(identifier:identifier)
                self.show(message:NSLocalizedString("ScanPresenter.success", comment:String()), icon:#imageLiteral(resourceName: "assetValid.pdf"))
            }
        } else {
            self.show(message:NSLocalizedString("ScanPresenter.error", comment:String()), icon:#imageLiteral(resourceName: "assetError.pdf"))
        }
    }
    
    func read(image:UIImage) {
        self.read(string:qr.read(image:image))
    }
    
    func didLoad() {
        var viewModel:ScanViewModel = ScanViewModel()
        viewModel.alphaCamera = 1.0
        self.viewModels.update(viewModel:viewModel)
    }
    
    private func show(message:String, icon:UIImage) {
        var viewModel:ScanViewModel = ScanViewModel()
        viewModel.alphaMessage = 1.0
        viewModel.text = message
        viewModel.icon = icon
        self.viewModels.update(viewModel:viewModel)
    }
}