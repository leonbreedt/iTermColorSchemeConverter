//
//  iTermColorSchemeConverter
//  Copyright (C) 2015 Leon Breedt
//

import Foundation
import AppKit

/// The set of well known colors for a terminal emulator.
enum Color {
  case Black
  case Red
  case Green
  case Yellow
  case Blue
  case Magenta
  case Cyan
  case White
  case BrightBlack
  case BrightRed
  case BrightGreen
  case BrightYellow
  case BrightBlue
  case BrightMagenta
  case BrightCyan
  case BrightWhite
  
  case Background
  case Foreground
  case Selection
  case Bold
  case Cursor
}

/// Represents a color scheme, which is a named collection of well known colors.
protocol ColorScheme {
  /// The human-readable name of the color scheme.
  var name: String { get set }
  
  /// Save the color scheme to a file
  func saveToFile(filePath: String)
  
  /// Returns the NSColor for the well known color identified by index. If the scheme does not
  /// have a value for the supplied index, nil is returned.
  subscript(index: Color) -> NSColor? { get set }
}