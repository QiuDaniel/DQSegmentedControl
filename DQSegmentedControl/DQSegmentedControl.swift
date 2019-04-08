//
//  DQSegmentedControl.swift
//  DQSegmentedControl
//
//  Created by Daniel on 2019/1/29.
//  Copyright © 2019 Daniel. All rights reserved.
//

import UIKit

public class DQSegmentedControl: UIControl {
    
    //MARK: - Property

    public weak var delegate: DQSegmentedControlDelegate?
    
    public var sectionTitles: Array<Any> {
        get {
            return titles
        }
        set {
            titles = newValue
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    
    public var selectedSegmentIndex: Int {
        get {
            return selectedIndex
        }
        
        set {
            selectedIndex = newValue
            setSelectedSegment(selectedIndex, animated:false)
            self.setNeedsDisplay()
        }
    }
    
    public var selectionIndicatorLocation:DQSegmentedControlSelectionIndicatorLocation = .down {
        willSet {
            self.selectionIndicatorLocation = newValue
            if newValue == .none {
                self.selectionIndicatorHeight = 0.0
            }
        }
    }
    
    /*
    指示器颜色
    */
    public var selectionIndicatorColor: UIColor = UIColor(red: 52/255.0, green: 181/255.0, blue: 229/255.0, alpha: 1.0)
    
    /*
    填充背景颜色，只在selectionStyle = .box起作用
    */
    public var selectionIndicatorBoxColor: UIColor = UIColor(red: 52/255.0, green: 181/255.0, blue: 229/255.0, alpha: 1.0)
    /*
    填充背景是否带弧度, default = true, 只在selectionStyle = .box起作用
    */
    public var isSelectionIndicatorBoxRadius = true
    /*
    指示器高度，default = 5，当selectionStyle != .box起作用
    */
    public var selectionIndicatorHeight:CGFloat = 5.0
    public var selectionStyle: DQSegmentedControlSelectionStyle = .textWidthStripe {
        willSet {
            self.selectionStyle = newValue
            if newValue == .box {
                self.selectionIndicatorLocation = .none
            }
        }
    }
    
    public var segmentWidthStyle: DQSegmentedControlSegmentWidthStyle = .fixed
    /*
     Inset left and right edges of segments.
    */
    public var segmentEdgeInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    /*
     Edge insets for the selection indicator.
     NOTE: 当selectionStyle != .box起作用
     
     selectionIndicatorLocation = .up, bottom edge insets不起作用
     
     selectionIndicatorLocation = .down, top edge insets不起作用
    */
    public var selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    /*
    默认文字设置
    */
    public var titleTextAttributes:[NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 19),
                                                              .foregroundColor: UIColor.black]
    /*
    选中文字设置
    */
    public var selectedTitleTextAttributes:[NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 19),
                                                                      .foregroundColor: UIColor.black]
    
    
    private var selectionIndicatorStripLayer = CALayer()
    private var selectionIndicatorBoxLayer = CALayer()
    private var segmentWidth: CGFloat = 0.0
    private var titles: Array<Any> = []
    private var selectedIndex = 0
    private var type: DQSegmentedControlType = .text
    private var scrollView: DQScrollView = DQScrollView()
    private var segmentWidthsArray:Array<CGFloat> = []
    private var isUserDraggable = true
    private let kBoxLeftOffSet: CGFloat = 6.0
    private let kBoxGapText: CGFloat = 2.0
    
    override public var frame: CGRect {
        didSet {
            super.frame = frame
            updateSegmentsRect()
        }
    }
    
    // MARK: - LifeCycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public init(_ sectionTitles: Array<Any>) {
        super.init(frame: .zero)
        self.sectionTitles = sectionTitles
        setup()
    }
    
    
    private func setup() {
        self.backgroundColor = UIColor.white
        scrollView.scrollsToTop = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        self.contentMode = .redraw
        self.isOpaque = false
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            return
        }
        if self.sectionTitles.count > 0 {
            updateSegmentsRect()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateSegmentsRect()
    }
    
    override public func draw(_ rect: CGRect) {
        backgroundColor?.setFill()
        UIRectFill(self.bounds)
        selectionIndicatorStripLayer.backgroundColor = selectionIndicatorColor.cgColor
        selectionIndicatorBoxLayer.backgroundColor = selectionIndicatorBoxColor.cgColor
        scrollView.layer.sublayers = nil
        let oldRect = rect
        if type == .text {
            for (index, _) in sectionTitles.enumerated() {
                var stringWidth: CGFloat = 0.0
                var stringHeight: CGFloat = 0.0
                let size = measureTitle(atIndex: index)
                stringWidth = size.width
                stringHeight = size.height
                
                var fullRect: CGRect = .zero
                
                let locationUp = selectionIndicatorLocation == .up
                let selectionStyleNotBox = selectionStyle != .box
                
                let y = round(self.frame.height - (selectionStyleNotBox ? selectionIndicatorHeight : 0)) / 2 - stringHeight / 2 + (locationUp ? selectionIndicatorHeight : 0)
                
                var tmpRect: CGRect = .zero
                var xOffset = selectionStyleNotBox ? 0 : kBoxLeftOffSet
                if segmentWidthStyle == .fixed {
                    tmpRect = CGRect(x: segmentWidth * CGFloat(index) + xOffset + (segmentWidth - stringWidth) / 2, y: y, width: stringWidth, height: stringHeight)
                    
                    fullRect = CGRect(x: segmentWidth * CGFloat(index), y: 0, width: segmentWidth, height: oldRect.size.height)
                } else {
                    
                    for(idx, width) in segmentWidthsArray.enumerated() {
                        if idx == index {
                            break
                        }
                        xOffset += width
                    }
                    let widthForIndex = segmentWidthsArray[index]
                    tmpRect = CGRect(x: xOffset, y: y, width: widthForIndex, height: stringHeight)
                    fullRect = CGRect(x: segmentWidth * CGFloat(index), y: 0, width: widthForIndex, height: oldRect.size.height)
                }
                
                tmpRect = CGRect(x: ceil(tmpRect.origin.x), y: ceil(tmpRect.origin.y), width: ceil(tmpRect.size.width), height: ceil(tmpRect.size.height))
                
                let titleLayer = CATextLayer()
                titleLayer.frame = tmpRect
                titleLayer.alignmentMode = .center
                if #available(iOS 10.0, *) {
                    
                } else {
                    titleLayer.truncationMode = .end
                }
                titleLayer.string = attributedTitle(atIndex: index)
                titleLayer.contentsScale = UIScreen.main.scale
                scrollView.layer.addSublayer(titleLayer)
                addBackgroundAndBorderLayer(withRect: fullRect)
            }
        }
        
        if selectedSegmentIndex >= 0 {
            if selectionIndicatorStripLayer.superlayer == nil {
                selectionIndicatorStripLayer.frame = frameForSelectionIndicator()
                scrollView.layer.addSublayer(selectionIndicatorStripLayer)
                if selectionStyle == .box && selectionIndicatorBoxLayer.superlayer == nil {
                    selectionIndicatorBoxLayer.frame = frameForFillerSelectionIndicator()
                    scrollView.layer.insertSublayer(selectionIndicatorBoxLayer, at: 0)
                }
            }
        }
        
    }
    
    // MARK: - Touch
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = (touches as NSSet).anyObject() as AnyObject
        let touchLocation = touch.location(in: self)
        
        let enlargeRect = self.bounds
        
        if enlargeRect.contains(touchLocation) {
            var segment = 0
            if segmentWidthStyle == .fixed {
                segment = Int((touchLocation.x + scrollView.contentOffset.x) / segmentWidth)
            } else {
                var widthLeft = touchLocation.x + scrollView.contentOffset.x
                for width in segmentWidthsArray {
                    widthLeft -= width
                    
                    if widthLeft <= 0 {
                        break
                    }
                    segment += 1
                }
            }
            
            var sectionsCount = 0
            if type == .text {
                sectionsCount = sectionTitles.count
            }
            
            if segment != selectedSegmentIndex && segment < sectionsCount {
                setSelectedSegment(segment, animated: true, notify: true)
            }
        }
        
        
        
    }
    
    // MARK: - Private
    
    private func updateSegmentsRect() {
        scrollView.contentInset = .zero;
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let count = sectionCount()
        if count > 0 {
            segmentWidth = self.frame.width / CGFloat(count)
        }
        
        if type == .text && segmentWidthStyle == .fixed {
            for (index, _) in sectionTitles.enumerated() {
                let stringWidth = measureTitle(atIndex: index).width + segmentEdgeInset.left + segmentEdgeInset.right
                segmentWidth = max(stringWidth, segmentWidth)
            }
        } else if type == .text && segmentWidthStyle == .dynamic {
            var mutableSegmentWithds = Array<CGFloat>()
            for (index, _) in sectionTitles.enumerated() {
                let stringWidth = measureTitle(atIndex: index).width + segmentEdgeInset.left + segmentEdgeInset.right
                mutableSegmentWithds.append(stringWidth)
            }
            segmentWidthsArray = mutableSegmentWithds
        }
        scrollView.isScrollEnabled = isUserDraggable
        scrollView.contentSize = CGSize(width: totalSegmentedControlWidth() + (selectionStyle == .box ? kBoxLeftOffSet * 2 : 0.0), height: self.frame.size.height)
    }
    
    
    private func sectionCount() -> Int {
        if self.type == .text {
            return self.sectionTitles.count
        }
        return 0
    }
    
    private func measureTitle(atIndex index:Int) -> CGSize {
        if index >= self.sectionTitles.count {
            return .zero
        }
        var size:CGSize = .zero
        let title = self.sectionTitles[index]
        let selected =  index == selectedSegmentIndex
        
        if title is NSString {
            let titleStr = title as! NSString
            let titleAttrs = selected ? selectedTitleTextAttributes : titleTextAttributes
            size = titleStr.size(withAttributes: titleAttrs)
            
        } else if title is NSAttributedString {
            let titleAttriStr = title as! NSAttributedString
            size = titleAttriStr.size()
        } else if title is String {
            let titleStr = title as! NSString
            let titleAttrs = selected ? selectedTitleTextAttributes : titleTextAttributes
            size = titleStr.size(withAttributes: titleAttrs)
        } else {
            assertionFailure("Unexpected type of segment title")
        }
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return frame.integral.size
    }
    
    private func totalSegmentedControlWidth() -> CGFloat {
        if type == .text && segmentWidthStyle == .fixed {
            return CGFloat(sectionTitles.count) * segmentWidth;
        } else if segmentWidthStyle == .dynamic {
            return segmentWidthsArray.reduce(0, +)
        } else {
            return 0.0
        }
    }
    
    private func attributedTitle(atIndex index:Int) -> NSAttributedString {
        let title = sectionTitles[index]
        let selected = index == selectedSegmentIndex
        if title is NSAttributedString {
            return title as! NSAttributedString
        } else {
            let titleAttrs = selected ? selectedTitleTextAttributes : titleTextAttributes
            return NSAttributedString(string: title as! String, attributes: titleAttrs)
        }
    }
    
    
    private func addBackgroundAndBorderLayer(withRect rect: CGRect) {
        let backgroundLayer = CALayer()
        backgroundLayer.frame = rect
        self.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    private func frameForSelectionIndicator() -> CGRect {
        var indicatorYOffset: CGFloat = 0.0
        if selectionIndicatorLocation == .down {
            indicatorYOffset = self.bounds.size.height - selectionIndicatorHeight + selectionIndicatorEdgeInsets.bottom
        }
        if selectionIndicatorLocation == .up {
            indicatorYOffset = selectionIndicatorEdgeInsets.top
        }
        
        var sectionWidth: CGFloat = 0.0
        if type == .text {
            sectionWidth = measureTitle(atIndex: selectedSegmentIndex).width
        }
        
        if selectionStyle == .textWidthStripe && sectionWidth <= segmentWidth && segmentWidthStyle != .dynamic {
            let widthToEndOfSelectedSegment = segmentWidth * CGFloat(selectedSegmentIndex) + segmentWidth
            let widthToStartOfSelectedIndex = segmentWidth * CGFloat(selectedSegmentIndex)
            
            let x = (widthToEndOfSelectedSegment - widthToStartOfSelectedIndex) / 2 + (widthToStartOfSelectedIndex - sectionWidth / 2)
            return CGRect(x: x + selectionIndicatorEdgeInsets.left, y: indicatorYOffset, width: sectionWidth - selectionIndicatorEdgeInsets.right, height: selectionIndicatorHeight)
        } else {
            if segmentWidthStyle == .dynamic {
                if segmentWidthsArray.count - 1 < selectedSegmentIndex {
                    return .zero
                }
                
                var selectedSegmentOffset: CGFloat = 0.0
                
                for(index, width) in segmentWidthsArray.enumerated() {
                    if index == selectedSegmentIndex {
                        break
                    }
                    selectedSegmentOffset += width
                }
                
                return CGRect(x: selectedSegmentOffset + selectionIndicatorEdgeInsets.left, y: indicatorYOffset, width: segmentWidthsArray[selectedSegmentIndex] - selectionIndicatorEdgeInsets.right, height: selectionIndicatorHeight + selectionIndicatorEdgeInsets.bottom
                )
            }
            
            return CGRect(x: (segmentWidth + selectionIndicatorEdgeInsets.left) * CGFloat(selectedSegmentIndex), y: indicatorYOffset, width: segmentWidth - selectionIndicatorEdgeInsets.right, height: selectionIndicatorHeight)
        }
    }
    
    private func frameForFillerSelectionIndicator() -> CGRect {
        
        let stringHeight = measureTitle(atIndex: selectedSegmentIndex).height
        let boxHeight = min(self.frame.height, stringHeight + kBoxGapText * 2);
        if isSelectionIndicatorBoxRadius {
            self.selectionIndicatorBoxLayer.cornerRadius = boxHeight / 2
        }
        let y = round((self.frame.height - boxHeight) / 2)
        
        if segmentWidthStyle == .dynamic {
            var selectedSegmentOffset = kBoxLeftOffSet
            for (index, width) in segmentWidthsArray.enumerated() {
                if index == selectedSegmentIndex {
                    break
                }
                selectedSegmentOffset += width
            }
            
            return CGRect(x: selectedSegmentOffset, y: y, width: segmentWidthsArray[selectedSegmentIndex], height: boxHeight)
        }
        
        let stringWidth = measureTitle(atIndex: selectedSegmentIndex).width
        if let layers = scrollView.layer.sublayers {
            let layer = layers[selectedSegmentIndex]
            if layer.isKind(of: CATextLayer.self) {
                return CGRect(x: layer.frame.origin.x - kBoxLeftOffSet, y: y, width: stringWidth + kBoxLeftOffSet * 2, height: boxHeight)
            }
        }
        
        return CGRect(x: segmentWidth * CGFloat(selectedSegmentIndex), y: y, width: stringWidth + kBoxLeftOffSet * 2, height: boxHeight)
    }
    
    // MARK: - Index Chage
    
    public func setSelectedSegment(_ index: Int, animated: Bool, notify: Bool? = false) {
        selectedIndex = index
        if index < 0 {
            selectionIndicatorStripLayer.removeFromSuperlayer()
            selectionIndicatorBoxLayer.removeFromSuperlayer()
        } else {
            scrollToSelectedSegmentIndex(animated)
            if animated {
                if selectionIndicatorStripLayer.superlayer == nil {
                    scrollView.layer.addSublayer(selectionIndicatorStripLayer)
                    if selectionStyle == .box && selectionIndicatorBoxLayer.superlayer == nil {
                        scrollView.layer.insertSublayer(selectionIndicatorBoxLayer, at: 0)
                    }
                    setSelectedSegment(index, animated: false, notify: true)
                    return
                }
                
                if let notify = notify {
                    if notify {
                        notifyForSegment(toIndex: index)
                    }
                }
                
                selectionIndicatorStripLayer.actions = nil
                selectionIndicatorBoxLayer.actions = nil
                
                CATransaction.begin()
                CATransaction.setAnimationDuration(0.15)
                CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .linear))
                selectionIndicatorStripLayer.frame = frameForSelectionIndicator()
                selectionIndicatorBoxLayer.frame = frameForFillerSelectionIndicator()
                CATransaction.commit()
                
            } else {
                let newAction = ["position": NSNull(), "bounds": NSNull()]
                selectionIndicatorStripLayer.actions = newAction
                selectionIndicatorStripLayer.frame = frameForSelectionIndicator()
                
                selectionIndicatorBoxLayer.actions = newAction
                selectionIndicatorBoxLayer.frame = frameForFillerSelectionIndicator()
                if let notify = notify {
                    if notify {
                        notifyForSegment(toIndex: index)
                    }
                }
            }
        }
    }
    
    // MARK: - Scroll
    
    private func scrollToSelectedSegmentIndex(_ animated: Bool) {
        var rectForSelectedIndex: CGRect = .zero
        var selectedSegmentOffset: CGFloat = 0
        
        if segmentWidthStyle == .fixed {
            rectForSelectedIndex = CGRect(x: segmentWidth * CGFloat(selectedSegmentIndex), y: 0, width: segmentWidth, height: self.frame.size.height)
            selectedSegmentOffset = self.frame.width / 2 - (segmentWidth / 2)
        } else {
            var offsetter: CGFloat = 0
            for (idx, width) in segmentWidthsArray.enumerated() {
                if idx == selectedSegmentIndex {
                    break
                }
                offsetter += width
            }
            
            rectForSelectedIndex = CGRect(x: offsetter, y: 0, width: segmentWidthsArray[selectedSegmentIndex], height: self.frame.size.height)
            
            selectedSegmentOffset = self.frame.width / 2 - segmentWidthsArray[selectedSegmentIndex] / 2
        }
        
        var rectToScrollTo = rectForSelectedIndex
        rectToScrollTo.origin.x -= selectedSegmentOffset
        rectToScrollTo.size.width += selectedSegmentOffset * 2
        scrollView.scrollRectToVisible(rectToScrollTo, animated: animated)
    }
    
    private func notifyForSegment(toIndex index: Int) {
        if self.superview != nil {
            self.sendActions(for:.valueChanged)
        }
        self.delegate?.segmentControl(control: self, didSelectedAt: index)
    }
}
