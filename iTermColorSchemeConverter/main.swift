//
//  iTermColorSchemeConverter
//  Copyright (C) 2015 Leon Breedt
//

import Foundation
import AppKit

extension ITermColorScheme {
  internal class func load(path: String) -> ITermColorScheme? {
    guard let dict = NSDictionary(contentsOfFile: path) else { return nil }
    let name = path.lastPathComponent.stringByDeletingPathExtension
    return ITermColorScheme(name: name, dict: dict)
  }
}

extension ColorScheme {
  func copyTo(var other: ColorScheme) {
    other[Color.Black] = self[Color.Black]
    other[Color.Red] = self[Color.Red]
    other[Color.Green] = self[Color.Green]
    other[Color.Yellow] = self[Color.Yellow]
    other[Color.Blue] = self[Color.Blue]
    other[Color.Magenta] = self[Color.Magenta]
    other[Color.Cyan] = self[Color.Cyan]
    other[Color.White] = self[Color.White]
    other[Color.BrightBlack] = self[Color.BrightBlack]
    other[Color.BrightRed] = self[Color.BrightRed]
    other[Color.BrightGreen] = self[Color.BrightGreen]
    other[Color.BrightYellow] = self[Color.BrightYellow]
    other[Color.BrightBlue] = self[Color.BrightBlue]
    other[Color.BrightMagenta] = self[Color.BrightMagenta]
    other[Color.BrightCyan] = self[Color.BrightCyan]
    other[Color.BrightWhite] = self[Color.BrightWhite]
    other[Color.Background] = self[Color.Background]
    other[Color.Foreground] = self[Color.Foreground]
    other[Color.Selection] = self[Color.Selection]
    other[Color.Bold] = self[Color.Bold]
    other[Color.Cursor] = self[Color.Cursor]
  }
}

extension String {
  var fullPath: String {
    get {
      let path = stringByStandardizingPath
      var directory = path.stringByDeletingLastPathComponent
      if directory.characters.count == 0 {
        directory = NSFileManager.defaultManager().currentDirectoryPath
      }
      return directory.stringByAppendingPathComponent(path)
    }
  }
}

func convertToTerminalScheme(itermFilePath: String, terminalFilePath: String) {
  guard let itermScheme = ITermColorScheme.load(itermFilePath) else {
    print("warning: unable to load \(itermFilePath), skipping.")
    return
  }
  
  print("converting \(itermFilePath) -> \(terminalFilePath)")
  
  let schemeName = terminalFilePath.lastPathComponent.stringByDeletingPathExtension
  let terminalSettings = TerminalSettings(name: schemeName)
  itermScheme.copyTo(terminalSettings)

  terminalSettings.saveToFile(terminalFilePath)
}

// Entrypoint


if Process.arguments.count > 1 {
  let fileNames = Process.arguments[1..<Process.arguments.count]
  for fileName in fileNames {
    let inputFilePath = fileName.fullPath
    let inputFolderPath = inputFilePath.stringByDeletingLastPathComponent
    let schemeName = inputFilePath.lastPathComponent.stringByDeletingPathExtension
    let outputFilePath = "\(inputFolderPath)/\(schemeName).terminal"
    convertToTerminalScheme(inputFilePath, terminalFilePath: outputFilePath)
  }
} else {
  print("usage: iTermColorSchemeConverter FILE.itermcolors [...]")
}