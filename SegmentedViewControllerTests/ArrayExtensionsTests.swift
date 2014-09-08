//
//  ArrayExtensionsTests.swift
//  SegmentedViewController
//
//  Created by Thomas Sherwood on 08/09/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

import Foundation
import SegmentedViewController
import XCTest

class ArrayExtensionsTests: XCTestCase {
	
	func testIsIndexLegalWithZeroLengthArray() {
		let items = [AnyObject]()
		
		XCTAssertFalse(items.isIndexLegal(1), "Zero-length array should not possess any legal indicies")
	}
	
	func testIsIndexLegalWithNegativeIndex() {
		let items = ["Item"]
		
		XCTAssertFalse(items.isIndexLegal(-1), "Negative indicies should return false")
	}
	
	func testIsIndexLegalWhereIndexBeyondArrayBounds() {
		let items = ["Item"]
		
		XCTAssertFalse(items.isIndexLegal(1), "Indicies out of array bounds should return false")
	}
	
	func testIsIndexLegalLowerEdgeCase() {
		let items = ["Item"]
		
		XCTAssertTrue(items.isIndexLegal(0), "Index 0 for 1 item should return true")
	}
	
	func testIsIndexLegalUpperEdgeCase() {
		let items = ["Item 1", "Item 2"]
		
		XCTAssertTrue(items.isIndexLegal(1), "Count - 1 (where count > 0) should be a legal index")
	}

}
