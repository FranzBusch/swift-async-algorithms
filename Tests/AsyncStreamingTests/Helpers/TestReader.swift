import AsyncStreaming
import BasicContainers

@available(macOS 26.0, iOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *)
struct SimpleReader: AsyncReader, BorrowMutableIteratorProtocol {
    typealias ReadElement = Int
    typealias ReadFailure = Never
  typealias ReadIterator = Self

    var data: [Int]
    var position: Int = 0

  mutating func nextSpan<Return, Failure>(
    maximumCount: Int?,
    body: (inout MutableSpan<ReadElement>) async throws(Failure) -> Return
  ) async throws(Failure) -> Return {
    guard position < data.count else {
      var mutableSpan = self.data.mutableSpan
      var empty = mutableSpan._mutatingExtracting(last: 0)
      return try await body(&empty)
    }

    let count: Int
    if let maximumCount {
      count = min(maximumCount, data.count - position)
    } else {
      count = data.count - position
    }

    let endIndex = position + count
    defer { position = endIndex }

    var slicedData = self.data[position..<endIndex]
    var mutableSpan = slicedData.mutableSpan
    return try await body(&mutableSpan)
  }

    mutating func read<Return, Failure: Error>(
        body: (inout ReadIterator) async throws(Failure) -> Return
    ) async throws(EitherError<Never, Failure>) -> Return {
        do {
            return try await body(&self)
        } catch {
            throw .second(error)
        }
    }
}
