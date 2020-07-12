#if os(macOS)
import AppKit
import Core

extension NSColor {
    var color: Color {
        {
            .init(red: .init($0.redComponent), green: .init($0.greenComponent), blue: .init($0.blueComponent))
        } (usingColorSpace(.sRGB)!)
    }
}
#endif
