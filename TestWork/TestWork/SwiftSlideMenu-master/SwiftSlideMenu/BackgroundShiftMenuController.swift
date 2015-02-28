//
//  BackgroundShiftMenu.swift
//  SwiftSlideMenu
//
//  Created by Sam Wang on 12/29/14.
//  Copyright (c) 2014 Sam Wang. All rights reserved.
//

import Foundation

public enum ShiftMenuDirection: Byte {
    case Left = 0x01
    case Right = 0x02
    case None = 0x00
}

/**
* Code Sample:
* var main = ViewController()
*
* var menu: MenuViewController = MenuViewController(nibName: "View", bundle: nil)
* menu.view.frame = CGRectMake(0, 0, 300, window!.bounds.height)
* menu.view.backgroundColor = UIColor.whiteColor()
*
* var menu2: MenuViewController = MenuViewController(nibName: "View", bundle: nil)
* menu2.view.frame = CGRectMake(window!.bounds.width - 300, 0, 300, window!.bounds.height)
* menu2.view.backgroundColor = UIColor.whiteColor()
*
* self.shiftMenuController = BackgroundShiftMenuController(mainViewController: main,
*                                                          leftMenuViewController: menu, rightMenuViewController: menu2)
*/
public class BackgroundShiftMenuController: UIViewController {
    
    private var isShow: ShiftMenuDirection = ShiftMenuDirection.None
    private var previousPanPoint: CGFloat = 0
    private var panGestureRecognizer: UIPanGestureRecognizer?
    
    // View container
    private var leftMenuView: UIView?
    private var rightMenuView: UIView?
    private var mainView: UIView?
    
    // offset range
    private var leftMenuViewOffset: CGFloat = 0.0
    private var rightMenuViewOffset: CGFloat = 0.0
    private var leftOffsetRatio: CGFloat = 0.0
    private var rightOffsetRatio: CGFloat = 0.0
    
    public init(mainViewController: UIViewController, leftMenuViewController: UIViewController, rightMenuViewController: UIViewController) {
        super.init()
        self.initAllView(mainViewController, leftMenuViewController: leftMenuViewController, rightMenuViewController: rightMenuViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
    * View initialization
    */
    public func initAllView(mainViewController: UIViewController, leftMenuViewController: UIViewController, rightMenuViewController: UIViewController) {
        self.leftMenuView = leftMenuViewController.view
        self.rightMenuView = rightMenuViewController.view
        
        // add tiny shift offset for view transition
        self.leftMenuViewOffset = self.leftMenuView!.frame.width / 4.0
        self.rightMenuViewOffset = self.rightMenuView!.frame.width / 4.0
        self.leftOffsetRatio = self.leftMenuViewOffset / self.leftMenuView!.frame.width
        self.rightOffsetRatio = self.rightMenuViewOffset / self.rightMenuView!.frame.width
        
        self.leftMenuView!.frame.origin.x -= self.leftMenuViewOffset
        self.rightMenuView!.frame.origin.x += self.rightMenuViewOffset
        
        self.mainView = mainViewController.view
        self.view.addSubview(self.leftMenuView!)
        self.view.addSubview(self.rightMenuView!)
        self.view.addSubview(self.mainView!)
        
        // add UIResponder relation
        mainViewController.didMoveToParentViewController(self)
        self.addChildViewController(mainViewController)
        
        leftMenuViewController.didMoveToParentViewController(self)
        self.addChildViewController(leftMenuViewController)
        
        rightMenuViewController.didMoveToParentViewController(self)
        self.addChildViewController(rightMenuViewController)
        
        // insert dark transparent view
        insertDarkTransparentView(leftMenuView!)
        insertDarkTransparentView(rightMenuView!)
        
        // add pan gesture recognizer and shadow to main view
        self.addPanGestureRecognizer()
        self.addShadow(self.mainView!)
    }
    
    /**
    * Pan gesture recognizer for dragging menu
    */
    private func addPanGestureRecognizer() {
        if let mainView = self.mainView {
            self.panGestureRecognizer = self.view.panned() {
                (pan: UIPanGestureRecognizer) -> Void in
                var point = pan.translationInView(self.view)
                
                // reset previous pan gesture point
                if self.previousPanPoint == -1 {
                    self.previousPanPoint = point.x
                    return
                }
                
                // tell which direction it is
                if self.isShow == ShiftMenuDirection.None {
                    if point.x - self.previousPanPoint > 0 {
                        self.isShow = ShiftMenuDirection.Left
                        self.leftMenuView!.removeFromSuperview()
                        self.view.insertSubview(self.leftMenuView!, belowSubview: self.mainView!)
                    } else if point.x - self.previousPanPoint < 0 {
                        self.isShow = ShiftMenuDirection.Right
                        self.rightMenuView!.removeFromSuperview()
                        self.view.insertSubview(self.rightMenuView!, belowSubview: self.mainView!)
                    }
                }
                
                // calculate diff distance
                var diff = point.x - self.previousPanPoint
                if diff != 0 {
                    mainView.frame.origin.x += diff
                    if self.isShow == ShiftMenuDirection.Left {
                        if mainView.frame.origin.x + diff >= self.leftMenuView!.frame.width {
                            self.tinyShiftMenu(self.isShow, reset: true)
                            mainView.frame.origin.x = self.leftMenuView!.frame.width
                        } else if mainView.frame.origin.x + diff <= 0 {
                            mainView.frame.origin.x = 0
                        } else {
                            self.tinyShiftMenu(self.isShow, reset: false)
                            mainView.frame.origin.x += diff
                        }
                        adjustDarkTransparentView(self.leftMenuView!, abs(self.mainView!.frame.origin.x / self.leftMenuView!.frame.width) - 0.3)
                    } else if self.isShow == ShiftMenuDirection.Right {
                        if mainView.frame.origin.x + diff <= -self.rightMenuView!.frame.width {
                            self.tinyShiftMenu(self.isShow, reset: true)
                            mainView.frame.origin.x = -self.rightMenuView!.frame.width
                        } else if mainView.frame.origin.x + diff >= 0 {
                            mainView.frame.origin.x = 0
                        } else {
                            self.tinyShiftMenu(self.isShow, reset: false)
                            mainView.frame.origin.x += diff
                        }
                        adjustDarkTransparentView(self.rightMenuView!, abs(self.mainView!.frame.origin.x / self.rightMenuView!.frame.width) - 0.3)
                    }
                }
                
                if pan.state == UIGestureRecognizerState.Ended {
                    if self.isShow == ShiftMenuDirection.Left {
                        if mainView.frame.origin.x >= (self.leftMenuView!.frame.width / 1.8) {
                            self.show(ShiftMenuDirection.Left)
                        } else {
                            self.hide()
                        }
                    } else if self.isShow == ShiftMenuDirection.Right {
                        if mainView.frame.origin.x <= -(self.rightMenuView!.frame.width / 1.8) {
                            self.show(ShiftMenuDirection.Right)
                        } else {
                            self.hide()
                        }
                    }
                    self.previousPanPoint = -1
                } else {
                    self.previousPanPoint = point.x
                }
            }
        }
    }
    
    /**
     * Tiny shift background menu
     */
    private func tinyShiftMenu(direction: ShiftMenuDirection, reset: Bool) {
        if direction == ShiftMenuDirection.Left {
            if reset == true {
                self.leftMenuView!.frame.origin.x = 0
            } else {
                let shift = self.mainView!.frame.origin.x * self.leftOffsetRatio - self.leftMenuViewOffset
                self.leftMenuView!.frame.origin.x = shift
            }
        } else if direction == ShiftMenuDirection.Right {
            if reset == true {
                self.rightMenuView!.frame.origin.x = (self.view.bounds.width - self.rightMenuView!.frame.width)
            } else {
                let shift = self.mainView!.frame.origin.x * self.rightOffsetRatio + self.rightMenuViewOffset + (self.view.bounds.width - self.rightMenuView!.frame.width)
                self.rightMenuView!.frame.origin.x = shift
            }
        }
    }
    
    /**
    * Dismiss tiny shift
    */
    private func dismissTinyShift(direction: ShiftMenuDirection) {
        if direction == ShiftMenuDirection.Left {
            self.leftMenuView!.frame.origin.x = -self.leftMenuViewOffset
        } else if direction == ShiftMenuDirection.Right {
            self.rightMenuView!.frame.origin.x = self.view.bounds.width - self.rightMenuView!.frame.width + self.rightMenuViewOffset
        }
    }
    
    /**
    * Show view with direction
    */
    public func show(direction: ShiftMenuDirection) {
        animate(0.5, {
            () -> Void in
            if direction == ShiftMenuDirection.Left {
                self.tinyShiftMenu(direction, reset: true)
                self.mainView!.frame.origin.x = self.leftMenuView!.frame.width
                adjustDarkTransparentView(self.leftMenuView!, 0.7)
            } else if direction == ShiftMenuDirection.Right {
                self.tinyShiftMenu(direction, reset: true)
                self.mainView!.frame.origin.x = -self.rightMenuView!.frame.width
                adjustDarkTransparentView(self.rightMenuView!, 0.7)
            }
            }, {
                if direction == ShiftMenuDirection.Left {
                    adjustDarkTransparentView(self.leftMenuView!, 0.7)
                    self.tinyShiftMenu(direction, reset: true)
                } else if direction == ShiftMenuDirection.Right {
                    adjustDarkTransparentView(self.rightMenuView!, 0.7)
                    self.tinyShiftMenu(direction, reset: true)
                }
        })
    }
    
    /**
    * Hide view to original point
    */
    public func hide() {
        spring(0.4) {
            () -> Void in
            self.dismissTinyShift(self.isShow)
            self.mainView!.frame.origin.x = 0
            self.leftMenuView!.frame.origin.x = -(self.leftMenuView!.frame.width / 4.0)
            self.isShow = ShiftMenuDirection.None
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
        view.layer.shadowOpacity = 0.8
        view.layer.shadowRadius = 7.0
        view.layer.shadowPath = shadowPath.CGPath
    }
}