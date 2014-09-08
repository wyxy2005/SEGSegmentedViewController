//
//  SegmentedViewControllerItemsManager.swift
//  SegmentedViewController
//
//  Created by Thomas Sherwood on 08/09/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

import Foundation
import UIKit

public let SEGItemsManagerItemsCoderKey = "SegmentedViewControllerItemsManager.Items"

@objc(SEGSegmentedViewControllerItemPresenter)
public protocol SegmentedViewControllerItemPresenter {
	func presentItem(item: SegmentedViewControllerItem, atIndex index: Int, usingAnimation animated: Bool)
	func refreshItem(item: SegmentedViewControllerItem, atIndex index: Int, usingAnimation animated: Bool)
	func clearItems()
}

@objc(SEGSegmentedViewControllerItemsManager)
public class SegmentedViewControllerItemsManager: NSCoding, SegmentedViewControllerItemDelegate {
	
	// MARK: Public Properties
	
	weak public var parentController: UIViewController?
	weak public var presenter: SegmentedViewControllerItemPresenter?
	public var animateChanges = false
	
	weak public var segmentControl: UISegmentedControl? {
		didSet {
			if let newControl = segmentControl {
				resetAndDisplaySegmentsForControl(newControl)
			}
		}
	}
	
	public var numberOfItems: Int {
		get {
			return items.count
		}
	}
	
	public var hasItems: Bool {
		get {
			return numberOfItems > 0
		}
	}
	
	
	// MARK: Private Properties
	
	private var items = [SegmentedViewControllerItem]()
	
	
	// MARK: Initialization
	
	public init() {}
	
	
	// MARK: NSCoding
	
	public required init(coder aDecoder: NSCoder) {
		if let encodedItems = aDecoder.decodeObjectForKey(SEGItemsManagerItemsCoderKey) as? [SegmentedViewControllerItem] {
			items = encodedItems
		}
	}
	
	public func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(items, forKey: SEGItemsManagerItemsCoderKey)
	}
	
	
	// MARK: SegmentedViewControllerItemDelegate
	
	public func segmentItemDidChange(item: SegmentedViewControllerItem) {
		if let index = find(items, item) {
			itemDidRefresh(item, atIndex: index)
		}
	}
	
	
	// MARK: Public
	
	public func addItem(item: SegmentedViewControllerItem, animated: Bool) {
		if !contains(items, item) {
			items.append(item)
			let itemIndex = find(items, item)
			item.delegate = self
			presenter?.presentItem(item, atIndex: itemIndex!, usingAnimation: animated)
		}
	}
	
	public func addController(controller: UIViewController, animated: Bool) {
		var theTitle = ""
		if let title = controller.title {
			theTitle = title
		}
		
		addController(controller, withTitle: theTitle, animated: animated)
	}
	
	public func addController(controller: UIViewController, withTitle title: String, animated: Bool) {
		let item = SegmentedViewControllerItem(controller: controller, text: title)
		addItem(item, animated: animated)
	}
	
	public func addController(controller: UIViewController, withIcon icon: UIImage, animated: Bool) {
		let item = SegmentedViewControllerItem(controller: controller, icon: icon)
		addItem(item, animated: animated)
	}
	
	public func setContentOfController(controller: UIViewController, toText text: String, animated: Bool) -> Bool {
		if let item = findItemWithController(controller) {
			item.text = text
			return true
		}
		else {
			return false
		}
	}
	
	public func setContentOfController(controller: UIViewController, toIcon icon: UIImage, animated: Bool) -> Bool {
		if let item = findItemWithController(controller) {
			item.icon = icon
			return true
		}
		else {
			return false
		}
	}
	
	public func itemAtIndex(index: Int) -> SegmentedViewControllerItem? {
		if items.isIndexLegal(index) && index != UISegmentedControlNoSegment {
			return items[index]
		}
		else {
			return nil
		}
	}
	
	public func findItemWithController(controller: UIViewController) -> SegmentedViewControllerItem? {
		return first(filter(items, { $0.viewController == controller }))
	}
	
	
	// MARK: Private
	
	private func resetAndDisplaySegmentsForControl(control: UISegmentedControl) {
		presenter?.clearItems()
		for var index = 0; index < items.count; index++ {
			let item = items[index]
			presenter?.presentItem(item, atIndex: index, usingAnimation: false)
		}
	}
	
	private func itemDidRefresh(item: SegmentedViewControllerItem, atIndex index: Int) {
		presenter?.refreshItem(item, atIndex: index, usingAnimation: animateChanges)
	}
	
}
