//
//  DQSegmentedControlDelegate.swift
//  DQSegmentedControl
//
//  Created by Daniel on 2019/1/29.
//  Copyright © 2019 Daniel. All rights reserved.
//

import Foundation

protocol DQSegmentedControlDelegate : NSObjectProtocol {
    func segmentControl(control: DQSegmentedControl, didSelectedAt index: Int)
}


extension DQSegmentedControlDelegate {
    func segmentControl(control: DQSegmentedControl, didSelectedAt index: Int) {}
}
