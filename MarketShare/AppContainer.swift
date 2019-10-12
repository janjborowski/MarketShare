import Swinject
import UIKit

final class AppContainer {
    
    private let container = Container()
    
    var firstController: UIViewController {
        let viewModel = AssetListViewModel()
        let flowController = AssetListViewControllerFlowController(
            infoViewControllerFetcher: { self.create()! },
            listViewControllerFetcher: { self.create()! }
        )
        let viewController = AssetListViewController(viewModel: viewModel, flowController: flowController)
        viewController.configure(cells: AssetListViewModel.initialCellViewModels, name: "Assets")
        return viewController
    }
    
    init() {
        registerModelsAndNetworking()
        registerViewModels()
        registerControllers()
    }
    
    private func registerModelsAndNetworking() {
        container.register(NetworkingCache.self) { (resolver) -> NetworkingCache in
            return PersistentNetworkingCache()
        }
        
        container.register(FetcherDispatcher.self) { (resolver) -> FetcherDispatcher in
            let networkingCache = resolver.resolve(NetworkingCache.self)!
            return FetcherDispatcherDefault(cache: networkingCache)
        }
    }
    
    private func registerViewModels() {
        container.register(AssetListViewModelProtocol.self) { (resolver) -> AssetListViewModelProtocol in
            return AssetListViewModel()
        }
        
        container.register(AssetInfoViewModelProtocol.self) { (resolver) -> AssetInfoViewModelProtocol in
            let fetcherDispatcher = resolver.resolve(FetcherDispatcher.self)!
            return AssetInfoViewModel(fetcherDispatcher: fetcherDispatcher)
        }
    }
    
    private func registerControllers() {
        container.register(AssetListViewController.self) { (resolver) -> AssetListViewController in
            let viewModel = resolver.resolve(AssetListViewModelProtocol.self)!
            let flowController = AssetListViewControllerFlowController(
                infoViewControllerFetcher: { self.create()! },
                listViewControllerFetcher: { self.create()! }
            )
            return AssetListViewController(viewModel: viewModel, flowController: flowController)
        }
        
        container.register(AssetInfoViewController.self) { (resolver) -> AssetInfoViewController in
            let viewModel = resolver.resolve(AssetInfoViewModelProtocol.self)!
            return AssetInfoViewController(viewModel: viewModel)
        }
    }
    
    func create<T>() -> T? {
        return container.resolve(T.self)
    }
    
}
