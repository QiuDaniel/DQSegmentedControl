//
//  DQSegmentedControlDelegate.swift
//  DQSegmentedControl
//
//  Created by Daniel on 2019/1/29.
//  Copyright © 2019 Daniel. All rights reserved.
//

import Foundation

@objc
public protocol DQSegmentedControlDelegate : NSObjectProtocol {
    @objc
    optional func segmentControl(_ control: DQSegmentedControl, didSelectedAt index: Int)
}

