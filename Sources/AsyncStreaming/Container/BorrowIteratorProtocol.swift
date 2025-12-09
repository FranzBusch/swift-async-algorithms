@available(macOS 26.0, iOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *)
public protocol BorrowMutableIteratorProtocol<Element>: ~Copyable, ~Escapable {
  associatedtype Element: ~Copyable

  // TODO: This is using a closure since we need the exclusive modifier to be
  // able to extract mutable spans from the underlying owning buffer
  mutating func nextSpan<Return, Failure>(
    maximumCount: Int?,
    body: (inout MutableSpan<Element>) async throws(Failure) -> Return
  ) async throws(Failure) -> Return
}
