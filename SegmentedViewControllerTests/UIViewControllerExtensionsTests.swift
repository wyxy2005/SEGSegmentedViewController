//
//  UIViewControllerExtensionsTests.swift
//  SegmentedViewController
//
//  Created by Thomas Sherwood on 07/09/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

import SegmentedViewController
import UIKit
import XCTest

class UIViewControllerExtensionsTests: XCTestCase {

	func testGetNavigationAndTabBarInsetsWithNoNavOrTabBars() {
		let controller = UIViewController()
		let insets = controller.navigationAndTabBarInsets
		let statusBarHeight = CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
		let expectedInsets = UIEdgeInsetsMake(statusBarHeight, 0, 0, 0)
		
		XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(insets, expectedInsets), "Controller returned unexpected insets")
	}
	
	func testGetNavigationAndTabBarInsetsWithNavBar() {
		let controller = UIViewController()
		let navController = UINavigationController(rootViewController: controller)
		let insets = controller.navigationAndTabBarInsets
		let statusBarHeight = CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
		let navBarHeight = CGRectGetHeight(navController.navigationBar.frame)
		let expectedInsets = UIEdgeInsetsMake(statusBarHeight + navBarHeight, 0, 0, 0)
		
		XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(insets, expectedInsets), "Controller returned unexpected insets")
	}
	
	func testGetNavigationAndTabBarInsetsWithTabBar() {
		let controller = UIViewController()
		let tabController = UITabBarController()
		tabController.addChildViewController(controller)
		let insets = controller.navigationAndTabBarInsets
		let statusBarHeight = CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
		let tabBarHeight = CGRectGetHeight(tabController.tabBar.frame)
		
		let expectedInsets = UIEdgeInsetsMake(statusBarHeight, 0, tabBarHeight, 0)
		
		XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(insets, expectedInsets), "Controller returned unexpected insets")
	}
	
	func testGetNavigationAndTabBarInsetsWithNavAndTabBars() {
		let controller = UIViewController()
		let navController = UINavigationController(rootViewController: controller)
		let tabController = UITabBarController()
		tabController.addChildViewController(navController)
		let insets = controller.navigationAndTabBarInsets
		let statusBarHeight = CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
		let navBarHeight = CGRectGetHeight(navController.navigationBar.frame)
		let tabBarHeight = CGRectGetHeight(tabController.tabBar.frame)
		let expectedInsets = UIEdgeInsetsMake(statusBarHeight + navBarHeight, 0, tabBarHeight, 0)
		
		XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(insets, expectedInsets), "Controller returned unexpected insets")
	}
	
	func testGetSegmentedViewControllerNoParent() {
		let controller = UIViewController()
		let segmentController = controller.segmentedViewController
		
		XCTAssertNil(segmentController, "No segmented parent should be within the view hiearchy")
	}
	
	func testGetSegmentedViewControllerNoSegmentedController() {
		let controller = UIViewController()
		let navController = UINavigationController(rootViewController: controller)
		let segmentController = controller.segmentedViewController
		
		XCTAssertNil(segmentController, "No segmented parent should be within the view hiearchy")
	}
	
	func testGetSegmentedViewControllerWithSegmentedController() {
		let controller = UIViewController()
		let segmentController = SegmentedViewController()
		segmentController.addChildViewController(controller)
		let detectedSegmentController = controller.segmentedViewController
		
		XCTAssertNotNil(detectedSegmentController, "Segmented parent should have been detected")
		XCTAssertEqual(segmentController, detectedSegmentController!, "Same segment controller should be detected")
	}
	
	func testGetSegmentedViewControllerSelfIsSegmentdController() {
		let controller = SegmentedViewController()
		let detectedSegmentController = controller.segmentedViewController
		
		XCTAssertNotNil(detectedSegmentController, "Segmented parent should have been detected")
		XCTAssertEqual(controller, detectedSegmentController!, "Same segment controller should be detected")
	}
	
}
