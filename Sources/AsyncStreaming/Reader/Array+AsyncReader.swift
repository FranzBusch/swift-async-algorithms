@available(macOS 26.0, iOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *)
extension Array {
    /// Creates an async reader that provides access to the array's elements.
    ///
    /// This method converts an array into an ``AsyncReader`` implementation, allowing
    /// the array's elements to be read through the async reader interface.
    ///
    /// - Returns: An ``AsyncReader`` that produces all elements of the array.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let numbers = [1, 2, 3, 4, 5]
    /// var reader = numbers.asyncReader()
    ///
    /// try await reader.forEach { span in
    ///     print("Read \(span.count) numbers")
    /// }
    /// ```
  public func asyncReader() -> some AsyncReader<Element, Never> & SendableMetatype & ~Escapable {
      return ArrayAsyncReader(array: self)
    }
}

/// An async reader implementation that provides array elements through the AsyncReader interface.
///
/// This internal reader type wraps an array and delivers its elements through the ``AsyncReader``
/// protocol. It maintains a current read position and can deliver elements in chunks based on
/// the requested maximum count.
@available(macOS 26.0, iOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *)
struct ArrayAsyncReader<Element>: AsyncReader, BorrowMutableIteratorProtocol {
    typealias ReadIterator = Self
    typealias Element = Element
    typealias ReadElement = Element
    typealias ReadFailure = Never

    var array: [Element]
    var index: Array<Element>.Index

    init(array: [Element]) {
        self.array = array
        self.index = array.startIndex
    }

  mutating func nextSpan<Return, Failure>(
    maximumCount: Int?,
    body: (inout MutableSpan<Element>) async throws(Failure) -> Return
  ) async throws(Failure) -> Return {
    guard self.index < self.array.endIndex else {
      var mutableSpan = self.array.mutableSpan
      var empty = mutableSpan._mutatingExtracting(last: 0)

      return try await body(&empty)
    }

    guard let maximumCount else {
      let index = self.index
      self.index = self.array.span.indices.endIndex
      var mutableSpan = self.array.mutableSpan
      var sizedMutableSpan = mutableSpan._mutatingExtracting(index...)
      return try await body(&sizedMutableSpan)
    }
    let endIndex = min(
      self.array.span.indices.endIndex,
      self.index.advanced(
        by: maximumCount
      )
    )
    self.index = endIndex
    let index = self.index
    var mutableSpan = self.array.mutableSpan
    var sizedMutableSpan = mutableSpan._mutatingExtracting(index..<endIndex)
    return try await body(&sizedMutableSpan)
  }

    mutating func read<Return, Failure>(
      body: (inout ArrayAsyncReader<Element>) async throws(Failure) -> Return
    ) async throws(EitherError<Never, Failure>) -> Return {
      do {
        return try await body(&self)
      } catch {
        throw.second(error)
      }
    }
}
