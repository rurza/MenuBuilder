import Cocoa

/// A standard menu item.
///
/// See ``AnyMenuItem`` for a listing of supported modifiers.
public struct MenuItem: AnyMenuItem {
    public typealias Modifier = (NSMenuItem) -> ()
    /// An array of functions that configure the menu item instance
    /// These may be called to update an existing menu item.
    fileprivate let modifiers: [Modifier]

    public func apply(_ modifier: @escaping Modifier) -> Self {
        Self(modifiers: modifiers + [modifier])
    }
    private init(modifiers: [Modifier]) {
        self.modifiers = modifiers
    }

    /// Creates a menu item with the given title.
    public init(_ title: String) {
        modifiers = [{ item in item.title = title }]
    }

    /// Creates a menu item with the given attributed title.
    public init(_ title: NSAttributedString) {
        modifiers = [{ item in
            item.title = title.string
            item.attributedTitle = title
        }]
    }

    /// Creates a menu item with the given attributed title.
    @available(macOS 12, *)
    public init(_ title: AttributedString) {
        modifiers = [{ item in
            item.title = title.description
            item.attributedTitle = NSAttributedString(title)
        }]
    }
}

extension MenuBuilder {
    public static func buildExpression(_ expr: MenuItem?) -> [NSMenuItem] {
        if let description = expr {
            let item = NSMenuItem()
            description.modifiers.forEach { $0(item) }
            return [item]
        }
        return []
    }
}
