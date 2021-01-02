import XCTest
@testable import OSLogHandler
@testable import Logging

var gLogger: Logger!

final class OSLogHandlerTests: XCTestCase {

    override class func setUp() {
        print("bootstrap logging system")
        LoggingSystem.bootstrap { (label) -> LogHandler in
            return OSLogHandler(label: label,
                                category: "test_cate")
        }

        gLogger = Logger(label: "test_label")
        gLogger[metadataKey: "metakey"] = "metavalue"
    }

    func testExample() {
        gLogger.info("123")
    }

    func testABC() {
        gLogger.info("abc")
    }

    func testMergeMetadata() {
        gLogger.info("has more metadata", metadata: ["haha": "hahahah"])
    }

    func testShortFileName() {
        let logger = Logger(label: "testShortFileName") { (label) -> LogHandler in
            return OSLogHandler(label: label, formatter: OSLogDefaultFormatter(shortFileName: { $0 }))
        }
        logger.info("log with full filename")
    }

    static var allTests = [
        ("testExample", testExample),
        ("testABC", testABC),
    ]
}
