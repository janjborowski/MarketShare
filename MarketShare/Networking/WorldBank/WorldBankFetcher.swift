import Foundation

protocol WorldBankFetcherProtocol {
    
    func download(completion: @escaping (Summary?) -> Void)
    
}

final class WorldBankFetcher: WorldBankFetcherProtocol {
    
    private let path = "https://api.worldbank.org/v2/en/countries/all/indicator/CM.MKT.LCAP.CD?format=json&date=2018&per_page=300"
    private let queue = OperationQueue()
    
    func download(completion: @escaping (Summary?) -> Void) {
        let apiFetcher = APIFetcher(path: path)
        let worldBankMapper = MapWorldBankData()
        let createWorldBankSummary = CreateWorldBankSummary()
        
        let apiToWorldBankPasser = BlockOperation {
            worldBankMapper.inputData = apiFetcher.data
        }
        let mapToCreatePasser = BlockOperation {
            createWorldBankSummary.inputData = worldBankMapper.worldBankResponse
        }
        let outputPasser = BlockOperation {
            completion(createWorldBankSummary.summary)
        }
        
        outputPasser.addDependency(createWorldBankSummary)
        createWorldBankSummary.addDependency(mapToCreatePasser)
        mapToCreatePasser.addDependency(worldBankMapper)
        worldBankMapper.addDependency(apiToWorldBankPasser)
        apiToWorldBankPasser.addDependency(apiFetcher)
        
        [apiFetcher, apiToWorldBankPasser, worldBankMapper, mapToCreatePasser, createWorldBankSummary, outputPasser].forEach { queue.addOperation($0) }
    }
    
}
