/// An enumeration that represents one of two possible error types.
///
/// ``EitherError`` provides a type-safe way to represent errors that can be one of two distinct
/// error types.
public enum EitherError<First: Error, Second: Error>: Error {
    /// An error of the first type.
    ///
    /// The associated value contains the specific error instance of type `First`.
    case first(First)

    /// An error of the second type.
    ///
    /// The associated value contains the specific error instance of type `Second`.
    case second(Second)

    /// Throws the underlying error by unwrapping this either error.
    ///
    /// This method extracts and throws the actual error contained within the either error,
    /// whether it's the first or second type. This is useful when you need to propagate
    /// the original error without the either error wrapper.
    ///
    /// - Throws: The underlying error, either of type `First` or `Second`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// do {
    ///     // Some operation that returns EitherError
    ///     let result = try await operation()
    /// } catch let eitherError as EitherError<NetworkError, ParseError> {
    ///     try eitherError.unwrap() // Throws the original error
    /// }
    /// ```
    public func unwrap() throws {
        switch self {
        case .first(let first):
            throw first
        case .second(let second):
            throw second
        }
    }
}

@available(macOS 26.0, iOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *)
struct File {
    @_lifetime(&self)
    mutating func read() async -> Span<UInt8> {
        fatalError()
    }
    
    mutating func write(span: Span<UInt8>) async {
        fatalError()
    }
}
