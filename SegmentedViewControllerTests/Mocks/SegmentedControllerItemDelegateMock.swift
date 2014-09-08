//
//  SegmentedControllerItemDelegateMock.swift
//  SegmentedViewController
//
//  Created by Thomas Sherwood on 07/09/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

import Foundation
import SegmentedViewController

class SegmentedViewControllerItemDelegateMock: SegmentedViewControllerItemDelegate {
	
	var item: SegmentedViewControllerItem?
	
	init() {}
	
	func segmentItemDidChange(item: SegmentedViewControllerItem) {
		self.item = item
	}
	
}
