//
//  SlideMenu.swift
//  SlideMenu
//
//  Created by Sam Wang on 12/20/14.
//  Copyright (c) 2014 Sam Wang. All rights reserved.
//

import Foundation
import UIKit

public class SlideMenu: UIView {
    
    private let SLIDE_MENU_TAG: Int = 901
    private var isShow: Bool = false
    private var previousPanPoint: CGFloat = 0
    private var menuWidth: CGFloat = 0
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var startPanTime: Int = -1
    private var startPanPointX: CGFloat = -1
    
    // View container
    private var menuView: UIView? {
        didSet {
            self.tag = SLIDE_MENU_TAG
        }
    }
    private weak var mainView: UIView?
    private weak var mainViewController: UIViewController?
    private weak var menuViewController: UIViewController?
    
    convenience public init(frame: CGRect, mainView: UIView, menuView: UIView) {
        self.init(frame: frame)
        self.mainView = mainView
        self.menuView = menuView
        self.menuWidth = self.menuView!.frame.width
        self.addSubview(self.menuView!)
        
        self.addShadow(self)
    }
    
    convenience public init(frame: CGRect, mainViewController: UIViewController, menuViewController: UIViewController) {
        self.init(frame: frame)
        self.mainView = mainViewController.view
        self.menuView = menuViewController.view
        self.mainViewController = mainViewController
        self.menuViewController = menuViewController
        self.menuWidth = self.menuView!.frame.width
        self.addSubview(self.menuView!)
        
        menuViewController.didMoveToParentViewController(mainViewController)
        mainViewController.addChildViewController(menuViewController)
        
        self.addShadow(self)
    }

    override private init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
    * Slide in menu with animation
    */
    public func show() {
        if let mainView = self.mainView {
            insertDarkTransparentView(mainView)
            spring(0.4, {
                self.frame.origin.x = 0
                self.layer.shadowOpacity = 1.0
                self.isShow = true
                var darkTransparentView = getDarkTransparentView(mainView)
                darkTransparentView?.tapped(){
                    if self.isShow {
                        self.hide()
                    }
                }
                
                // add pan gesture for moving menu
                self.addPanGestureRecognizer()
            })
            mainView.addSubview(self)
        }
    }
    
    /**
    * Slide out menu with animation
    */
    public func hide() {
        if let mainView = self.mainView {
            animate(0.3, {
                self.frame.origin.x = -self.frame.width
                self.isShow = false
                self.removePanGestureRecognizer()
                mainView.viewWithTag(self.SLIDE_MENU_TAG)?.removeFromSuperview()
            }, { self.layer.shadowOpacity = 0.0 })
            removeDarkTransparentView(mainView)
        }
    }
    
    public func hide(time: Double) {
        if let mainView = self.mainView {
            animate(time, {
                self.frame.origin.x = -self.frame.width
                self.isShow = false
                self.removePanGestureRecognizer()
                mainView.viewWithTag(self.SLIDE_MENU_TAG)?.removeFromSuperview()
                }, { self.layer.shadowOpacity = 0.0 })
            removeDarkTransparentView(mainView)
        }
    }
    
    /**
    * SlideMenu current display status
    * :returns: visible
    */
    public func isVisible() -> Bool {
        return self.isShow
    }
    
    /**
    * Pan gesture recognizer for dragging menu
    */
    private func addPanGestureRecognizer() {
        if let mainView = self.mainView {
            self.panGestureRecognizer = mainView.panned() {
                (pan: UIPanGestureRecognizer) -> Void in
                var point = pan.translationInView(self)
                
                // reset previous pan gesture point
                if self.previousPanPoint == -1 {
                    self.previousPanPoint = point.x
                    return
                }
                
                // calculate diff distance
                var diff = point.x - self.previousPanPoint
                if diff != 0 {
                    if self.frame.origin.x + diff >= 0 {
                        self.frame.origin.x = 0
                    } else if self.frame.origin.x + diff <= -self.frame.width {
                        self.frame.origin.x = -self.frame.width
                    } else {
                        self.frame.origin.x += diff
                        adjustDarkTransparentView(mainView, abs(self.frame.origin.x / self.menuWidth) - 0.3)
                    }
                }
                
                // Calculate pin start point
                if pan.state == UIGestureRecognizerState.Began || pan.state == UIGestureRecognizerState.Changed {
                    if self.startPanPointX == -1 {
                        self.startPanPointX = point.x
                    }
                    if self.startPanTime == -1 {
                        self.startPanTime = Int(floor((CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970) * 1000.0))
                    }
                }
                
                if pan.state == UIGestureRecognizerState.Ended {
                    if self.frame.origin.x >= -(self.menuWidth / 3.0) {
                        spring(0.4) {
                            () -> Void in
                            self.frame.origin.x = 0
                            adjustDarkTransparentView(mainView, 0)
                        }
                    } else {
                        // calculate velocity & width left
                        let stopTime = Int(floor((CFAbsoluteTimeGetCurrent() + kCFAbsoluteTimeIntervalSince1970) * 1000.0))
                        let perPixelTime = CGFloat(stopTime - self.startPanTime) / abs(self.startPanPointX - point.x)
                        let leftRange = abs(-self.menuWidth - point.x)
                        var velocity = leftRange * perPixelTime / 1000
                        if velocity > 0.3 {
                            velocity = 0.3
                        }

                        // reset value after pin ended
                        self.startPanPointX = -1
                        self.startPanTime = -1
                        
                        // hide by velocity
                        self.hide(Double(velocity))
                    }
                    self.previousPanPoint = -1
                } else {
                    self.previousPanPoint = point.x
                }
            }
        }
    }
    
    /**
    * Remove registered pan gesture recognizer
    */
    private func removePanGestureRecognizer() {
        if let mainView = self.mainView {
            mainView.removeGestureRecognizer(self.panGestureRecognizer!)
        }
    }
    
    /**
    * Add shadow to menu view
    */
    private func addShadow(view: UIView) {
        var shadowPath = UIBezierPath(rect: view.bounds)
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        view.layer.shadowOpacity = 0.0
        view.layer.shadowRadius = 4.0
        view.layer.shadowPath = shadowPath.CGPath
    }
}