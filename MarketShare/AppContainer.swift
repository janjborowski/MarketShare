import Swinject
import UIKit

final class AppContainer {
    
    private let container = Container()
    
    var firstController: UIViewController {
        return container.resolve(AssetListViewController.self)!
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
        
        container.register(WorldBankFetcherProtocol.self) { (resolver) -> WorldBankFetcherProtocol in
            let networkingCache = resolver.resolve(NetworkingCache.self)!
            return WorldBankFetcher(cache: networkingCache)
        }
    }
    
    private func registerViewModels() {
        container.register(AssetListViewModelProtocol.self) { (resolver) -> AssetListViewModelProtocol in
            return AssetListViewModel()
        }
        
        container.register(AssetInfoViewModelProtocol.self) { (resolver) -> AssetInfoViewModelProtocol in
            let worldBankFetcher = resolver.resolve(WorldBankFetcherProtocol.self)!
            return AssetInfoViewModel(worldBankFetcher: worldBankFetcher)
        }
    }
    
    private func registerControllers() {
        container.register(AssetListViewController.self) { (resolver) -> AssetListViewController in
            let viewModel = resolver.resolve(AssetListViewModelProtocol.self)!
            let flowController = AssetListViewControllerFlowController { self.create()! }
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
