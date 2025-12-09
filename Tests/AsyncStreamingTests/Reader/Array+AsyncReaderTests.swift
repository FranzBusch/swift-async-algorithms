import AsyncStreaming
import Testing

@Suite
struct ArrayAsyncReaderTests {
    @Test
    @available(macOS 26.0, iOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *)
    func oneSpan() async throws {
        let array = [1, 2, 3].asyncReader()
        var counter = 0
        await array.forEach { span in
            counter += 1
            #expect(span.count == 3)
        }
        #expect(counter == 1)
    }

    @Test
    @available(macOS 26.0, iOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *)
    func multipleSpans() async throws {
        var array = [1, 2, 3].asyncReader()
        var counter = 0
        var continueReading = true
        while continueReading {
            await array.forEach { span in
                guard span.count > 0 else {
                    continueReading = false
                    return
                }
                counter += 1
                #expect(span.count == 1)
            }
        }
        #expect(counter == 3)
    }
}
