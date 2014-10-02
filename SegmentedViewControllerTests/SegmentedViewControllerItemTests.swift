//
//  SegmentedViewControllerItemTests.swift
//  SegmentedViewController
//
//  Created by Thomas Sherwood on 08/09/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

import Foundation
import SegmentedViewController
import UIKit
import XCTest

class SegmentedViewControllerItemTests: XCTestCase {
	
	func testInitWithController() {
		let controller = UIViewController()
		let item = SegmentedViewControllerItem(controller: controller)
		
		XCTAssertNotNil(item.viewController, "Controller not assigned to item")
		XCTAssertEqual(controller, item.viewController!, "Controller not assigned to item")
	}
	
	func testInitWithControllerSetsTypeToNone() {
		let controller = UIViewController()
		let item = SegmentedViewControllerItem(controller: controller)
		
		XCTAssertEqual(SegmentedItemType.None, item.type, "Designated initializer must set type to none")
	}
	
	func testInitWithControllerAndText() {
		let controller = UIViewController()
		let text = "Title"
		let item = SegmentedViewControllerItem(controller: controller, text: text)
		
		XCTAssertNotNil(item.text, "Text not assigned to item")
		XCTAssertEqual(text, item.text!, "Text not assigned to item")
	}
	
	func testInitWithControllerAndTextSetsTypeToText() {
		let controller = UIViewController()
		let text = "Title"
		let item = SegmentedViewControllerItem(controller: controller, text: text)
		
		XCTAssertEqual(SegmentedItemType.Text, item.type, "Text convinience initializer must set type to Text")
	}
	
	func testInitWithControllerAndIcon() {
		let controller = UIViewController()
		let icon = UIImage()
		let item = SegmentedViewControllerItem(controller: controller, icon: icon)
		
		XCTAssertNotNil(item.icon, "Icon not assigned to item")
		XCTAssertEqual(icon, item.icon!, "Icon not assigned to item")
	}
	
	func testInitWithControllerAndIconSetsTypeToIcon() {
		let controller = UIViewController()
		let icon = UIImage()
		let item = SegmentedViewControllerItem(controller: controller, icon: icon)
		
		XCTAssertEqual(SegmentedItemType.Icon, item.type, "Icon convinience initializer must set type to Icon")
	}
	
	func testSetTextChangesTypeToTitle() {
		let controller = UIViewController()
		let item = SegmentedViewControllerItem(controller: controller)
		item.text = "Text"
		
		XCTAssertEqual(SegmentedItemType.Text, item.type, "Setting Text property must change type to Text")
	}
	
	func testSetIconChangesTypeToIcon() {
		let controller = UIViewController()
		let item = SegmentedViewControllerItem(controller: controller)
		item.icon = UIImage()
		
		XCTAssertEqual(SegmentedItemType.Icon, item.type, "Setting Icon property must change type to Icon")
	}
	
	func testEncodeWithCoderWithNoIconOrTextEncodesNoneType() {
		let data = NSMutableData()
		let encoder = NSKeyedArchiver(forWritingWithMutableData: data)
		let controller = UIViewController()
		let item = SegmentedViewControllerItem(controller: controller)
		item.encodeWithCoder(encoder)
		encoder.finishEncoding()
		let decoder = NSKeyedUnarchiver(forReadingWithData: data)
		let typeItem: AnyObject? = decoder.decodeObjectForKey(SEGItemTypeCoderKey)
		
		XCTAssertNotNil(typeItem, "Item type not encoded")
		XCTAssertTrue(typeItem is NSNumber, "Item type not encoded as NSNumber")
		XCTAssertEqual((typeItem as NSNumber).integerValue, SegmentedItemType.None.rawValue, "Encoded type not SegmentedItemType.None")
	}
	
	func testEncodeWithCoderWithController() {
		let data = NSMutableData()
		let encoder = NSKeyedArchiver(forWritingWithMutableData: data)
		let controller = UIViewController()
		let title = "Title"
		controller.title = title
		let item = SegmentedViewControllerItem(controller: controller)
		item.encodeWithCoder(encoder)
		encoder.finishEncoding()
		let decoder = NSKeyedUnarchiver(forReadingWithData: data)
		let controllerItem = decoder.decodeObjectForKey(SEGViewControllerCoderKey) as? UIViewController
		
		XCTAssertNotNil(controllerItem, "Controller not encoded")
		XCTAssertEqual(title, controllerItem!.title!, "Encoded controller not equal to original controller")
	}
	
	func testEncodeWithCoderWithText() {
		let data = NSMutableData()
		let encoder = NSKeyedArchiver(forWritingWithMutableData: data)
		let controller = UIViewController()
		let text = "Text"
		let item = SegmentedViewControllerItem(controller: controller, text: text)
		item.encodeWithCoder(encoder)
		encoder.finishEncoding()
		let decoder = NSKeyedUnarchiver(forReadingWithData: data)
		let textItem = decoder.decodeObjectForKey(SEGViewControllerTitleCoderKey) as? String
		
		XCTAssertNotNil(textItem, "Text not encoded")
		XCTAssertEqual(text, textItem!, "Encoded text not equal to original text")
	}
	
	func testEncodeWithCoderWithTextEncodesTextType() {
		let data = NSMutableData()
		let encoder = NSKeyedArchiver(forWritingWithMutableData: data)
		let controller = UIViewController()
		let text = "Text"
		let item = SegmentedViewControllerItem(controller: controller, text: text)
		item.encodeWithCoder(encoder)
		encoder.finishEncoding()
		let decoder = NSKeyedUnarchiver(forReadingWithData: data)
		let typeItem = decoder.decodeObjectForKey(SEGItemTypeCoderKey) as? NSNumber
		
		XCTAssertNotNil(typeItem, "Item type not encoded")
		XCTAssertEqual(SegmentedItemType.Text, SegmentedItemType(rawValue: typeItem!.integerValue)!, "Item type not encoded as Text")
	}
	
	func testEncodeWithCoderWithIcon() {
		let data = NSMutableData()
		let encoder = NSKeyedArchiver(forWritingWithMutableData: data)
		let controller = UIViewController()
		let icon = UIImage()
		let item = SegmentedViewControllerItem(controller: controller, icon: icon)
		item.encodeWithCoder(encoder)
		encoder.finishEncoding()
		let decoder = NSKeyedUnarchiver(forReadingWithData: data)
		let iconItem = decoder.decodeObjectForKey(SEGViewControllerIconCoderKey) as? UIImage
		
		XCTAssertNotNil(iconItem, "Icon not encoded")
		XCTAssertEqual(icon.hash, iconItem!.hash, "Encoded icon not equal to original icon")
	}
	
	func testEncodeWithCoderWithIconEncodesIconType() {
		let data = NSMutableData()
		let encoder = NSKeyedArchiver(forWritingWithMutableData: data)
		let controller = UIViewController()
		let icon = UIImage()
		let item = SegmentedViewControllerItem(controller: controller, icon: icon)
		item.encodeWithCoder(encoder)
		encoder.finishEncoding()
		let decoder = NSKeyedUnarchiver(forReadingWithData: data)
		let typeItem = decoder.decodeObjectForKey(SEGItemTypeCoderKey) as? NSNumber
		
		XCTAssertNotNil(typeItem, "Item type not encoded")
		XCTAssertEqual(SegmentedItemType.Icon, SegmentedItemType(rawValue: typeItem!.integerValue)!, "Item type not encoded as Icon")
	}
	
	func testObserveChangeToTitleOfControllerUpdatesText() {
		let title = "Title"
		let controller = UIViewController()
		let item = SegmentedViewControllerItem(controller: controller, text: title)
		let newTitle = "New Title"
		controller.title = newTitle
		
		XCTAssertEqual(newTitle, item.text!, "New title not propogated via KVO")
	}
	
	func testChangeToTextPropertyNotifiesDelegate() {
		let controller = UIViewController()
		let item = SegmentedViewControllerItem(controller: controller)
		let delegateMock = SegmentedViewControllerItemDelegateMock()
		item.delegate = delegateMock
		let newTitle = "Title"
		item.text = newTitle
		
		XCTAssertNotNil(delegateMock.item, "Delegate not notified of change")
		XCTAssertEqual(item, delegateMock.item!, "Updated item not provided to delegate")
	}
	
	func testChangeToIconPropertyNotifiesDelegate() {
		let controller = UIViewController()
		let item = SegmentedViewControllerItem(controller: controller)
		let delegateMock = SegmentedViewControllerItemDelegateMock()
		item.delegate = delegateMock
		let newIcon = UIImage()
		item.icon = newIcon
		
		XCTAssertNotNil(delegateMock.item, "Delegate not notified of change")
		XCTAssertEqual(item, delegateMock.item!, "Updated item not provided to delegate")
	}

}
