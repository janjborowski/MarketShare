import XCTest
@testable import MarketShare

class AssetInfoViewModelTests: XCTestCase {

    private final class WorldBankFetcherMock: WorldBankFetcherProtocol {
    
        var mock_summary: Summary?
        
        func download(asset: Asset, completion: @escaping (Summary?) -> Void) {
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
        let firstEntry = Summary.tests_sample.entries.first!
        worldBankFetcher.mock_summary = .tests_sample
        
        sut.downloadSummaries()
        
        XCTAssertEqual(sut.state.value, .fetched)
        XCTAssertEqual(sut.cellViewModels.count, 1)
        XCTAssertEqual(sut.cellViewModels.first!.name, firstEntry.name)
        XCTAssertEqual(sut.pieChartEntries.count, 1)
        XCTAssertEqual(sut.pieChartEntries.first!.label, firstEntry.name)
        XCTAssertEqual(sut.pieChartEntries.first!.value, 0)
    }
    
    func testDownloadSummaries_ShouldCreateTenPieChartEntries_AndOtherOne_WhenThereAreManyEntries() {
        worldBankFetcher.mock_summary = .tests_huge
        
        sut.downloadSummaries()
        
        XCTAssertEqual(sut.state.value, .fetched)
        XCTAssertEqual(sut.cellViewModels.count, Summary.tests_huge.entries.count)
        XCTAssertEqual(sut.pieChartEntries.count, 11)
        XCTAssertEqual(sut.pieChartEntries.last!.label, "Others")
        XCTAssertTrue(sut.pieChartEntries.last!.value.isCloseEnough(to: 0.6367346938775508))
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
    
    static var tests_huge: Summary {
        let elements = Array(0..<50).reversed()
        let sumOfAll = elements.reduce(0, +)
        let entries = elements.map { SummaryEntry(
            name: "Entry",
            value: Decimal($0),
            totalShare: Decimal($0)/Decimal(sumOfAll)
        ) }
        return Summary(name: "Total", entries: entries)
    }
    
}

private extension Double {
    
    func isCloseEnough(to value: Double) -> Bool {
        return fabs(self - value) < Double.ulpOfOne
    }
    
}
