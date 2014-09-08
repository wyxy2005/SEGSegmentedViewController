//
//  SegmentedViewItemPresenter.swift
//  SegmentedViewController
//
//  Created by Thomas Sherwood on 08/09/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

import Foundation
import UIKit

@objc(SEGSegmentedViewItemPresenter)
public class SegmentedViewItemPresenter: SegmentedViewControllerItemPresenter {
	
	// MARK: Properties
	
	private(set) public var parentController: UIViewController
	private(set) public var segmentControl: UISegmentedControl
	
	
	// MARK: Initializer
	
	public init(parentController: UIViewController, segmentedControl control: UISegmentedControl) {
		self.parentController = parentController
		self.segmentControl = control
	}
	
	
	// MARK: SegmentedViewControllerItemPresenter
	
	public func presentItem(item: SegmentedViewControllerItem, atIndex index: Int, usingAnimation animated: Bool) {
		if let controller = item.viewController {
			parentController.addChildViewController(controller)
		}
		
		addItem(item, atIndex: index, animated: animated)
		segmentControl.sizeToFit()
	}
	
	public func refreshItem(item: SegmentedViewControllerItem, atIndex index: Int, usingAnimation animated: Bool) {
		refreshItem(item, atIndex: index, animated: animated)
		segmentControl.sizeToFit()
	}
	
	public func clearItems() {
		segmentControl.removeAllSegments()
	}
	
	
	// MARK: Private
	
	private func addItem(item: SegmentedViewControllerItem, atIndex index: Int, animated: Bool) {
		switch item.type {
		case .Icon:
			segmentControl.insertSegmentWithImage(item.icon!, atIndex: index, animated: animated)
			
		case .Text:
			segmentControl.insertSegmentWithTitle(item.text!, atIndex: index, animated: animated)
			
		default:
			debugPrintln("Segment item set to none or unrecognized type")
		}
	}
	
	private func refreshItem(item: SegmentedViewControllerItem, atIndex index: Int, animated: Bool) {
		if index < segmentControl.numberOfSegments {
			switch item.type {
			case .Icon:
				segmentControl.setImage(item.icon!, forSegmentAtIndex: index)
				
			case .Text:
				segmentControl.setTitle(item.text!, forSegmentAtIndex: index)
				
			default:
				debugPrintln("Segment item set to none or unrecognized type")
			}
		}
	}

}
