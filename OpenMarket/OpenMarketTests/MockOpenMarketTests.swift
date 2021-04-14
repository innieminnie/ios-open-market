import XCTest
@testable import OpenMarket

class MockOpenMarketTests: XCTestCase {
    var sut: OpenMarketAPIManager!

    override func setUpWithError() throws {
        super.setUp()
        sut = .init(session: MockURLSession())
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    func testFetchingProductListofPageOne() {
        let expectation = XCTestExpectation()
        let response = try? JSONDecoder().decode(ProductList.self, from: MockAPI.test.sampleItems.data)

        sut.requestProductList(of: 1) { (result) in
            switch result {
            case .success(let productList):
                let randomNumber = Int.random(in: 0..<productList.items.count)
                
                XCTAssertEqual(productList.items[randomNumber].id, response?.items[randomNumber].id)
                XCTAssertEqual(productList.items[randomNumber].currency, response?.items[randomNumber].currency)
                XCTAssertEqual(productList.items[randomNumber].price, response?.items[randomNumber].price)
                XCTAssertEqual(productList.items[randomNumber].discountedPrice, response?.items[randomNumber].discountedPrice)
                XCTAssertEqual(productList.items[randomNumber].registrationDate, response?.items[randomNumber].registrationDate)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchingProductListofPageOneFailure() {
        sut = .init(session: MockURLSession(makeRequestFail: true))
        let expectation = XCTestExpectation()

        sut.requestProductList(of: 1) { (result) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.self, .invalidData)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
