//
//  SegmentedViewController.swift
//  SegmentedViewController
//
//  Created by Thomas Sherwood on 07/09/2014.
//  Copyright (c) 2014 Thomas Sherwood. All rights reserved.
//

import Foundation
import UIKit

public let SegmentControlCoderKey = "SegmentedViewController.SegmentedControl"
public let SegmentedControllersCoderKey = "SegmentedViewController.SegmentedViewControllers"
public let SEGSegmentControllerItemsManagerCoderKey = "SegmentedViewController.ItemsManager"

@objc(SEGSegmentedViewControllerDelegate)
public protocol SegmentedViewControllerDelegate {
	optional func segmentController(segmentController: SegmentedViewController, didPresentController controller: UIViewController, atSegmentIndex index: Int)
}

@objc(SEGSegmentedViewController)
public class SegmentedViewController: UIViewController {
	
	// MARK: Public Properties
	
	weak public var segmentDelegate: SegmentedViewControllerDelegate?
	private(set) public var segmentControl = UISegmentedControl(frame: CGRectZero)
	private(set) public var currentControllerIndex: Int = UISegmentedControlNoSegment
	private(set) public var currentViewController: UIViewController?

	public var controllerInsets: UIEdgeInsets? {
		didSet {
			if let controller = currentViewController {
				adjustInsets(controller.view)
			}
		}
	}
	
	
	// MARK: Private Properties
	
	private var itemsManager: SegmentedViewControllerItemsManager = SegmentedViewControllerItemsManager()
	private var currentSegmentedController: SegmentedViewControllerItem?
	
	private var presenter: SegmentedViewControllerItemPresenter? {
		didSet {
			itemsManager.presenter = presenter
		}
	}
	
	
	// MARK: Initializers
	
	public override init() {
		super.init()
		
		presenter = SegmentedViewItemPresenter(parentController: self, segmentedControl: segmentControl)
		itemsManager.segmentControl = segmentControl
		itemsManager.parentController = self
		itemsManager.presenter = presenter
	}
	
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		presenter = SegmentedViewItemPresenter(parentController: self, segmentedControl: segmentControl)
		itemsManager.segmentControl = segmentControl
		itemsManager.parentController = self
		itemsManager.presenter = presenter
	}
	
	
	// MARK: NSCoding
	
	public required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		presenter = SegmentedViewItemPresenter(parentController: self, segmentedControl: segmentControl)
		
		if let control = aDecoder.decodeObjectForKey(SegmentControlCoderKey) as? UISegmentedControl {
			segmentControl = control
		}
		
		if let manager = aDecoder.decodeObjectForKey(SEGSegmentControllerItemsManagerCoderKey) as? SegmentedViewControllerItemsManager {
			itemsManager = manager
		}
		
		itemsManager.parentController = self
		itemsManager.segmentControl = segmentControl
		itemsManager.presenter = presenter
	}
	
	public override func encodeWithCoder(aCoder: NSCoder) {
		super.encodeWithCoder(aCoder)
		aCoder.encodeObject(segmentControl, forKey: SegmentControlCoderKey)
	}
	
	
	// MARK: Overrides
	
	public override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.titleView = segmentControl
		segmentControl.addTarget(self, action: "segmentControlDidChangeSegment:", forControlEvents: UIControlEvents.ValueChanged)
	}
	
	public override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if currentViewController == nil && itemsManager.hasItems {
			moveToControllerAtIndex(0)
		}
	}
	
	
	// MARK: Public
	
	public func addController(controller: UIViewController, animated: Bool) {
		itemsManager.addController(controller, animated: animated)
	}
	
	public func addController(controller: UIViewController, withTitle title: String, animated: Bool) {
		itemsManager.addController(controller, withTitle: title, animated: animated)
	}
	
	public func addController(controller: UIViewController, withIcon icon: UIImage, animated: Bool) {
		itemsManager.addController(controller, withIcon: icon, animated: animated)
	}
	
	public func setContentOfController(controller: UIViewController, toText text: String, animated: Bool) {
		itemsManager.setContentOfController(controller, toText: text, animated: animated)
	}
	
	public func setContentOfController(controller: UIViewController, toIcon icon: UIImage, animated: Bool) {
		itemsManager.setContentOfController(controller, toIcon: icon, animated: animated)
	}
	
	public func moveToControllerAtIndex(index: Int) {
		if let item = itemsManager.itemAtIndex(index) {
			moveToNewController(item, atIndex: index)
		}
		else {
			currentViewController = nil
		}
		
		segmentControl.selectedSegmentIndex = index
	}
	
	
	// MARK: Event Handlers
	
	func segmentControlDidChangeSegment(sender: UISegmentedControl) {
		moveToControllerAtIndex(sender.selectedSegmentIndex)
	}
	
	
	// MARK: Private
	
	private func moveToNewController(controller: SegmentedViewControllerItem, atIndex index: Int) {
		currentSegmentedController?.wasRemovedFromPresentationInSegmentedController(self)
		
		currentSegmentedController = controller
		let viewController = controller.viewController
		adjustInsets(viewController!.view)
		presentController(viewController!) {
			controller.wasPresentedInSegmentedController(self)
			self.segmentDelegate?.segmentController?(self, didPresentController: viewController!, atSegmentIndex: index)
		}
		
		currentViewController = controller.viewController
	}
	
	private func presentController(controller: UIViewController, completion: () -> ()) {
		if let formerController = currentViewController {
			transitionFromViewController(formerController, toViewController: controller, duration: 0, options: UIViewAnimationOptions.allZeros, animations: { }) { (_) in completion() }
		}
		else {
			view.addSubview(controller.view)
			resetInsets(controller.view)
			completion()
		}
	}
	
	private func resetInsets(view: UIView) {
		if let scrollView = view as? UIScrollView {
			scrollView.contentInset = UIEdgeInsetsZero
			scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
		}
	}
	
	private func adjustInsets(controllerView: UIView) {
		if let scrollView = controllerView as? UIScrollView {
			let insets = calculateControllerInsets()
			scrollView.contentInset = insets
			scrollView.scrollIndicatorInsets = insets
		}
	}
	
	private func calculateControllerInsets() -> UIEdgeInsets {
		var detectedInsets = navigationAndTabBarInsets
		if let providedInsets = controllerInsets {
			detectedInsets.sumWithInsets(providedInsets)
		}
		
		return detectedInsets
	}
}
