//
//  Extensions.swift
//  SegmentedViewController
//
//  Created by Thomas Sherwood on 07/09/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController
{
	@objc(seg_navigationAndTabBarInsets)
	public var navigationAndTabBarInsets: UIEdgeInsets {
		get {
			var top = CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
			if let navController = navigationController {
				top += CGRectGetHeight(navigationController!.navigationBar.frame)
			}
			
			var bottom: CGFloat = 0
			if let tabController = tabBarController {
				bottom += CGRectGetHeight(tabController.tabBar.frame)
			}
			
			return UIEdgeInsetsMake(top, 0, bottom, 0)
		}
	}
	
	@objc(seg_segmentedViewController)
	public var segmentedViewController: SegmentedViewController? {
		get {
			var candidate: UIViewController? = self
			while candidate != nil {
				if candidate is SegmentedViewController {
					break
				}
				else {
					candidate = candidate?.parentViewController
				}
			}
			
			return candidate as? SegmentedViewController
		}
	}
}

public extension UIEdgeInsets
{
	public mutating func sumWithInsets(insets: UIEdgeInsets) {
		top += insets.top
		left += insets.left
		right += insets.right
		bottom += insets.bottom
	}
}

public extension Array
{
	public func isIndexLegal(index: Int) -> Bool {
		return count != 0 && index >= 0 && index < count
	}
}
