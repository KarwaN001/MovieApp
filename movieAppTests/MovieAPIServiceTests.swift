
import XCTest
import RxSwift
@testable import movieApp

final class MovieAPIServiceTests: XCTestCase {

    var disposeBag: DisposeBag!
    var service: MovieAPIService!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        service = MovieAPIService()
    }

    override func tearDown() {
        disposeBag = nil
        service = nil
        super.tearDown()
    }

    func test_fetchMovies_success() {
        // Given
        let expectation = expectation(description: "Movies fetched successfully")

        // When
        service.fetchMovies()
            .subscribe(onNext: { movies in
                // Then
                XCTAssertFalse(movies.isEmpty, "Movies array should not be empty")
                XCTAssertNotNil(movies.first?.title)
                XCTAssertNotNil(movies.first?.year)
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Expected success, got error: \(error)")
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5.0)
    }

    func test_fetchMovies_invalidURL_shouldReturnError() {
        // Given
        let badService = MovieAPIServiceMockInvalidURL()
        let expectation = expectation(description: "Should fail due to invalid URL")

        // When
        badService.fetchMovies()
            .subscribe(onNext: { _ in
                XCTFail("Expected error, got success")
            }, onError: { error in
                // Then
                XCTAssertEqual((error as NSError).domain, "bad_url")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        wait(for: [expectation], timeout: 2.0)
    }
}

// MARK: - Mock for invalid URL
final class MovieAPIServiceMockInvalidURL: MovieAPIServiceProtocol {
    func fetchMovies() -> Observable<[Movie]> {
        return Observable.create { observer in
            observer.onError(NSError(domain: "bad_url", code: -1))
            return Disposables.create()
        }
    }
}
