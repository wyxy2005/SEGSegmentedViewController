//
//  UIEdgeInsetsExtensionTests.swift
//  SegmentedViewController
//
//  Created by Thomas Sherwood on 07/09/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

import UIKit
import XCTest

class UIEdgeInsetsExtensionTests: XCTestCase {

	func testSumWithInsets() {
		var insets = UIEdgeInsetsMake(0, 0, 0, 0)
		let extraInsets = UIEdgeInsetsMake(1, 1, 1, 1)
		insets.sumWithInsets(extraInsets)
		
		XCTAssertEqual(1, Int(insets.top), "Top not provided new value")
		XCTAssertEqual(1, Int(insets.bottom), "Bottom not provided new value")
		XCTAssertEqual(1, Int(insets.left), "Left not provided new value")
		XCTAssertEqual(1, Int(insets.right), "Right not provided new value")
	}
	
}
