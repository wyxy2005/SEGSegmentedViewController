//
//  SegmentedViewControllerItemsManagerTests.swift
//  SegmentedViewController
//
//  Created by Thomas Sherwood on 08/09/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

import Foundation
import SegmentedViewController
import UIKit
import XCTest

class SegmentedViewControllerItemsManagerTests: XCTestCase {
	
	func testInit() {
		let manager = SegmentedViewControllerItemsManager()
		
		XCTAssertNil(manager.parentController, "Parent view controller should be nil on initialization")
		XCTAssertEqual(0, manager.numberOfItems, "No items should be in the manager on initialization")
	}

	func testEncodeWithCoder() {
		let manager = SegmentedViewControllerItemsManager()
		let controller = UIViewController()
		controller.title = "Title"
		manager.addController(controller, animated: false)
		let data = NSMutableData()
		let encoder = NSKeyedArchiver(forWritingWithMutableData: data)
		manager.encodeWithCoder(encoder)
		encoder.finishEncoding()
		let decoder = NSKeyedUnarchiver(forReadingWithData: data)
		let items = decoder.decodeObjectForKey(SEGItemsManagerItemsCoderKey) as? [SegmentedViewControllerItem]
		
		XCTAssertNotNil(items, "Items not encoded with coder")
		XCTAssertEqual(1, items!.count, "Items not encoded properly")
	}
	
	func testInitWithCoderWithNoEncodedItems() {
		let data = NSMutableData()
		let decoder = NSKeyedUnarchiver(forReadingWithData: data)
		let manager = SegmentedViewControllerItemsManager(coder: decoder)
		
		XCTAssertEqual(0, manager.numberOfItems, "Coder did not possess any items")
	}
	
	func testInitWithCoderWithEncodedItems() {
		let data = NSMutableData()
		let encoder = NSKeyedArchiver(forWritingWithMutableData: data)
		let controller = UIViewController()
		let title = "Title"
		controller.title = title
		let items = [SegmentedViewControllerItem(controller: controller)]
		encoder.encodeObject(items, forKey: SEGItemsManagerItemsCoderKey)
		encoder.finishEncoding()
		let decoder = NSKeyedUnarchiver(forReadingWithData: data)
		let item = SegmentedViewControllerItemsManager(coder: decoder)
		
		XCTAssertEqual(1, item.numberOfItems, "Item in coder not retained by manager")
		XCTAssertEqual(title, item.itemAtIndex(0)!.viewController!.title!, "Provided item not retained by manager")
	}
	
	func testAddItemNotPreviouslyAdded() {
		let controller = UIViewController()
		let manager = SegmentedViewControllerItemsManager()
		let item = SegmentedViewControllerItem(controller: controller)
		manager.addItem(item, animated: false)
		
		XCTAssertEqual(1, manager.numberOfItems, "Item not added to items manager")
		XCTAssert(manager.itemAtIndex(0)! === item, "Item provided to addItem:animated: not retained")
		XCTAssert(manager.itemAtIndex(0)!.delegate === manager, "Manager must assign itself as the delegate of items it retains")
	}
	
	func testAddItemPreviouslyAdded() {
		let controller = UIViewController()
		let manager = SegmentedViewControllerItemsManager()
		let item = SegmentedViewControllerItem(controller: controller)
		manager.addItem(item, animated: false)
		manager.addItem(item, animated: false)
		
		XCTAssertEqual(1, manager.numberOfItems, "Item should be added to the manager only once")
	}
	
	func testAddItemNotifiesPresenter() {
		let controller = UIViewController()
		let manager = SegmentedViewControllerItemsManager()
		let item = SegmentedViewControllerItem(controller: controller)
		let presenter = SegmentedViewControllerItemPresenterMock()
		let animated = true
		manager.presenter = presenter
		manager.addItem(item, animated: animated)
		
		XCTAssertNotNil(presenter.item, "Item not provided to presenter")
		XCTAssertNotNil(presenter.index, "Index not provided to presenter")
		XCTAssertNotNil(presenter.animated, "Animation flag not provided to presenter")
		XCTAssert(presenter.item === item, "Item not provided to presenter")
		XCTAssert(presenter.index! == 0, "Index not provided to presenter")
		XCTAssert(presenter.animated! == animated, "Animation flag not provided to presenter")
	}
	
	func testAddControllerWithNoTitleAddsItemWithEmptyTitle() {
		let controller = UIViewController()
		let manager = SegmentedViewControllerItemsManager()
		manager.addController(controller, animated: false)
		
		XCTAssertEqual(1, manager.numberOfItems, "Item not added to items manager")
		XCTAssertNotNil(manager.itemAtIndex(0)!.text, "No title provided to item")
		XCTAssertEqual("", manager.itemAtIndex(0)!.text!, "Empty title not provided to item")
	}
	
	func testAddControllerWithTitle() {
		let controller = UIViewController()
		let title = "Title"
		let manager = SegmentedViewControllerItemsManager()
		manager.addController(controller, withTitle: title, animated: false)
		
		XCTAssertEqual(1, manager.numberOfItems, "Item not added to items manager")
		XCTAssertNotNil(manager.itemAtIndex(0)!.text, "Title not provided to item")
		XCTAssertEqual(title, manager.itemAtIndex(0)!.text!, "Title not provided to item")
	}
	
	func testAddControllerWithIcon() {
		let controller = UIViewController()
		let icon = UIImage()
		let manager = SegmentedViewControllerItemsManager()
		manager.addController(controller, withIcon: icon, animated: false)
		
		XCTAssertEqual(1, manager.numberOfItems, "Item not added to items manager")
		XCTAssertNotNil(manager.itemAtIndex(0)!.icon, "Icon not provided to item")
		XCTAssertEqual(icon.hash, manager.itemAtIndex(0)!.icon!.hash, "Icon not provided to item")
	}
	
	func testItemAtIndexWithNoItems() {
		let manager = SegmentedViewControllerItemsManager()
		let item = manager.itemAtIndex(0)
		
		XCTAssertNil(item, "No items in manager")
	}
	
	func testItemAtIndexWithNegativeIndex() {
		let controller = UIViewController()
		let manager = SegmentedViewControllerItemsManager()
		manager.addController(controller, animated: false)
		let item = manager.itemAtIndex(-1)
		
		XCTAssertNil(item, "Negative indicies should return nil")
	}
	
	func testItemAtIndexWithIndexGreaterThanCount() {
		let controller = UIViewController()
		let manager = SegmentedViewControllerItemsManager()
		manager.addController(controller, animated: false)
		let item = manager.itemAtIndex(1)
		
		XCTAssertNil(item, "Items out of range should return nil")
	}
	
	func testItemAtIndexWithUISegmentedControlNoSegment() {
		let controller = UIViewController()
		let manager = SegmentedViewControllerItemsManager()
		manager.addController(controller, animated: false)
		let item = manager.itemAtIndex(UISegmentedControlNoSegment)
		
		XCTAssertNil(item, "UISegmentedControlNoSegment should return nil")
	}
	
	func testItemAtIndexLowerEdgeCase() {
		let controller = UIViewController()
		let manager = SegmentedViewControllerItemsManager()
		let addedItem = SegmentedViewControllerItem(controller: controller)
		manager.addItem(addedItem, animated: false)
		let item = manager.itemAtIndex(0)
		
		XCTAssertNotNil(item, "Item at valid index")
		XCTAssert(item === addedItem, "Returned itemAtIndex: not expected item")
	}
	
	func testItemAtIndexUpperEdgeCase() {
		let controllerA = UIViewController()
		let controllerB = UIViewController()
		let manager = SegmentedViewControllerItemsManager()
		let addedItemA = SegmentedViewControllerItem(controller: controllerA)
		let addedItemB = SegmentedViewControllerItem(controller: controllerB)
		manager.addItem(addedItemA, animated: false)
		manager.addItem(addedItemB, animated: false)
		let item = manager.itemAtIndex(1)
		
		XCTAssertNotNil(item, "Item at valid index")
		XCTAssert(item === addedItemB, "Returned itemAtIndex: not expected item")
	}
	
	func testFindItemWithControllerNoItemsWithController() {
		let controller = UIViewController()
		let manager = SegmentedViewControllerItemsManager()
		let foundItem = manager.findItemWithController(controller)
		
		XCTAssertNil(foundItem, "No items possessed the controller")
	}
	
	func testFindItemWithControllerOneItemWithController() {
		let controller = UIViewController()
		let manager = SegmentedViewControllerItemsManager()
		let item = SegmentedViewControllerItem(controller: controller)
		manager.addItem(item, animated: false)
		let foundItem = manager.findItemWithController(controller)
		
		XCTAssertNotNil(foundItem, "One item possessed the controller")
	}
	
	func testFindItemWithControllerTwoItemsWithController() {
		let controller = UIViewController()
		let manager = SegmentedViewControllerItemsManager()
		let itemA = SegmentedViewControllerItem(controller: controller)
		let itemB = SegmentedViewControllerItem(controller: controller)
		manager.addItem(itemA, animated: false)
		let foundItem = manager.findItemWithController(controller)
		
		XCTAssert(foundItem === itemA, "First match should have been returned")
	}
	
	
	func testSetContentOfControllerToTextWhereControllerNotPreviouslyAdded() {
		let text = "Text"
		let controller = UIViewController()
		let manager = SegmentedViewControllerItemsManager()
		let didSet = manager.setContentOfController(controller, toText: text, animated: false)
		
		XCTAssertFalse(didSet, "Should not have been able to set text for controller not previously added")
	}
	
	func testSetContentOfControllerToTextWhereControllerPreviouslyAdded() {
		let text = "Text"
		let controller = UIViewController()
		let item = SegmentedViewControllerItem(controller: controller)
		let manager = SegmentedViewControllerItemsManager()
		manager.addItem(item, animated: false)
		let didSet = manager.setContentOfController(controller, toText: text, animated: false)
		
		XCTAssertTrue(didSet, "Should have been able to set content of added controller")
		XCTAssertNotNil(item.text, "Text not propgated to item")
		XCTAssertEqual(text, item.text!, "Text not propgated to item")
	}
	
	func testSetContentOfControllerToIconWhereControllerNotPreviouslyAdded() {
		let icon = UIImage()
		let controller = UIViewController()
		let manager = SegmentedViewControllerItemsManager()
		let didSet = manager.setContentOfController(controller, toIcon: icon, animated: false)
		
		XCTAssertFalse(didSet, "Should not have been able to set text for controller not previously added")
	}
	
	func testSetContentOfControllerToIconWhereControllerPreviouslyAdded() {
		let icon = UIImage()
		let controller = UIViewController()
		let item = SegmentedViewControllerItem(controller: controller)
		let manager = SegmentedViewControllerItemsManager()
		manager.addItem(item, animated: false)
		let didSet = manager.setContentOfController(controller, toIcon: icon, animated: false)
		
		XCTAssertTrue(didSet, "Should not have been able to set text for controller not previously added")
		XCTAssertNotNil(item.icon, "Icon not propgated to item")
		XCTAssertEqual(icon.hash, item.icon!.hash, "Icon not propgated to item")
	}
	
	func testHasItemsWithEmptyArray() {
		let manager = SegmentedViewControllerItemsManager()
		
		XCTAssertFalse(manager.hasItems, "HasItems should return false when array is empty")
	}
	
	func testHasItemsWithOneItem() {
		let manager = SegmentedViewControllerItemsManager()
		let controller = UIViewController()
		controller.title = "Title"
		manager.addController(controller, animated: false)
		
		XCTAssertTrue(manager.hasItems, "HasItems should return true when array contains one item or more")
	}

}
