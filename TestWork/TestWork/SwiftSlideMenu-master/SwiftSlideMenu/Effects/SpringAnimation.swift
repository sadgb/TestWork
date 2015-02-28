//
//  SpringAnimation.swift
//  SlideMenu
//
//  Created by Sam Wang on 12/20/14.
//  Copyright (c) 2014 Sam Wang. All rights reserved.
//

import UIKit

var duration = 0.7
var delay = 0.0
var damping = 0.7
var velocity = 0.7

public func animate(duration: NSTimeInterval, animations: (() -> Void)!) {
    UIView.animateWithDuration(duration, delay: delay, options: nil, animations: {
            animations()
        }, completion: { finished in
    })
}

public func animate(duration: NSTimeInterval, animations: (() -> Void)!, completion: (() -> Void)!) {
    UIView.animateWithDuration(duration, delay: delay, options: nil, animations: {
        animations()
        }, completion: { finished in
            completion()
    })
}

public func spring(duration: NSTimeInterval, animations: (() -> Void)!) {
    UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: nil, animations: {
            animations()
        }, completion: { finished in
    })
}

public func springWithDamping(duration: NSTimeInterval, damping: CGFloat, animations: (() -> Void)!) {
    UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: damping, options: nil, animations: {
            animations()
        }, completion: { finished in
    })
}

public func springWithDelay(duration: NSTimeInterval, delay: NSTimeInterval, animations: (() -> Void)!) {
    UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: nil, animations: {
            animations()
        }, completion: { finished in
    })
}

public func slideUp(duration: NSTimeInterval, animations: (() -> Void)!) {
    UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
            animations()
    }, nil)
}

public func springWithCompletion(duration: NSTimeInterval, animations: (() -> Void)!, completion: ((Bool) -> Void)!) {
    UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: nil, animations: {
            animations()
        }, completion: { finished in
            completion(true)
    })
}

public func springScaleFrom (view: UIView, x: CGFloat, y: CGFloat, scaleX: CGFloat, scaleY: CGFloat) {
    let translation = CGAffineTransformMakeTranslation(x, y)
    let scale = CGAffineTransformMakeScale(scaleX, scaleY)
    view.transform = CGAffineTransformConcat(translation, scale)
    
    UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: nil, animations: {
            let translation = CGAffineTransformMakeTranslation(0, 0)
            let scale = CGAffineTransformMakeScale(1, 1)
            view.transform = CGAffineTransformConcat(translation, scale)
    }, completion: nil)
}

public func springScaleTo (view: UIView, x: CGFloat, y: CGFloat, scaleX: CGFloat, scaleY: CGFloat) {
    let translation = CGAffineTransformMakeTranslation(0, 0)
    let scale = CGAffineTransformMakeScale(1, 1)
    view.transform = CGAffineTransformConcat(translation, scale)
    
    UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: nil, animations: {
            let translation = CGAffineTransformMakeTranslation(x, y)
            let scale = CGAffineTransformMakeScale(scaleX, scaleY)
            view.transform = CGAffineTransformConcat(translation, scale)
    }, completion: nil)
}

public func popoverTopRight(view: UIView) {
    view.hidden = false
    var translate = CGAffineTransformMakeTranslation(200, -200)
    var scale = CGAffineTransformMakeScale(0.3, 0.3)
    view.alpha = 0
    view.transform = CGAffineTransformConcat(translate, scale)
    
    UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: nil, animations: {
            var translate = CGAffineTransformMakeTranslation(0, 0)
            var scale = CGAffineTransformMakeScale(1, 1)
            view.transform = CGAffineTransformConcat(translate, scale)
            view.alpha = 1
    }, completion: nil)
}