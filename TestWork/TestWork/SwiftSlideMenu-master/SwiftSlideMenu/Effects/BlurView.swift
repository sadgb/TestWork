//
//  BlurView.swift
//  SlideMenu
//
//  Created by Sam Wang on 12/20/14.
//  Copyright (c) 2014 Sam Wang. All rights reserved.
//

import UIKit

let DARK_BLUE_VIEW_TAG = 1000
let DARK_TRANSPARENT_VIEW_TAG = 1001

/**
* Insert view with transparent background blur on certain view
* :param: parent view
* :param: blur style
*/
public func insertBlurView (view: UIView, style: UIBlurEffectStyle) {
    view.backgroundColor = UIColor.clearColor()
    
    var blurEffect = UIBlurEffect(style: style)
    var blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    view.addSubview(blurEffectView)
}

/**
* Get added dark transparent view on certain view
* :param: parent view
* :returns: dark transparent view instance
*/
public func getDarkTransparentView(view: UIView) -> UIView? {
    if let darkTransparentView = view.viewWithTag(DARK_TRANSPARENT_VIEW_TAG) {
        return darkTransparentView
    }
    return nil
}

/**
* Insert dark transparent view on certain view
* :param: parent view
*/
public func insertDarkTransparentView (view: UIView) {
    if let darkView = view.viewWithTag(DARK_TRANSPARENT_VIEW_TAG) {
        view.bringSubviewToFront(darkView)
        animate(0.4, {
            darkView.alpha = 0.7
        })
    } else {
        var darkView = UIView()
        darkView.tag = DARK_TRANSPARENT_VIEW_TAG
        darkView.frame = view.bounds
        darkView.backgroundColor = UIColor.blackColor()
        darkView.alpha = 0
        view.addSubview(darkView)
        animate(0.4, {
            darkView.alpha = 0.7
        })
    }
}

/**
* Adjust dark transparent view alpha
* :param: parent view
* :param: transparent
*/
public func adjustDarkTransparentView (view: UIView, transparent: CGFloat) {
    if let darkView = view.viewWithTag(DARK_TRANSPARENT_VIEW_TAG) {
        var diff = 0.7 - transparent
        if diff >= 0.7 {
            darkView.alpha = 0.7
        } else if diff <= 0 {
            darkView.alpha = 0
        } else {
            darkView.alpha = diff
        }
    }
}

/**
* Remove dark transparent view on certain view
* :param: parent view
*/
public func removeDarkTransparentView (view: UIView) {
    view.backgroundColor = UIColor.clearColor()
    if let darkView = view.viewWithTag(DARK_TRANSPARENT_VIEW_TAG) {
        animate(0.3, {
            darkView.alpha = 0.0
        })
    }
}