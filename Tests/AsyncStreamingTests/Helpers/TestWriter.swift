import AsyncStreaming
import BasicContainers

struct TestWriter: AsyncWriter {
    typealias WriteElement = Int
    typealias WriteFailure = Never

    var storage: [Int] = []
    let capacity: Int

    init(capacity: Int = 100) {
        self.capacity = capacity
    }

    mutating func write<Result, Failure: Error>(
        _ body: (inout OutputSpan<Int>) async throws(Failure) -> Result
    ) async throws(EitherError<Never, Failure>) -> Result {
        do {
            let count = min(10, capacity - storage.count)
            var buffer = RigidArray<Int>(capacity: count)

            return try await buffer.append(count: count) { outputSpan async throws(Failure) -> Result in
                let result = try await body(&outputSpan)
                storage.append(span: outputSpan.span)
                return result
            }
        } catch {
            throw .second(error)
        }
    }

    mutating func write(
        _ span: Span<Int>
    ) async throws(EitherError<Never, AsyncWriterWroteShortError>) {
        guard span.count <= capacity - storage.count else {
            throw .second(AsyncWriterWroteShortError())
        }
        storage.append(span: span)
    }
}
