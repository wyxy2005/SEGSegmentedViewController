//
//  SegmentedViewControllerItemPresenterMock.swift
//  SegmentedViewController
//
//  Created by Thomas Sherwood on 08/09/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

import Foundation
import SegmentedViewController
import UIKit

class SegmentedViewControllerItemPresenterMock: SegmentedViewControllerItemPresenter {
	
	var item: SegmentedViewControllerItem?
	var index: Int?
	var animated: Bool?
	var cleared: Bool = false
	
	init() {}
	
	func presentItem(item: SegmentedViewControllerItem, atIndex index: Int, usingAnimation animated: Bool) {
		self.item = item
		self.index = index
		self.animated = animated
	}
	
	func refreshItem(item: SegmentedViewControllerItem, atIndex index: Int, usingAnimation animated: Bool) {
		self.item = item
		self.index = index
		self.animated = animated
	}
	
	func clearItems() {
		cleared = true
	}
	
}
