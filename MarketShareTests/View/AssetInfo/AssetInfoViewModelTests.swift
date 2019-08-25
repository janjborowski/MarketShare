import XCTest
@testable import MarketShare

class AssetInfoViewModelTests: XCTestCase {

    private final class WorldBankFetcherMock: WorldBankFetcherProtocol {
        
        var mock_summary: Summary?
        
        func download(completion: @escaping (Summary?) -> Void) {
            completion(mock_summary)
        }
        
    }
    
    private var worldBankFetcher: WorldBankFetcherMock!
    private var sut: AssetInfoViewModel!
    
    override func setUp() {
        super.setUp()
        
        worldBankFetcher = WorldBankFetcherMock()
        sut = AssetInfoViewModel(worldBankFetcher: worldBankFetcher)
    }

    override func tearDown() {
        worldBankFetcher = nil
        sut = nil
        
        super.tearDown()
    }

    func testDownloadSummaries_ShouldCreateCellViewModels_WhenDataIsFetched() {
        worldBankFetcher.mock_summary = .tests_sample
        
        sut.downloadSummaries()
        
        XCTAssertEqual(sut.state.value, .fetched)
        XCTAssertEqual(sut.cellViewModels.count, 1)
        XCTAssertEqual(sut.cellViewModels.first!.name, Summary.tests_sample.entries.first?.name)
    }
    
    func testDownloadSummaries_ShouldNotCreateCellViewModels_WhenDataIsNotFetched() {
        sut.downloadSummaries()
        
        XCTAssertEqual(sut.state.value, .error)
        XCTAssertEqual(sut.cellViewModels.count, 0)
    }

}

private extension Summary {
    
    static var tests_sample: Summary {
        let entry = SummaryEntry(name: "Summary", value: 0, totalShare: 0)
        return Summary(name: "Total", entries: [entry])
    }
    
}
