//
//  ViewController.swift
//  Example
//
//  Created by Daniel on 2019/4/7.
//  Copyright © 2019 Daniel. All rights reserved.
//

import UIKit
import DQSegmentedControl
import RxSwift

private let titles1 = ["大前天","前天", "昨天", "今天", "明天", "后天", "大后天"]
private let titles2 = ["星期一","星期二", "星期三", "星期四", "星期五", "星期六", "星期天"]

class ViewController: UIViewController {
    private lazy var showLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        label.font = UIFont.boldSystemFont(ofSize: 80)
        label.textColor = UIColor.blue
        label.textAlignment = .center
        return label
    }()
    private lazy var segmentControl1: DQSegmentedControl = {
        let control = DQSegmentedControl(titles1)
        control.frame = CGRect(x: 0, y: 34, width: UIScreen.main.bounds.width, height: 60)
        control.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16),.foregroundColor:UIColor.black]
        control.selectedTitleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 16),.foregroundColor:UIColor.red]
        control.selectionIndicatorHeight = 2
        control.selectionIndicatorColor = UIColor.red
        control.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0);
        control.selectedSegmentIndex = 2
        return control
    }()
    
    private lazy var segmentControl2: DQSegmentedControl = {
        let control = DQSegmentedControl(frame: CGRect(x: self.segmentControl1.frame.origin.x, y: self.segmentControl1.frame.origin.y + self.segmentControl1.frame.height, width: UIScreen.main.bounds.width, height: 60))
        control.sectionTitles = titles2
        control.delegate = self
        control.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 16),.foregroundColor:UIColor.black]
        control.selectedTitleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 16),.foregroundColor:UIColor.red]
        control.selectionIndicatorColor = UIColor.blue
        control.selectionStyle = .box
        control.isSelectionIndicatorBoxRadius = true
        return control
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.segmentControl1)
        view.addSubview(self.segmentControl2)
        view.addSubview(self.showLabel)
        self.showLabel.center = view.center
        segmentControl1.rx.didSelectedAt.subscribe(onNext: { [weak self] index in
            guard let `self` = self else { return }
            print("selectedAt======>\(index)")
            self.showLabel.text = titles1[index]
        }).disposed(by: disposeBag)
    }
    
}

extension ViewController: DQSegmentedControlDelegate {
    func segmentControl(_ control: DQSegmentedControl, didSelectedAt index: Int) {
        print("selectedAt======>\(index)")
        showLabel.text = titles2[index]
    }
}



