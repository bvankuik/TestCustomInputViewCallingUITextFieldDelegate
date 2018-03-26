//
//  Global.swift
//  TestCustomInputViewCallingUITextFieldDelegate
//
//  Created by Bart van Kuik on 26/03/2018.
//  Copyright © 2018 DutchVirtual. All rights reserved.
//

import Foundation

public func dlog(_ format: String = "", _ args: [CVarArg] = [], file: String = #file, function: String = #function, line: Int = #line) {
    let filename: String
    if let fn = URL(string:file)?.lastPathComponent.components(separatedBy: ".").first {
        filename = fn
    } else {
        filename = "nil"
    }
    
    let formattedString = String(format: "\(filename).\(function) line \(line) $ \(format)", arguments: args)
    NSLog(formattedString)
}
