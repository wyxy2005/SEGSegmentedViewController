//
//  HelpersTests.swift
//  SegmentedViewController
//
//  Created by Thomas Sherwood on 07/09/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

import SegmentedViewController
import UIKit
import XCTest

class HelpersTests: XCTestCase {

	func testEnsureValueLessThanStartIndex() {
		var value = 0
		let startIndex = 1
		let endIndex = 2
		let range = Range(start: startIndex, end: endIndex)
		ensureValue(&value, isInRange: range)
		
		XCTAssertEqual(value, startIndex, "Value not modified to become start index")
	}
	
	func testEnsureValueGreaterThanEndIndex() {
		var value = 3
		let startIndex = 1
		let endIndex = 2
		let range = Range(start: startIndex, end: endIndex)
		ensureValue(&value, isInRange: range)
		
		XCTAssertEqual(value, startIndex, "Value not modified to become end index")
	}
	
	func testEnsureValueEqualToStartIndex() {
		var value = 1
		let startIndex = 1
		let endIndex = 2
		let range = Range(start: startIndex, end: endIndex)
		ensureValue(&value, isInRange: range)
		
		XCTAssertEqual(value, startIndex, "Value modified while legal value")

	}
	
	func testEnsureValueEqualToEndIndex() {
		var value = 2
		let startIndex = 1
		let endIndex = 2
		let range = Range(start: startIndex, end: endIndex)
		ensureValue(&value, isInRange: range)
		
		XCTAssertEqual(value, startIndex, "Value modified while legal value")
	}
	
}
