extension Optional where Wrapped: ~Copyable {
    @inlinable
    mutating func takeSending() -> sending Self {
        let result = consume self
        self = nil
        return result
    }
}
