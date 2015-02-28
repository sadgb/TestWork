SwiftSlideMenu
==============

A UI behavior of slide menu using Swift

Setup
-----
Open your project in XCode, switch to project Build Phases and add SwiftSlideMenu.framework to:<p>
1. Target Dependencies <br>
2. Link Binary With Libraries<br>
3. Copy Files (Destination -> Frameworks)<br>

Usage
-----
SwiftSlideMenu is easily add to existed UIViewController, it will create & attach UIView on top of the
UIViewController.view hierarchy.

<b>[To alloc] </b><br>
import SwiftSlideMenu

SlideMenu(frame: CGRect, mainView: UIView, menuView: UIView)<br>
SlideMenu(frame: CGRect, mainViewController: UIViewController, menuViewController: UIViewController)

<b>[To slide in/out] </b><br>
SlideMenu.show() <br>
SlideMenu.hide()

<b>[To check if display on current view] </b><br>
SlideMenu.isVisible()

Example
-----

    import UIKit
	import SwiftSlideMenu

	class ViewController: UIViewController {
    
    	var slideMenu: SlideMenu?

    	override func viewDidLoad() {
        	super.viewDidLoad()
        	
        	self.view.backgroundColor = UIColor.whiteColor()
        	var bgImage = UIImage(named: "fake-bg")
        	var bgImageView = UIImageView(image: bgImage)
        	bgImageView.frame = CGRectMake(0, UIApplication.sharedApplication().statusBarFrame.size.height, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        	self.view.addSubview(bgImageView)
        
        	var menuImage = UIImage(named: "fake-menu")
        	var menuImageView = UIImageView(image: menuImage)
        	menuImageView.frame = CGRectMake(0, UIApplication.sharedApplication().statusBarFrame.size.height, 300, UIScreen.mainScreen().bounds.height)
        
        	self.slideMenu = SlideMenu(frame: CGRectMake(-300, 0, 300, UIScreen.mainScreen().bounds.height), mainView: self.view, menuView: menuImageView)
        
        	self.view.tapped() {
            	if let slideMenu = self.slideMenu {
                	if slideMenu.isVisible() == false {
                    	slideMenu.show()
                	}
            	}
        	}
    	}
	}


BackgroundShiftMenuController
-----
This customized view controller allow you to slide out background menu view from left or right

Example
-----
 	var main = ViewController()
 	
 	var menu: MenuViewController = MenuViewController(nibName: "View", bundle: nil)
 	menu.view.frame = CGRectMake(0, 0, 300, window!.bounds.height)
 	menu.view.backgroundColor = UIColor.whiteColor()
 	
 	var menu2: MenuViewController = MenuViewController(nibName: "View", bundle: nil)
 	menu2.view.frame = CGRectMake(window!.bounds.width - 300, 0, 300, window!.bounds.height)
 	menu2.view.backgroundColor = UIColor.whiteColor()
 	
 	self.shiftMenuController = BackgroundShiftMenuController(mainViewController: main, leftMenuViewController: menu, rightMenuViewController: menu2)

The MIT License (MIT)

Copyright (c) 2014 Sam Wang

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
