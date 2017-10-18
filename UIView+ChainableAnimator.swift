//
//  UIView+ChainableAnimator.swift
//  JHChainableAnimations-iOS
//
//  Created by  Jeffrey Hurray on 10/17/17.
//  Copyright © 2017 jhurray. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    public var animator: ChainableAnimator {
        return ChainableAnimator(view: self)
    }
}
