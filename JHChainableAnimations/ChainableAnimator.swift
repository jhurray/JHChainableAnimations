//
//  ChainableAnimator.swift
//  JHChainableAnimations
//
//  Created by Jeff Hurray on 1/17/17.
//  Copyright © 2017 jhurray. All rights reserved.
//

import Foundation
import UIKit

internal extension Float {
    
    var toCG: CGFloat {
        return CGFloat(self)
    }
}


public final class ChainableAnimator {
    
    fileprivate let animator: JHChainableAnimator!
    
    public init(view: UIView) {
        animator = JHChainableAnimator(view: view)
    }
    
    public var completion: () -> Void {
        get {
            return animator.completionBlock
        }
        set (newCompletion) {
            animator.completionBlock = newCompletion
        }
    }
    
    public var isAnimating: Bool {
        return animator.isAnimating
    }
    
    public var isPaused: Bool {
        return animator.isPaused
    }
    
    public var view: UIView {
        return animator.view
    }
    
    public func pause() {
        animator.pause()
    }
    
    public func resume() {
        animator.resume()
    }
    
    public func stop() {
        animator.stop()
    }
}


public extension ChainableAnimator {
    
    public func make(frame: CGRect) -> Self {
        animator.makeFrame()(frame)
        return self;
    }
    
    public func make(bounds: CGRect) -> Self {
        animator.makeBounds()(bounds)
        return self
    }
    
    public func make(height: Float, width: Float) -> Self {
        animator.makeSize()(height.toCG, width.toCG)
        return self
    }
    
    public func makeOrigin(x: Float, y: Float) -> Self {
        animator.makeOrigin()(x.toCG, y.toCG)
        return self
    }
    
    public func makeCenter(x: Float, y: Float) -> Self {
        animator.makeCenter()(x.toCG, y.toCG)
        return self
    }
    
    public func make(x: Float) -> Self {
        animator.makeX()(x.toCG)
        return self
    }
    
    public func make(y: Float) -> Self {
        animator.makeY()(y.toCG)
        return self
    }
    
    public func make(width: Float) -> Self {
        animator.makeWidth()(width.toCG)
        return self
    }
    
    public func make(height: Float) -> Self {
        animator.makeHeight()(height.toCG)
        return self
    }
    
    public func make(alpha: Float) -> Self {
        animator.makeOpacity()(alpha.toCG)
        return self
    }
    
    public func make(backgroundColor color: UIColor) -> Self {
        animator.makeBackground()(color)
        return self
    }
    
    public func make(borderColor color: UIColor) -> Self {
        animator.makeBorderColor()(color)
        return self
    }
    
    public func make(borderWidth width: Float) -> Self {
        animator.makeBorderWidth()(width.toCG)
        return self
    }
    
    public func make(cornerRadius: Float) -> Self {
        animator.makeCornerRadius()(cornerRadius.toCG)
        return self
    }
    
    public func make(scale: Float) -> Self {
        animator.makeScale()(scale.toCG)
        return self
    }
    
    public func make(scaleY: Float) -> Self {
        animator.makeScaleY()(scaleY.toCG)
        return self
    }
    
    public func make(scaleX: Float) -> Self {
        animator.makeScaleX()(scaleX.toCG)
        return self
    }
    
    public func makeAnchor(x: Float, y: Float) -> Self {
        animator.makeAnchor()(x.toCG, y.toCG)
        return self
    }
    
    public func move(x: Float) -> Self {
        animator.moveX()(x.toCG)
        return self
    }
    
    public func move(y: Float) -> Self {
        animator.moveY()(y.toCG)
        return self
    }
    
    public func move(x: Float, y: Float) -> Self {
        animator.moveXY()(x.toCG, y.toCG)
        return self
    }
    
    public func move(width: Float) -> Self {
        animator.moveWidth()(width.toCG)
        return self
    }
    
    public func move(height: Float) -> Self {
        animator.moveHeight()(height.toCG)
        return self
    }
    
    public func movePolar(radius: Float, angle: Float) -> Self {
        animator.movePolar()(radius.toCG, angle.toCG)
        return self
    }
    
    public var transformIdentity: ChainableAnimator {
        animator.transformIdentity()
        return self
    }
    
    public func rotate(angle: Float) -> Self {
        animator.rotate()(angle.toCG)
        return self
    }
    
    public func rotateX(angle: Float) -> Self {
        animator.rotateX()(angle.toCG)
        return self
    }
    
    public func rotateY(angle: Float) -> Self {
        animator.rotateY()(angle.toCG)
        return self
    }
    
    public func rotateZ(angle: Float) -> Self {
        animator.rotateZ()(angle.toCG)
        return self
    }
    
    public func transform(x: Float) -> Self {
        animator.transformX()(x.toCG)
        return self
    }
    
    public func transform(y: Float) -> Self {
        animator.transformY()(y.toCG)
        return self
    }
    
    public func transform(x: Float, y: Float) -> Self {
        animator.transformXY()(x.toCG, y.toCG)
        return self
    }
    
    public func transform(scale: Float) -> Self {
        animator.transformScale()(scale.toCG)
        return self
    }
    
    public func transform(scaleX: Float) -> Self {
        animator.transformScaleX()(scaleX.toCG)
        return self
    }
    
    public func transform(scaleY: Float) -> Self {
        animator.transformScaleY()(scaleY.toCG)
        return self
    }
    
    public func move(onPath path: UIBezierPath, rotate: Bool = false, isReversed: Bool = false) -> Self {
        if rotate {
            if isReversed {
                animator.moveAndReverseRotateOnPath()(path)
            } else {
                animator.moveAndRotateOnPath()(path)
            }
        } else {
            animator.moveOnPath()(path)
        }
        return self
    }
    
    public enum AnchorPosition {
        case normal
        case center
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        case top
        case bottom
        case left
        case right
    }
    
    public func anchor(_ position: AnchorPosition) -> ChainableAnimator {
        switch position {
        case .normal:
            animator.anchorDefault()
        case .center:
            animator.anchorCenter()
        case .topLeft:
            animator.anchorTopLeft()
        case .topRight:
            animator.anchorTopRight()
        case .bottomLeft:
            animator.anchorBottomLeft()
        case .bottomRight:
            animator.anchorBottomRight()
        case .top:
            animator.anchorTop()
        case .bottom:
            animator.anchorBottom()
        case .left:
            animator.anchorLeft()
        case .right:
            animator.anchorRight()
        }
        return self
    }
    
    public func delay(t: TimeInterval) -> Self {
        animator.delay()(t)
        return self
    }
    
    public func wait(t: TimeInterval) -> Self {
        animator.wait()(t)
        return self
    }
    
    public var easeIn: ChainableAnimator {
        animator.easeIn()
        return self
    }
    
    public var easeOut: ChainableAnimator {
        animator.easeOut()
        return self
    }
    
    public var easeInOut: ChainableAnimator {
        animator.easeInOut()
        return self
    }
    
    public var easeBack: ChainableAnimator {
        animator.easeBack()
        return self
    }
    
    public var spring: ChainableAnimator {
        animator.spring()
        return self
    }
    
    public var bounce: ChainableAnimator {
        animator.bounce()
        return self
    }
    
    public var easeInQuad: ChainableAnimator {
        animator.easeInQuad()
        return self
    }
    
    public var easeOutQuad: ChainableAnimator {
        animator.easeOutQuad()
        return self
    }
    
    public var easeInOutQuad: ChainableAnimator {
        animator.easeInOutQuad()
        return self
    }
    
    public var easeInCubic: ChainableAnimator {
        animator.easeInCubic()
        return self
    }
    
    public var easeOutCubic: ChainableAnimator {
        animator.easeOutCubic()
        return self
    }
    
    public var easeInOutCubic: ChainableAnimator {
        animator.easeInOutCubic()
        return self
    }
    
    public var easeInQuart: ChainableAnimator {
        animator.easeInQuart()
        return self
    }
    
    public var easeOutQuart: ChainableAnimator {
        animator.easeOutQuart()
        return self
    }
    
    public var easeInOutQuart: ChainableAnimator {
        animator.easeInOutQuart()
        return self
    }
    
    public var easeInQuint: ChainableAnimator {
        animator.easeInQuint()
        return self
    }
    
    public var easeOutQuint: ChainableAnimator {
        animator.easeOutQuint()
        return self
    }
    
    public var easeInOutQuint: ChainableAnimator {
        animator.easeInOutQuint()
        return self
    }
    
    public var easeInSine: ChainableAnimator {
        animator.easeInSine()
        return self
    }
    
    public var easeOutSine: ChainableAnimator {
        animator.easeOutSine()
        return self
    }
    
    public var easeInOutSine: ChainableAnimator {
        animator.easeInOutSine()
        return self
    }
    
    public var easeInExpo: ChainableAnimator {
        animator.easeInExpo()
        return self
    }
    
    public var easeOutExpo: ChainableAnimator {
        animator.easeOutExpo()
        return self
    }
    
    public var easeInOutExpo: ChainableAnimator {
        animator.easeInOutExpo()
        return self
    }
    
    public var easeInCirc: ChainableAnimator {
        animator.easeInCirc()
        return self
    }
    
    public var easeOutCirc: ChainableAnimator {
        animator.easeOutCirc()
        return self
    }
    
    public var easeInOutCirc: ChainableAnimator {
        animator.easeInOutCirc()
        return self
    }
    
    public var easeInElastic: ChainableAnimator {
        animator.easeInElastic()
        return self
    }
    
    public var easeOutElastic: ChainableAnimator {
        animator.easeOutElastic()
        return self
    }
    
    public var easeInOutElastic: ChainableAnimator {
        animator.easeInOutElastic()
        return self
    }
    
    public var easeInBack: ChainableAnimator {
        animator.easeInBack()
        return self
    }
    
    public var easeOutBack: ChainableAnimator {
        animator.easeOutBack()
        return self
    }
    
    public var easeInOutBack: ChainableAnimator {
        animator.easeInOutBack()
        return self
    }
    
    public var easeInBounce: ChainableAnimator {
        animator.easeInBounce()
        return self
    }
    
    public var easeOutBounce: ChainableAnimator {
        animator.easeOutBounce()
        return self
    }
    
    public var easeInOutBounce: ChainableAnimator {
        animator.easeInOutBounce()
        return self
    }
    
    public func customAnimationFunction(function: @escaping (Double, Double, Double, Double) -> (Double)) -> Self {
        animator.customAnimationFunction()(function)
        return self
    }
    
    public func preAnimationBlock(block: @escaping () -> ()) -> Self {
        animator.preAnimationBlock()(block)
        return self
    }
    
    public func postAnimationBlock(block: @escaping () -> ()) -> Self {
        animator.postAnimationBlock()(block)
        return self
    }
    
    public func `repeat`(t: TimeInterval, count: Int) -> Self {
        animator.`repeat`()(t, count)
        return self
    }
    
    public func thenAfter(t: TimeInterval) -> Self {
        animator.thenAfter()(t)
        return self
    }
    
    public func animate(t: TimeInterval) {
        animator.animate()(t)
    }
    
    public func animateWithRepeat(t: TimeInterval, count: Int) {
        animator.animateWithRepeat()(t, count)
    }
    
    public func animate(t: TimeInterval, completion: @escaping () -> ()) {
        animator.animateWithCompletion()(t, completion)
    }
}
