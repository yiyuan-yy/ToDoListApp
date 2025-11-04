//
//  Extension+UIDevice.swift
//  ToDoList
//
//  Created by yiyuan hu on 9/29/25.
//

import Foundation
import SwiftUI

#if os(iOS)
extension UIDevice {
    static var isIPad: Bool{
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhone: Bool{
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
#endif

