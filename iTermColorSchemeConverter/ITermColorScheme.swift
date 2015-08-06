//
//  iTermColorSchemeConverter
//  Copyright (C) 2015 Leon Breedt
//

import Foundation
import AppKit

/// Represents an iTerm2 color scheme (.itermcolors file).
class ITermColorScheme : ColorScheme {
  private let dict: NSMutableDictionary
  
  init(name: String, dict: NSDictionary? = nil) {
    self.dict = NSMutableDictionary(dictionary: dict ?? [:])
    self.name = name
    
    initializeColors()
  }
  
  var name: String
  
  func saveToFile(filePath: String) {
    dict.writeToFile(filePath, atomically: true)
  }
  
  subscript(index: Color) -> NSColor? {
    get {
      if let colorKey = index.asITermColorKey(),
         let colorDict = dict[colorKey.rawValue] as? NSMutableDictionary,
         let r = colorDict[ITermColorComponentKey.Red.rawValue] as? CGFloat,
         let g = colorDict[ITermColorComponentKey.Green.rawValue] as? CGFloat,
         let b = colorDict[ITermColorComponentKey.Blue.rawValue] as? CGFloat
      {
        return NSColor(deviceRed: r, green: g, blue: b, alpha: 1)
      }
      return nil
    }
    set {
      if let colorKey = index.asITermColorKey() {
        if let color = newValue {
          setColor(colorKey, r: color.redComponent, g: color.greenComponent, b: color.blueComponent)
        } else {
          dict.removeObjectForKey(colorKey.rawValue)
        }
      }
    }
  }
  
  private func initializeColors() {
    setBlackIfMissing(ITermColorKey.Ansi0)
    setBlackIfMissing(ITermColorKey.Ansi1)
    setBlackIfMissing(ITermColorKey.Ansi2)
    setBlackIfMissing(ITermColorKey.Ansi3)
    setBlackIfMissing(ITermColorKey.Ansi4)
    setBlackIfMissing(ITermColorKey.Ansi5)
    setBlackIfMissing(ITermColorKey.Ansi6)
    setBlackIfMissing(ITermColorKey.Ansi7)
    setBlackIfMissing(ITermColorKey.Ansi8)
    setBlackIfMissing(ITermColorKey.Ansi9)
    setBlackIfMissing(ITermColorKey.Ansi10)
    setBlackIfMissing(ITermColorKey.Ansi11)
    setBlackIfMissing(ITermColorKey.Ansi12)
    setBlackIfMissing(ITermColorKey.Ansi13)
    setBlackIfMissing(ITermColorKey.Ansi14)
    setBlackIfMissing(ITermColorKey.Ansi15)
    setBlackIfMissing(ITermColorKey.CursorText)
    setBlackIfMissing(ITermColorKey.SelectedText)
    setBlackIfMissing(ITermColorKey.Foreground)
    setBlackIfMissing(ITermColorKey.Background)
    setBlackIfMissing(ITermColorKey.Bold)
    setBlackIfMissing(ITermColorKey.Selection)
    setBlackIfMissing(ITermColorKey.Cursor)
  }
  
  private func setBlackIfMissing(colorKey: ITermColorKey) {
    let entry = dict[colorKey.rawValue] as? NSMutableDictionary
    if entry == nil {
      setColor(colorKey, r: 0, g: 0, b: 0)
    }
  }
  
  private func setColor(colorKey: ITermColorKey, r: CGFloat, g: CGFloat, b: CGFloat) {
    let colorDict = NSMutableDictionary()
    
    colorDict[ITermColorComponentKey.Red.rawValue] = r
    colorDict[ITermColorComponentKey.Green.rawValue] = g
    colorDict[ITermColorComponentKey.Blue.rawValue] = b
    
    dict[colorKey.rawValue] = colorDict
  }
}

/// Enumerates the dictionary key names used for color components of iTerm
/// color scheme entries.
enum ITermColorComponentKey : String {
  case Red = "Red Component"
  case Green = "Green Component"
  case Blue = "Blue Component"
}

/// Enumerates the dictionary key names used for iTerm color scheme entries.
enum ITermColorKey : String {
  case Ansi0 = "Ansi 0 Color"
  case Ansi1 = "Ansi 1 Color"
  case Ansi2 = "Ansi 2 Color"
  case Ansi3 = "Ansi 3 Color"
  case Ansi4 = "Ansi 4 Color"
  case Ansi5 = "Ansi 5 Color"
  case Ansi6 = "Ansi 6 Color"
  case Ansi7 = "Ansi 7 Color"
  case Ansi8 = "Ansi 8 Color"
  case Ansi9 = "Ansi 9 Color"
  case Ansi10 = "Ansi 10 Color"
  case Ansi11 = "Ansi 11 Color"
  case Ansi12 = "Ansi 12 Color"
  case Ansi13 = "Ansi 13 Color"
  case Ansi14 = "Ansi 14 Color"
  case Ansi15 = "Ansi 15 Color"
  case CursorText = "Cursor Text Color"
  case SelectedText = "Selected Text Color"
  case Foreground = "Foreground Color"
  case Background = "Background Color"
  case Bold = "Bold Color"
  case Selection = "Selection Color"
  case Cursor = "Cursor Color"
}

/// Converts a color to the corresponding iTerm color scheme entry key.
extension Color {
  func asITermColorKey() -> ITermColorKey? {
    switch self {
    case .Black:         return ITermColorKey.Ansi0
    case .Red:           return ITermColorKey.Ansi1
    case .Green:         return ITermColorKey.Ansi2
    case .Yellow:        return ITermColorKey.Ansi3
    case .Blue:          return ITermColorKey.Ansi4
    case .Magenta:       return ITermColorKey.Ansi5
    case .Cyan:          return ITermColorKey.Ansi6
    case .White:         return ITermColorKey.Ansi7
    case .BrightBlack:   return ITermColorKey.Ansi8
    case .BrightRed:     return ITermColorKey.Ansi9
    case .BrightGreen:   return ITermColorKey.Ansi10
    case .BrightYellow:  return ITermColorKey.Ansi11
    case .BrightBlue:    return ITermColorKey.Ansi12
    case .BrightMagenta: return ITermColorKey.Ansi13
    case .BrightCyan:    return ITermColorKey.Ansi14
    case .BrightWhite:   return ITermColorKey.Ansi15
    case .Background:    return ITermColorKey.Background
    case .Foreground:    return ITermColorKey.Foreground
    case .Selection:     return ITermColorKey.Selection
    case .Bold:          return ITermColorKey.Bold
    case .Cursor:        return ITermColorKey.Cursor
    }
  }
}