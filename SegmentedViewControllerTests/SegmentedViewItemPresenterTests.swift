//
//  SegmentedViewItemPresenterTests.swift
//  SegmentedViewController
//
//  Created by Thomas Sherwood on 08/09/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

import Foundation
import SegmentedViewController
import UIKit
import XCTest

class SegmentedViewItemPresenterTests: XCTestCase {
	
	func testInitWithParentControllerAndSegmentedControl() {
		let controller = UIViewController()
		let segmentedControl = UISegmentedControl()
		let presenter = SegmentedViewItemPresenter(parentController: controller, segmentedControl: segmentedControl)
		
		XCTAssertEqual(controller, presenter.parentController, "Parent controller not retained by presenter")
		XCTAssertEqual(segmentedControl, presenter.segmentControl, "Segmented controller not retained by presenter")
	}
	
	func testPresentItemWithNoViewControllerDoesNotAddChildViewController() {
		let controller = UIViewController()
		let segmentedControl = UISegmentedControl()
		let presenter = SegmentedViewItemPresenter(parentController: controller, segmentedControl: segmentedControl)
		let item = SegmentedViewControllerItem()
		presenter.presentItem(item, atIndex: 0, usingAnimation: false)
		
		XCTAssertEqual(0, controller.childViewControllers.count, "No child view controller should be added")
	}
	
	func testPresentItemWithViewControllerAddsChildViewController() {
		let controller = UIViewController()
		let segmentedControl = UISegmentedControl()
		let presenter = SegmentedViewItemPresenter(parentController: controller, segmentedControl: segmentedControl)
		let secondaryController = UIViewController()
		let item = SegmentedViewControllerItem(controller: secondaryController)
		presenter.presentItem(item, atIndex: 0, usingAnimation: false)
		
		XCTAssertEqual(1, controller.childViewControllers.count, "Child view controller should be added")
		XCTAssertTrue(contains(controller.childViewControllers as [UIViewController], secondaryController), "Child controllers should contain view controller")
	}
	
	func testPresentItemWithNoneTypeDoesNothing() {
		let controller = UIViewController()
		let segmentedControl = UISegmentedControl()
		let presenter = SegmentedViewItemPresenter(parentController: controller, segmentedControl: segmentedControl)
		let secondaryController = UIViewController()
		let item = SegmentedViewControllerItem(controller: secondaryController)
		let segmentControl = UISegmentedControl()
		presenter.presentItem(item, atIndex: 0, usingAnimation: false)
		
		XCTAssertEqual(0, segmentControl.numberOfSegments, "None type should not be added")
	}
	
	func testPresentItemWithTextType() {
		let controller = UIViewController()
		let segmentedControl = UISegmentedControl()
		let presenter = SegmentedViewItemPresenter(parentController: controller, segmentedControl: segmentedControl)
		let secondaryController = UIViewController()
		let text = "Text"
		let item = SegmentedViewControllerItem(controller: secondaryController, text: text)
		presenter.presentItem(item, atIndex: 0, usingAnimation: false)
		
		XCTAssertEqual(1, segmentedControl.numberOfSegments, "Segment not added to control")
		XCTAssertNotNil(segmentedControl.titleForSegmentAtIndex(0), "Title not set against segment")
		XCTAssertEqual(segmentedControl.titleForSegmentAtIndex(0)!, text, "Incorrect title set against segment")
	}
	
	func testPresentItemWithIconType() {
		let controller = UIViewController()
		let segmentedControl = UISegmentedControl()
		let presenter = SegmentedViewItemPresenter(parentController: controller, segmentedControl: segmentedControl)
		let secondaryController = UIViewController()
		let icon = UIImage()
		let item = SegmentedViewControllerItem(controller: controller, icon: icon)
		presenter.presentItem(item, atIndex: 0, usingAnimation: false)
		
		XCTAssertEqual(1, segmentedControl.numberOfSegments, "Segment not added to control")
		XCTAssertNotNil(segmentedControl.imageForSegmentAtIndex(0), "Image not set against segment")
		XCTAssertEqual(icon.hash, segmentedControl.imageForSegmentAtIndex(0)!.hash, "Incorrect image set against segment")
	}
	
	func testRefreshSegmentThatDoesNotExist() {
		let controller = UIViewController()
		let segmentedControl = UISegmentedControl()
		let presenter = SegmentedViewItemPresenter(parentController: controller, segmentedControl: segmentedControl)
		let secondaryController = UIViewController()
		let text = "Text"
		let item = SegmentedViewControllerItem(controller: secondaryController, text: text)
		presenter.refreshItem(item, atIndex: 0, usingAnimation: false)
		
		XCTAssertEqual(0, segmentedControl.numberOfSegments, "Refresh call should not add segment")
	}
	
	func testRefreshSegmentWithTextType() {
		let controller = UIViewController()
		let segmentedControl = UISegmentedControl()
		let presenter = SegmentedViewItemPresenter(parentController: controller, segmentedControl: segmentedControl)
		let secondaryController = UIViewController()
		let text = "Text"
		let item = SegmentedViewControllerItem(controller: secondaryController, text: text)
		segmentedControl.insertSegmentWithTitle(text, atIndex: 0, animated: false)
		let newTitle = "New Text"
		item.text = newTitle
		presenter.refreshItem(item, atIndex: 0, usingAnimation: false)
		
		XCTAssertEqual(newTitle, segmentedControl.titleForSegmentAtIndex(0)!, "New title not propogated to control")
	}
	
	func testRefreshSegmentWithIconType() {
		let controller = UIViewController()
		let segmentedControl = UISegmentedControl()
		let presenter = SegmentedViewItemPresenter(parentController: controller, segmentedControl: segmentedControl)
		let secondaryController = UIViewController()
		let text = "Text"
		let item = SegmentedViewControllerItem(controller: secondaryController, text: text)
		let icon = UIImage()
		segmentedControl.insertSegmentWithImage(icon, atIndex: 0, animated: false)
		let newIcon = UIImage()
		item.icon = newIcon
		presenter.refreshItem(item, atIndex: 0, usingAnimation: false)
		
		XCTAssert(newIcon === segmentedControl.imageForSegmentAtIndex(0)!, "New icon not propogated to control")
	}
	
	func testClearItems() {
		let controller = UIViewController()
		let segmentedControl = UISegmentedControl()
		let presenter = SegmentedViewItemPresenter(parentController: controller, segmentedControl: segmentedControl)
		segmentedControl.insertSegmentWithTitle("Title", atIndex: 0, animated: false)
		presenter.clearItems()
		
		XCTAssertEqual(0, segmentedControl.numberOfSegments, "clearItems did not remove segments")
	}

}
