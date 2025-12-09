extension Array {
    init(_ span: Span<Element>) {
        self.init()
        for index in span.indices {
            self.append(span[index])
        }
    }

    mutating func append(span: Span<Element>) {
        for index in span.indices {
            self.append(span[index])
        }
    }
}
