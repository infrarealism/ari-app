#if os(macOS)
import AppKit
import Core

extension NSColor {
    var color: Color {
        {
            .init(red: $0.redComponent, green: $0.greenComponent, blue: $0.blueComponent)
        } (usingColorSpace(.sRGB)!)
    }
}
#endif
