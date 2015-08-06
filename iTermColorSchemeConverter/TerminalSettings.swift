//
//  iTermColorSchemeConverter
//  Copyright (C) 2015 Leon Breedt
//

import Foundation
import AppKit

let DefaultWindowColumns = 90
let DefaultWindowRows = 50

/// Represents Terminal.app settings (which includes the color scheme).
class TerminalSettings : ColorScheme {
  private let dict: NSMutableDictionary
  
  init(name: String, dict: NSDictionary? = nil) {
    self.dict = NSMutableDictionary(dictionary: dict ?? [:])
    self.name = name
    
    setDefaultIfMissing("ProfileCurrentVersion", value: 2.04)
    setDefaultIfMissing("type", value: "Window Settings")
    setDefaultIfMissing("columnCount", value: DefaultWindowColumns)
    setDefaultIfMissing("rowCount", value: DefaultWindowRows)
  }
  
  func saveToFile(filePath: String) {
    dict.writeToFile(filePath, atomically: true)
  }
  
  var name: String {
    get { return (self.dict["name"] as? String) ?? "" }
    set { self.dict["name"] = newValue }
  }
  
  var windowColumns: Int {
    get { return (self.dict["columnCount"] as? Int) ?? 0 }
    set { self.dict["columnCount"] = newValue }
  }

  var windowRows: Int {
    get { return (self.dict["rowCount"] as? Int) ?? 0 }
    set { self.dict["rowCount"] = newValue }
  }
  
  var font: NSFont? {
    get {
      if let data = self.dict["Font"] as? NSData {
        return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSFont
      }
      return nil
    }
    set {
      self.dict["Font"] =
        newValue != nil
          ? NSKeyedArchiver.archivedDataWithRootObject(newValue!)
          : nil
    }
  }
  
  subscript(index: Color) -> NSColor? {
    get {
      if let colorKey = index.asTerminalColorKey() {
        if let data = dict[colorKey.rawValue] as? NSData {
          return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSColor
        }
      }
      return nil
    }
    set {
      if let colorKey = index.asTerminalColorKey() {
        if let color = newValue {
          dict[colorKey.rawValue] = NSKeyedArchiver.archivedDataWithRootObject(color)
        } else {
          dict.removeObjectForKey(colorKey.rawValue)
        }
      }
    }
  }
  
  private func setDefaultIfMissing(name: String, value: AnyObject) {
    let existingValue = dict[name]
    if existingValue == nil {
      dict[name] = value
    }
  }
}

enum TerminalColorKey : String {
  case AnsiBlack         = "ANSIBlackColor"
  case AnsiRed           = "ANSIRedColor"
  case AnsiGreen         = "ANSIGreenColor"
  case AnsiYellow        = "ANSIYellowColor"
  case AnsiBlue          = "ANSIBlueColor"
  case AnsiMagenta       = "ANSIMagentaColor"
  case AnsiCyan          = "ANSICyanColor"
  case AnsiWhite         = "ANSIWhiteColor"
  case AnsiBrightBlack   = "ANSIBrightBlackColor"
  case AnsiBrightRed     = "ANSIBrightRedColor"
  case AnsiBrightGreen   = "ANSIBrightGreenColor"
  case AnsiBrightYellow  = "ANSIBrightYellowColor"
  case AnsiBrightBlue    = "ANSIBrightBlueColor"
  case AnsiBrightMagenta = "ANSIBrightMagentaColor"
  case AnsiBrightCyan    = "ANSIBrightCyanColor"
  case AnsiBrightWhite   = "ANSIBrightWhiteColor"
  case Background        = "BackgroundColor"
  case Text              = "TextColor"
  case BoldText          = "BoldTextColor"
  case Selection         = "SelectionColor"
  case Cursor            = "CursorColor"
}

extension Color {
  func asTerminalColorKey() -> TerminalColorKey? {
    switch self {
    case .Black:         return TerminalColorKey.AnsiBlack
    case .Red:           return TerminalColorKey.AnsiRed
    case .Green:         return TerminalColorKey.AnsiGreen
    case .Yellow:        return TerminalColorKey.AnsiYellow
    case .Blue:          return TerminalColorKey.AnsiBlue
    case .Magenta:       return TerminalColorKey.AnsiMagenta
    case .Cyan:          return TerminalColorKey.AnsiCyan
    case .White:         return TerminalColorKey.AnsiWhite
    case .BrightBlack:   return TerminalColorKey.AnsiBrightBlack
    case .BrightRed:     return TerminalColorKey.AnsiBrightRed
    case .BrightGreen:   return TerminalColorKey.AnsiBrightGreen
    case .BrightYellow:  return TerminalColorKey.AnsiBrightYellow
    case .BrightBlue:    return TerminalColorKey.AnsiBrightBlue
    case .BrightMagenta: return TerminalColorKey.AnsiBrightMagenta
    case .BrightCyan:    return TerminalColorKey.AnsiBrightCyan
    case .BrightWhite:   return TerminalColorKey.AnsiBrightWhite
    case .Background:    return TerminalColorKey.Background
    case .Foreground:    return TerminalColorKey.Text
    case .Selection:     return TerminalColorKey.Selection
    case .Bold:          return TerminalColorKey.BoldText
    case .Cursor:        return TerminalColorKey.Cursor
    }
  }
}