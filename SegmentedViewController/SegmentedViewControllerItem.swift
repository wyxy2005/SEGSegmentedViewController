
//
//  SegmentedViewControllerItem.swift
//  SegmentedViewController
//
//  Created by Thomas Sherwood on 07/09/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

import Foundation
import UIKit

public let SEGItemTypeCoderKey = "SegmentedViewControllerItem.Type"
public let SEGViewControllerCoderKey = "SegmentedViewControllerItem.ViewController"
public let SEGViewControllerTitleCoderKey = "SegmentedViewControllerItem.Title"
public let SEGViewControllerIconCoderKey = "SegmentedViewControllerItem.Icon"

public enum SegmentedItemType: Int {
	case None
	case Text
	case Icon
}

@objc(SEGSegmentedViewControllerItemDelegate)
public protocol SegmentedViewControllerItemDelegate {
	optional func segmentItemDidChange(item: SegmentedViewControllerItem)
}


@objc(SEGSegmentedViewControllerItem)
public class SegmentedViewControllerItem: NSObject, NSCoding, Equatable {
	
	// MARK: Public Properties
	
	public var delegate: SegmentedViewControllerItemDelegate?
	private(set) public var viewController: UIViewController?
	private(set) public var type: SegmentedItemType = .None
	
	public var text: String? {
		didSet {
			if let newText = text {
				type = .Text
			}
			
			notifyDelegateOfChange()
		}
	}
	
	public var icon: UIImage? {
		didSet {
			if let newIcon = icon {
				type = .Icon
			}
			
			notifyDelegateOfChange()
		}
	}

	
	// MARK: Designated Initializer
	
	public override init() {
		type = .None
		super.init()
	}
	
	
	// MARK: Convinience Initializers
	
	public convenience init(controller: UIViewController) {
		self.init()
		
		viewController = controller
		registerForKVO()
	}
	
	public convenience init(controller: UIViewController, text: String) {
		self.init(controller: controller)
		self.text = text
		type = .Text
	}
	
	public convenience init(controller: UIViewController, icon: UIImage) {
		self.init(controller: controller)
		self.icon = icon
		type = .Icon
	}
	
	
	// MARK: Deinitialization
	
	deinit {
		viewController?.removeObserver(self, forKeyPath: "title")
	}
	
	
	// MARK: NSCoding
	
	public required init(coder aDecoder: NSCoder) {
		var itemType = SegmentedItemType.None
		if let wrappedType = aDecoder.decodeObjectForKey(SEGItemTypeCoderKey) as? NSNumber {
			if let theType = SegmentedItemType.fromRaw(wrappedType.integerValue) {
				itemType = theType
			}
		}
		
		type = itemType
		
		if let controller = aDecoder.decodeObjectForKey(SEGViewControllerCoderKey) as? UIViewController {
			viewController = controller
		}
		
		if let theText = aDecoder.decodeObjectForKey(SEGViewControllerTitleCoderKey) as? String {
			text = theText
			if type == .None {
				type = .Text
			}
		}
		
		if let theIcon = aDecoder.decodeObjectForKey(SEGViewControllerIconCoderKey) as? UIImage {
			icon = theIcon
			if type == .None {
				type = .Icon
			}
		}
		
		super.init()
		registerForKVO()
	}
	
	public func encodeWithCoder(aCoder: NSCoder) {
		let wrappedNumber = NSNumber.convertFromIntegerLiteral(type.toRaw())
		aCoder.encodeObject(wrappedNumber, forKey: SEGItemTypeCoderKey)
		
		if let controller = viewController {
			aCoder.encodeObject(controller, forKey: SEGViewControllerCoderKey)
		}
		
		if let theText = text {
			aCoder.encodeObject(theText, forKey: SEGViewControllerTitleCoderKey)
		}
		
		if let theIcon = icon {
			aCoder.encodeObject(theIcon, forKey: SEGViewControllerIconCoderKey)
		}
	}
	
	
	// MARK: Public
	
	public func wasPresentedInSegmentedController(segmentedController: SegmentedViewController) {
		// Virtual
	}
	
	public func wasRemovedFromPresentationInSegmentedController(segmentedController: SegmentedViewController) {
		// Virtual
	}
	
	
	// MARK: KVO
	
	public override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
		if !observerViewControllerPropertyChange(keyPath, change: change) {
			super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
		}
	}
	
	
	// MARK: Private
	
	private func registerForKVO() {
		if let controller = viewController {
			controller.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.New, context: nil)
		}
	}
	
	private func observerViewControllerPropertyChange(propertyName: String, change: [NSObject: AnyObject]) -> Bool {
		switch propertyName {
		case "title":
			observeChangeInTitle(change["new"])
			return true
			
		default:
			return false
		}
	}
	
	private func observeChangeInTitle(title: AnyObject?) {
		if let newTitle = title as? String {
			text = newTitle
		}
	}
	
	private func notifyDelegateOfChange() {
		delegate?.segmentItemDidChange?(self)
	}
}

public func ==(lhs: SegmentedViewControllerItem, rhs: SegmentedViewControllerItem) -> Bool {
	if lhs.viewController != rhs.viewController {
		return false
	}
	
	if lhs.type != rhs.type {
		return false
	}
	
	switch lhs.type {
	case .Icon:
		return lhs.icon == rhs.icon
		
	case .Text:
		return lhs.text == rhs.text
		
	default:
		return true
	}
}
