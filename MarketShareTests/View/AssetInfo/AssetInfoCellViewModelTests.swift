import XCTest
@testable import MarketShare

class AssetInfoCellViewModelTests: XCTestCase {

    func testValue_ShouldFormatShare() {
        let entry = SummaryEntry(name: "Country", value: 10, totalShare: 0.45)
        
        let sut = AssetInfoCellViewModel(entry: entry)
        
        XCTAssertEqual(sut.value, "45%")
    }
    
}
