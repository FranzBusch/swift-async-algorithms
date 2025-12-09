import AsyncStreaming
import BasicContainers
import Testing

@Suite
struct AsyncReaderTests {
    @Test
    @available(macOS 26.0, iOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *)
    func readWithMaximumCount() async {
        var reader = SimpleReader(data: [1, 2, 3, 4, 5])

        let result = try! await reader.read { iterator in
          await iterator.nextSpan(
            maximumCount: 3
          ) { span in
            return Array(span.span)
          }
        }

        #expect(result == [1, 2, 3])
    }

    @Test
    @available(macOS 26.0, iOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *)
    func readWithoutMaximumCount() async {
        var reader = SimpleReader(data: [1, 2, 3, 4, 5])

        let result = try! await reader.read { iterator in
          await iterator.nextSpan(
            maximumCount: nil
          ) { span in
            return Array(span.span)
          }
        }

        #expect(result == [1, 2, 3, 4, 5])
    }
//
//    @Test
//    @available(macOS 26.0, iOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *)
//    func readEmptySpanAtEnd() async {
//        var reader = SimpleReader(data: [1, 2, 3])
//
//        // Read all data
//        _ = try! await reader.read { iterator in
//          await iterator.nextSpan(
//            maximumCount: nil
//          ) { span in
//            return Array(span.span)
//          }
//        }
//
//        // Next read should return empty span
//        let result = try! await reader.read(maximumCount: nil) { span in
//            return span.count
//        }
//
//        #expect(result == 0)
//    }
//
//    @Test
//    @available(macOS 26.0, iOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *)
//    func readMultipleChunks() async {
//        var reader = SimpleReader(data: [1, 2, 3, 4, 5, 6])
//        var chunks: [[Int]] = []
//
//        while true {
//            let chunk = try! await reader.read(maximumCount: 2) { span in
//                return Array(span)
//            }
//            if chunk.isEmpty {
//                break
//            }
//            chunks.append(chunk)
//        }
//
//        #expect(chunks == [[1, 2], [3, 4], [5, 6]])
//    }
//
//    @Test
//    @available(macOS 26.0, iOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *)
//    func readIntoCopyableElements() async {
//        var reader = SimpleReader(data: [1, 2, 3, 4, 5])
//        var buffer = RigidArray<Int>()
//        buffer.reserveCapacity(5)
//
//        await buffer.append(count: 5) { outputSpan in
//            await reader.read(into: &outputSpan)
//        }
//
//        #expect(buffer.count == 5)
//    }
}
