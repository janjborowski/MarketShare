import Swinject
import UIKit

final class AppContainer {
    
    private let container = Container()
    
    var firstController: UIViewController {
        return container.resolve(AssetListViewController.self)!
    }
    
    init() {
        registerViewModels()
        registerControllers()
    }
    
    private func registerViewModels() {
        container.register(AssetListViewModelProtocol.self) { (resolver) -> AssetListViewModelProtocol in
            return AssetListViewModel()
        }
    }
    
    private func registerControllers() {
        container.register(AssetListViewController.self) { (resolver) -> AssetListViewController in
            let viewModel = resolver.resolve(AssetListViewModelProtocol.self)!
            return AssetListViewController(viewModel: viewModel)
        }
    }
    
}
