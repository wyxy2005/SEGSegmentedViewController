//
//  Helpers.swift
//  SegmentedViewController
//
//  Created by Thomas Sherwood on 07/09/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

import Foundation

public func ensureValue(inout value: Int, isInRange range: Range<Int>) {
	if value < range.startIndex {
		value = range.startIndex
	}
	else if value >= range.endIndex {
		value = range.endIndex - 1
	}
}
