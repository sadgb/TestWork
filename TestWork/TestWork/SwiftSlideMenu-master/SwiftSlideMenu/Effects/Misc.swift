//
//  Misc.swift
//  SlideMenu
//
//  Created by Sam Wang on 12/20/14.
//  Copyright (c) 2014 Sam Wang. All rights reserved.
//

import UIKit

public func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}