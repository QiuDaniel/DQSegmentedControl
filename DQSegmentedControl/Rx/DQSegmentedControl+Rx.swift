//
//  DQSegmentedControl+Rx.swift
//  DQSegmentedControl
//
//  Created by Daniel on 2019/8/30.
//  Copyright © 2019 Daniel. All rights reserved.
//

import RxSwift
import RxCocoa

extension DQSegmentedControl: HasDelegate {
    public typealias Delegate = DQSegmentedControlDelegate
}

class DQSegmentedControlDelegateProxy: DelegateProxy<DQSegmentedControl, DQSegmentedControlDelegate>, DelegateProxyType, DQSegmentedControlDelegate {
    
    init(control:DQSegmentedControl) {
        super.init(parentObject: control, delegateProxy: DQSegmentedControlDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        register { DQSegmentedControlDelegateProxy(control: $0) }
    }
}

extension Reactive where Base: DQSegmentedControl {
    var delegate: DQSegmentedControlDelegateProxy {
        return DQSegmentedControlDelegateProxy.proxy(for: base)
    }
    
    var didSelectedAt: ControlEvent<Int> {
        let source: Observable<Int> = delegate.methodInvoked(#selector(DQSegmentedControlDelegate.segmentControl(_:didSelectedAt:))).map { a in
            return try castOrThrow(Int.self, a[1])
        }
        
        return ControlEvent(events: source)
    }
    
}

private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}
