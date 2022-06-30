//
//  SMYCommonTools.swift
//  SMYBase
//
//  Created by penggongxu on 2021/5/19.
//  Copyright © 2021 smyfinancial. All rights reserved.
//

import Foundation
import UIKit

public func IsEmptyString(_ string: String?) -> Bool { (string ?? "").isEmpty }

public func IsEmptyArray(_ array: Array<Any>?) -> Bool { array == nil ? true : array!.isEmpty }

public func SMYSystemFont(fontSize: CGFloat) -> UIFont { UIFont.systemFont(ofSize: fontSize) }

public func IsFullScreen() -> Bool { UIApplication.shared.statusBarFrame.size.height >= 44 }

// 状态栏高度
public func StatusBarHeight() -> CGFloat { UIApplication.shared.statusBarFrame.size.height }
