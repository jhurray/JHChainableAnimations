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
    
    public func makeFrame(frame: CGRect) -> Self {
        animator.makeFrame()(frame)
        return self;
    }
    
    public func makeBounds(bounds: CGRect) -> Self {
        animator.makeBounds()(bounds)
        return self
    }
    
    public func makeSize(height: Float, width: Float) -> Self {
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
    
    public func makeX(x: Float) -> Self {
        animator.makeX()(x.toCG)
        return self
    }
    
    public func makeY(y: Float) -> Self {
        animator.makeY()(y.toCG)
        return self
    }
    
    public func makeWidth(width: Float) -> Self {
        animator.makeWidth()(width.toCG)
        return self
    }
    
    public func makeHeight(height: Float) -> Self {
        animator.makeHeight()(height.toCG)
        return self
    }
    
    public func makeOpacity(alpha: Float) -> Self {
        animator.makeOpacity()(alpha.toCG)
        return self
    }
    
    public func makeBackground(color: UIColor) -> Self {
        animator.makeBackground()(color)
        return self
    }
    
    public func makeBorderColor(color: UIColor) -> Self {
        animator.makeBorderColor()(color)
        return self
    }
    
    public func makeBorderWidth(width: Float) -> Self {
        animator.makeBorderWidth()(width.toCG)
        return self
    }
    
    public func makeCornerRadius(cornerRadius: Float) -> Self {
        animator.makeCornerRadius()(cornerRadius.toCG)
        return self
    }
    
    public func makeScale(scale: Float) -> Self {
        animator.makeScale()(scale.toCG)
        return self
    }
    
    public func makeScaleY(scaleY: Float) -> Self {
        animator.makeScaleY()(scaleY.toCG)
        return self
    }
    
    public func makeScaleX(scaleX: Float) -> Self {
        animator.makeScaleX()(scaleX.toCG)
        return self
    }
    
    public func makeAnchor(x: Float, y: Float) -> Self {
        animator.makeAnchor()(x.toCG, y.toCG)
        return self
    }
    
    public func moveX(x: Float) -> Self {
        animator.moveX()(x.toCG)
        return self
    }
    
    public func moveY(y: Float) -> Self {
        animator.moveY()(y.toCG)
        return self
    }
    
    public func moveXY(x: Float, y: Float) -> Self {
        animator.moveXY()(x.toCG, y.toCG)
        return self
    }
    
    public func moveWidth(width: Float) -> Self {
        animator.moveWidth()(width.toCG)
        return self
    }
    
    public func moveHeight(height: Float) -> Self {
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
    
    public func transformX(x: Float) -> Self {
        animator.transformX()(x.toCG)
        return self
    }
    
    public func transformY(x: Float) -> Self {
        animator.transformY()(x.toCG)
        return self
    }
    
    public func transformXY(x: Float, y: Float) -> Self {
        animator.transformXY()(x.toCG, y.toCG)
        return self
    }
    
    public func transformScale(scale: Float) -> Self {
        animator.transformScale()(scale.toCG)
        return self
    }
    
    public func transformScaleX(scaleX: Float) -> Self {
        animator.transformScaleX()(scaleX.toCG)
        return self
    }
    
    public func transformScaleY(scaleY: Float) -> Self {
        animator.transformScaleY()(scaleY.toCG)
        return self
    }
    
    public func moveOnPath(path: UIBezierPath) -> Self {
        animator.moveOnPath()(path)
        return self
    }
    
    public func moveAndRotateOnPath(path: UIBezierPath) -> Self {
        animator.moveAndRotateOnPath()(path)
        return self
    }
    
    public func moveAndReverseRotateOnPath(path: UIBezierPath) -> Self {
        animator.moveAndReverseRotateOnPath()(path)
        return self
    }
    
    public var anchorDefault: ChainableAnimator {
        animator.anchorDefault()
        return self
    }
    
    public var anchorCenter: ChainableAnimator {
        animator.anchorCenter()
        return self
    }
    
    public var anchorTopLeft: ChainableAnimator {
        animator.anchorTopLeft()
        return self
    }
    
    public var anchorTopRight: ChainableAnimator {
        animator.anchorTopRight()
        return self
    }
    
    public var anchorBottomLeft: ChainableAnimator {
        animator.anchorBottomLeft()
        return self
    }
    
    public var anchorBottomRight: ChainableAnimator {
        animator.anchorBottomRight()
        return self
    }
    
    public var anchorTop: ChainableAnimator {
        animator.anchorTop()
        return self
    }
    
    public var anchorBottom: ChainableAnimator {
        animator.anchorBottom()
        return self
    }
    
    public var anchorLeft: ChainableAnimator {
        animator.anchorLeft()
        return self
    }
    
    public var anchorRight: ChainableAnimator {
        animator.anchorRight()
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
    
    public func preAnimationBlock(block: @escaping (Void) -> Void) -> Self {
        animator.preAnimationBlock()(block)
        return self
    }
    
    public func animationBlock(block: @escaping (Void) -> Void) -> Self {
        animator.animationBlock()(block)
        return self
    }
    
    public func postAnimationBlock(block: @escaping (Void) -> Void) -> Self {
        animator.postAnimationBlock()(block)
        return self
    }
    
    public func repeatAnimation(t: TimeInterval, count: Int) -> Self {
        animator.repeat()(t, count)
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
    
    public func animateWithCompletion(t: TimeInterval, completion: @escaping (Void) -> Void) {
        animator.animateWithCompletion()(t, completion)
    }
}
