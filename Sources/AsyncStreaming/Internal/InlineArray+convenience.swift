@available(macOS 26.0, iOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *)
extension InlineArray where Element: ~Copyable {
    package static func one(value: consuming Element) -> InlineArray<1, Element> {
        return InlineArray<1, Element>(first: value) { _ in fatalError() }
    }

    package static func zero(of elementType: Element.Type = Element.self) -> InlineArray<0, Element> {
        return InlineArray<0, Element> { _ in }
    }
}
