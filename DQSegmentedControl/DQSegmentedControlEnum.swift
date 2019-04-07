//
//  DQSegmentedControlEnum.swift
//  DQSegmentedControl
//
//  Created by Daniel on 2019/1/29.
//  Copyright © 2019 Daniel. All rights reserved.
//

import Foundation


enum DQSegmentedControlSelectionStyle {
    case textWidthStripe //指示器与文字等宽
    case fullWidthStripe //指示器与segment等宽
    case box //segment填充背景
}

enum DQSegmentedControlSelectionIndicatorLocation {
    case up
    case down
    case none
}

enum DQSegmentedControlSegmentWidthStyle {
    case fixed
    case dynamic
}

enum DQSegmentedControlType {
    case text
    case images //todo
}
