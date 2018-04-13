//
//  MDPageMenu.swift
//  MDPageMenu
//
//  Created by Alan on 2018/3/29.
//  Copyright © 2018年 MD. All rights reserved.
//

import UIKit

typealias hideBlock = ()->Void


let tagBaseValue = 200

public enum MDPageMenuPermutationWay{
    case adaptContent // 自适应内容,可以左右滑动
    case notScrollEqualWidths  // 等宽排列,不可以滑动,整个内容被控制在pageMenu的范围之内,等宽是根据pageMenu的总宽度对每个item均分
    case notScrollAdaptContent // 自适应内容,不可以滑动,整个内容被控制在pageMenu的范围之内,这种排列方式下,自动计算item之间的间距,itemPadding属性设置无效
}


public enum MDItemImagePosition {
    case isDefault
    case left // 默认图片在左边
    case top // 图片在上面
    case right  // 图片在右边
    case bottom  // 图片在下面
}


public  class MDPageMenuLine:UIImageView{
    var hideBlock:hideBlock?
    
    func hidePageMenuLine(){
        self.isHidden = true
        if self.hideBlock != nil{
            self.hideBlock!()
        }
    }
    
    func setPageMenuLineAlpha(alpha:CGFloat){
        self.alpha = alpha
        if self.hideBlock != nil{
            self.hideBlock!()
        }
    }
    
}

class MDItem: UIButton {
    
    
    
    var imageRatio:CGFloat = 0.5

    var imagePosition:MDItemImagePosition = .left
    
    func setImageRatio(imageRatio:CGFloat){
        self.imageRatio = imageRatio
        setNeedsDisplay()
    }
    
    func setImagePosition(imagePosition:MDItemImagePosition){
        self.imagePosition = imagePosition
        switch imagePosition {
            case .isDefault:
                break
            case .left:
                self.imageView?.contentMode = .scaleAspectFit
                self.titleLabel?.textAlignment = .center
            case .top:
                self.imageView?.contentMode = .scaleAspectFit
                self.titleLabel?.textAlignment = .center
            case .right:
                self.imageView?.contentMode = .scaleAspectFit
                self.titleLabel?.textAlignment = .center
            case .bottom:
                self.imageView?.contentMode = .scaleAspectFit
                self.titleLabel?.textAlignment = .center
        }
        setNeedsDisplay()
    }
    
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initialize(){
        setImageRatio(imageRatio: 0.5)
        setImagePosition(imagePosition: .isDefault)
    }
    
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        if self.currentTitle == nil{
            return super.imageRect(forContentRect: contentRect)
        }
        switch self.imagePosition {
            case .isDefault:
                break
            case .left:
                imageRatio = imageRatio == 0.0 ? 0.5 : imageRatio
                let imageW = contentRect.size.width * imageRatio
                let imageH = contentRect.size.height
                return CGRect(x: 0, y: 0, width: imageW, height: imageH)
            case .top:
                imageRatio = imageRatio == 0.0 ? 2.0/3.0 : imageRatio
                let imageW = contentRect.size.width
                let imageH = contentRect.size.height * imageRatio
                return CGRect(x: 0, y: 0, width: imageW, height: imageH)
            case .right:
                imageRatio = imageRatio == 0.0 ? 0.5 : imageRatio
                let imageW = contentRect.size.width * imageRatio
                let imageH = contentRect.size.height
                let imageX = contentRect.size.width - imageW
                return CGRect(x: imageX, y: 0, width: imageW, height: imageH)
            case .bottom:
                imageRatio = imageRatio == 0.0 ? 2.0/3.0 : imageRatio
                let imageW = contentRect.size.width
                let imageH = contentRect.size.height * imageRatio
                let imageY = contentRect.size.height - imageH
                return CGRect(x: 0, y: imageY, width: imageW, height: imageH)
        }
        return CGRect.zero
    }
    
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        if self.currentImage == nil{
            return super.titleRect(forContentRect: contentRect)
        }else{
            switch self.imagePosition {
                case .isDefault:
                    break
                case .left:
                    imageRatio = imageRatio == 0.0 ? 0.5 : imageRatio
                    let titleX = contentRect.size.width * imageRatio
                    let titleW = contentRect.size.width - titleX
                    let titleH = contentRect.size.height
                    return CGRect(x: titleX, y: 0, width: titleW, height: titleH)
                case .top:
                    imageRatio = imageRatio == 0.0 ? 2.0/3.0 : imageRatio
                    let titleY = contentRect.size.height * imageRatio
                    let titleW = contentRect.size.width
                    let titleH = contentRect.size.height - titleY
                    return CGRect(x: 0, y: titleY, width: titleW, height: titleH)
                case .right:
                    imageRatio = imageRatio == 0.0 ? 0.5 : imageRatio
                    let titleW = contentRect.size.width * (1-imageRatio)
                    let titleH = contentRect.size.height
                    return CGRect(x: 0, y: 0, width: titleW, height: titleH)
                case .bottom:
                    imageRatio = imageRatio == 0.0 ? 2.0/3.0 : imageRatio
                    let titleW = contentRect.size.width
                    let titleH = contentRect.size.height * (1 - imageRatio)
                    return CGRect(x: 0, y: 0, width: titleW, height: titleH)
            }
        }
        return CGRect.zero
    }
    
}



@objc public protocol MDPageMenuDelegate:NSObjectProtocol {
    @objc optional func functionButtonClicked(pageMenu:MDPageMenu,functionButton:UIButton)
    @objc optional func itemSelectedAtIndex(index:Int)
    @objc optional func itemSelectedFromIndexToIndex(fromIndex:Int,toIndex:Int)
}



public class MDPageMenu: UIView {
    
    public var selectedItemIndex:Int = 0

    public var selectedItemTitleColor:UIColor = .black
    
    public var unSelectedItemTitleColor:UIColor = .gray
    
    public var maxTextScale:CGFloat = 0.2 //缩放比例
    
    public var isTextZoom:Bool = true
    
    public var itemTitleFont:UIFont = UIFont.systemFont(ofSize: 16)
    
    public var backgroundView:UIView!
    
    public var dividingLine:MDPageMenuLine! //分割线
    
    public var itemPadding:CGFloat = 30
    
    public var permutationWay:MDPageMenuPermutationWay = .adaptContent
    
    public weak var delegate:MDPageMenuDelegate?
    
    public lazy var tracker:UIImageView! = {
        let tracker = UIImageView()
        tracker.layer.cornerRadius = trackerHeight * 0.5
        tracker.layer.masksToBounds = true
        return tracker
    }()
    
    public var trackerHeight:CGFloat = 3
    
    private var bridgeScrollView:UIScrollView?
    
    private var contentInset:UIEdgeInsets = UIEdgeInsets.zero
    
    
    private lazy var items:NSArray? = {
        let items = NSArray()
        return items
    }()
    
    private var itemScrollView:UIScrollView?
    
    private var buttons:NSMutableArray = {
        let buttons = NSMutableArray.init(capacity: 0)
        return buttons
    }()
    
    private var selectedButton:MDItem!
    
    private lazy var setupWidths:NSMutableDictionary! = {
        let setupWidths = NSMutableDictionary()
        return setupWidths
    }()
    private var beginOffsetX:CGFloat  = 0
    
    
    
    deinit {
        bridgeScrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override public init(frame:CGRect){
        super.init(frame: frame)
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize(){

        // 必须先添加分割线，再添加backgroundView;假如先添加backgroundView,那也就意味着backgroundView是MDPageMenu的第一个子控件,而scrollView又是backgroundView的第一个子控件,当外界在由导航控制器管理的控制器中将MDPageMenu添加为第一个子控件时，控制器会不断的往下遍历第一个子控件的第一个子控件，直到找到为scrollView为止,一旦发现某子控件的第一个子控件为scrollView,会将scrollView的内容往下偏移64;这时控制器中必须设置self.automaticallyAdjustsScrollViewInsets = NO;为了避免这样做，这里将分割线作为第一个子控件
        
        dividingLine = MDPageMenuLine()
        dividingLine?.backgroundColor = .gray
        dividingLine?.hideBlock = { () in
            self.setNeedsLayout()
        }
        self.addSubview(dividingLine!)
        
        backgroundView = UIView()
        backgroundView?.layer.masksToBounds = true
        self.addSubview(backgroundView!)
        
        itemScrollView = UIScrollView()
        itemScrollView?.showsHorizontalScrollIndicator = false
        itemScrollView?.showsVerticalScrollIndicator = false
        backgroundView?.addSubview(itemScrollView!)
        
        self.layoutIfNeeded()
        
    }
    
    public func setBridgeScrollView(bridgeScrollView:UIScrollView){
        self.bridgeScrollView = bridgeScrollView
        self.bridgeScrollView?.addObserver(self, forKeyPath:"contentOffset", options: .new, context: nil)
    }

    
    
    public func setItems(items:NSArray,selectedItemIndex:Int){
        if items.count < 1{return}
        self.items = items
        self.selectedItemIndex = selectedItemIndex
        for i in 0...(items.count - 1) {
            let object:AnyObject = items[i] as AnyObject
            var isItemType:Bool = false
            if let title = object as? String{
                isItemType = true
                self.addButton(index: i, object: title as AnyObject, animated: false)
            }
            if let image = object as? UIImage{
                isItemType = true
               self.addButton(index: i, object: image, animated: false)
            }
            if !isItemType{
                print("items中的元素只能是String或UIImage类型")
                return
            }
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()

        // 默认选中selectedItemIndex对应的按钮
        let defaultSelectedButton = self.buttons.object(at: selectedItemIndex) as! MDItem
        self.buttonInPageMenuClicked(sender: defaultSelectedButton)

        if isTextZoom{
          defaultSelectedButton.setTitleColor(selectedItemTitleColor, for: .normal)
            defaultSelectedButton.transform = CGAffineTransform(scaleX: 1+maxTextScale, y: 1+maxTextScale)
        }
        self.itemScrollView?.insertSubview(self.tracker!, at: 0)

        // 如果缩放的话，此刻不能去布局，如果这时去布局，第一次缩放的按钮文字会显示不全
        if !isTextZoom{
            self.setNeedsLayout()
        }
    }
    
    private func addButton(index:Int,object:AnyObject,animated:Bool){
        let button = MDItem(type: .custom)
        button.setTitleColor(unSelectedItemTitleColor, for: .normal)
        button.titleLabel?.font = itemTitleFont
        button.addTarget(self, action: #selector(buttonInPageMenuClicked(sender:)), for: .touchUpInside)
        button.tag = tagBaseValue + index
        if  let title = object as?String{
            button.setTitle(title, for: .normal)
        }else{
            button.setImage(object as? UIImage, for: .normal)
        }
        self.itemScrollView?.insertSubview(button, at: index)
        
        self.buttons.insert(button, at: index)
        
    }
    
    @objc private func buttonInPageMenuClicked(sender:MDItem){
        self.selectedButton?.setTitleColor(unSelectedItemTitleColor, for: .normal)
        sender.setTitleColor(selectedItemTitleColor, for: .normal)
        
        let fromIndex = (self.selectedButton != nil) ? (self.selectedButton?.tag)! - tagBaseValue : sender.tag - tagBaseValue
        let toIndex = sender.tag - tagBaseValue
        // 更新下item对应的下标,必须在代理之前，否则外界在代理方法中拿到的不是最新的,必须用下划线，用self.会造成死循环
        self.selectedItemIndex = toIndex
        
        self.delegatePerformMethodWithFromIndex(fromIndex: fromIndex, toIndex: toIndex)
        self.moveItemScrollViewWithSelectedButton(selectedButton: sender)
        
        if isTextZoom{
            self.selectedButton?.transform = CGAffineTransform.identity
            sender.transform = CGAffineTransform(scaleX: 1+maxTextScale, y: 1+maxTextScale)
            
        }
        //如果是第一次进来不需要动画
        if self.selectedButton == nil{
            self.moveTrackerWithSelectedButton(selectedButton: sender,animate: false)
        }else{
            if fromIndex != toIndex{
                 self.moveTrackerWithSelectedButton(selectedButton: sender,animate: true)
            }
        }
        self.selectedButton = sender
    }
    
    // 点击button让itemScrollView发生偏移
    func moveItemScrollViewWithSelectedButton(selectedButton:MDItem){
        if (self.backgroundView?.frame.equalTo(CGRect.zero))!{
            return
        }
        // 转换点的坐标位置
        
        let centerInPageMenu  = self.backgroundView?.convert(selectedButton.center, to: self)
        
        // CGRectGetMidX(self.backgroundView.frame)指的是屏幕水平中心位置，它的值是固定不变的
        var offSetX = (centerInPageMenu?.x)! - (self.backgroundView?.frame.midX)!
        
        // itemScrollView的容量宽与自身宽之差(难点)
        let maxOffsetX = (self.itemScrollView?.contentSize.width)! - (self.itemScrollView?.frame.size.width)!
        
        // 如果选中的button中心x值小于或者等于itemScrollView的中心x值，或者itemScrollView的容量宽度小于itemScrollView本身，此时点击button时不发生任何偏移，置offSetX为0
        
        if offSetX <= 0 || maxOffsetX <= 0{
            offSetX = 0
        }
            
            // 如果offSetX大于maxOffsetX,说明itemScrollView已经滑到尽头，此时button也发生任何偏移了
        else if offSetX > maxOffsetX{
            offSetX = maxOffsetX;
        }
        
        self.itemScrollView?.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
        
        
    }
    
    // 移动跟踪器
    func moveTrackerWithSelectedButton(selectedButton:UIButton, animate:Bool) {
        if animate {
            UIView.animate(withDuration: 0.25) {
                self.resetSetupTrackerFrameWithSelectedButton(selectedButton: selectedButton)
            }
        }else{
            self.resetSetupTrackerFrameWithSelectedButton(selectedButton: selectedButton)
        }
    }
    
    func resetSetupTrackerFrameWithSelectedButton(selectedButton:UIButton){
        var trackerX:CGFloat = 0
        var trackerY:CGFloat = 0
        var trackerW:CGFloat = 0
        var trackerH:CGFloat = 0
        
        let selectedButtonWidth = selectedButton.frame.size.width
        
        trackerW = selectedButtonWidth != 0 ? selectedButton.titleLabel!.font.pointSize : 0; // 固定宽度为字体大小
        trackerH = trackerHeight;
        trackerX = selectedButton.frame.origin.x;
        trackerY = (self.itemScrollView?.bounds.size.height)! - trackerH;
        self.tracker?.frame = CGRect(x: trackerX, y: trackerY, width: trackerW, height: trackerH)
        
        var trackerCenter = self.tracker?.center;
        trackerCenter?.x = selectedButton.center.x;
        self.tracker?.center = trackerCenter!;
    }
    
    
    
    
    
    // 执行代理方法
    func delegatePerformMethodWithFromIndex(fromIndex:Int,toIndex:Int){
        if delegate != nil && (delegate?.responds(to: #selector(delegate?.itemSelectedFromIndexToIndex(fromIndex:toIndex:))))!{
            delegate?.itemSelectedFromIndexToIndex!(fromIndex: fromIndex, toIndex: toIndex)
        }else if delegate != nil && (delegate?.responds(to: #selector(delegate?.itemSelectedAtIndex(index:))))!{
            self.delegate?.itemSelectedAtIndex!(index: toIndex)
        }
    }
    
    func beginMoveTrackerFollowScrollView(scrollView:UIScrollView){
        // 这个if条件的意思就是没有滑动的意思
        if !scrollView.isDragging && !scrollView.isDecelerating{return}
        
        if scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.bounds.size.width{
            return
        }
        
        var i = 0
        
        if i == 0{
            // 记录起始偏移量，注意千万不能每次都记录，只需要第一次纪录即可。
            // 初始值不能等于scrollView.contentOffset.x,因为第一次进入此方法时，scrollView.contentOffset.x已经有偏移并非刚开始的偏移
            beginOffsetX = scrollView.bounds.size.width * CGFloat(self.selectedItemIndex)
            i = 1
        }
        
        // 当前偏移量
        let currentOffSetX = scrollView.contentOffset.x
        // 偏移进度
        let offsetProgress = currentOffSetX / scrollView.bounds.size.width
        
        var progress = offsetProgress - floor(offsetProgress)
        
        var fromIndex = 0
        var toIndex = 0
        
        // 以下注释的“拖拽”一词很准确，不可说成滑动，例如:当手指向右拖拽，还未拖到一半时就松开手，接下来scrollView则会往回滑动，这个往回，就是向左滑动，这也是_beginOffsetX不可时刻纪录的原因，如果时刻纪录，那么往回(向左)滑动时会被视为“向左拖拽”,然而，这个往回却是由“向右拖拽”而导致的
        if (currentOffSetX - beginOffsetX) > 0{
            // 求商,获取上一个item的下标
            fromIndex = Int(currentOffSetX / scrollView.bounds.size.width);
            // 当前item的下标等于上一个item的下标加1
            toIndex = fromIndex + 1;
            if (toIndex >= self.buttons.count) {
                toIndex = fromIndex;
            }
        }else if (currentOffSetX - beginOffsetX < 0) {  // 向右拖拽了
            toIndex = Int(currentOffSetX / scrollView.bounds.size.width)
            fromIndex = toIndex + 1;
            progress = 1.0 - progress;
            
        } else {
            progress = 1.0;
            fromIndex = self.selectedItemIndex;
            toIndex = fromIndex;
        }
        if (currentOffSetX == scrollView.bounds.size.width * CGFloat(fromIndex)) {// 滚动停止了
            progress = 1.0;
            toIndex = fromIndex;
        }
        
        // 如果滚动停止，直接通过点击按钮选中toIndex对应的item
        if (currentOffSetX == scrollView.bounds.size.width*CGFloat(toIndex)) { // 这里toIndex==fromIndex
            i = 0;
            // 这一次赋值起到2个作用，一是点击toIndex对应的按钮，走一遍代理方法,二是弥补跟踪器的结束跟踪，因为本方法是在scrollViewDidScroll中调用，可能离滚动结束还有一丁点的距离，本方法就不调了,最终导致外界还要在scrollView滚动结束的方法里self.selectedItemIndex进行赋值,直接在这里赋值可以让外界不用做此操作
            self.selectedItemIndex = toIndex;
            self.buttonInPageMenuClicked(sender: self.buttons.object(at:  self.selectedItemIndex) as! MDItem)
            // 要return，点击了按钮，跟踪器自然会跟着被点击的按钮走
            return;
        }
       
        self.moveTrackerWithProgress(progress: progress, fromIndex: fromIndex, toIndex: toIndex, currentOffsetX: currentOffSetX, beginOffsetX: beginOffsetX)
    

    }
    
    func moveTrackerWithProgress(progress:CGFloat,fromIndex:Int,toIndex:Int,currentOffsetX:CGFloat,beginOffsetX:CGFloat){
        let fromButton:UIButton = self.buttons[fromIndex] as! UIButton
        let toButton:UIButton = self.buttons[toIndex] as! UIButton
        
        let xDistance = toButton.center.x - fromButton.center.x
        
        var newFrame = self.tracker?.frame
        
        // 这种样式的计算比较复杂,有个很关键的技巧，就是参考progress分别为0、0.5、1时的临界值
        // 原先的x值
        let  originX = fromButton.frame.origin.x+(fromButton.frame.size.width-(fromButton.titleLabel?.font.pointSize)!)*0.5;
        // 原先的宽度
        let originW = fromButton.titleLabel?.font.pointSize;
        if (currentOffsetX - beginOffsetX >= 0) { // 向左拖拽了
            if (progress < 0.5) {
                newFrame?.origin.x = originX; // x值保持不变
                newFrame?.size.width = originW! + xDistance * progress * 2;
            } else {
                newFrame?.origin.x = originX + xDistance * (progress-0.5) * 2;
                newFrame?.size.width = originW! + xDistance - xDistance * (progress-0.5) * 2;
            }
        } else { // 向右拖拽了
            // 此时xDistance为负
            if (progress < 0.5) {
                newFrame?.origin.x = originX + xDistance * progress * 2;
                newFrame?.size.width = originW! - xDistance * progress * 2;
            } else {
                newFrame?.origin.x = originX + xDistance;
                newFrame?.size.width = originW! - xDistance + xDistance * (progress-0.5) * 2;
            }
        }
        
        self.tracker?.frame = newFrame!;
    
        if isTextZoom{
            self.zoomForTitleWithProgress(progress: progress, fromButton: fromButton, toButton: toButton)
        }
        
    }
    
    
    func zoomForTitleWithProgress(progress:CGFloat,fromButton:UIButton,toButton:UIButton){
        fromButton.transform = CGAffineTransform(scaleX: (1-progress)*maxTextScale + 1, y: (1-progress)*maxTextScale + 1)
        toButton.transform = CGAffineTransform(scaleX:progress*maxTextScale + 1, y: progress*maxTextScale + 1)
    }
    
    // KVO
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let view = object as?UIScrollView{
            if view == self.bridgeScrollView{
                if keyPath == "contentOffset"{
                    self.beginMoveTrackerFollowScrollView(scrollView: self.bridgeScrollView!)
                }else{
                    super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
                }
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        
    }
    
    
    //布局
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let backgroundViewX = self.bounds.origin.x+contentInset.left;
        let backgroundViewY = self.bounds.origin.y+(contentInset.top);
        let backgroundViewW = self.bounds.size.width-(contentInset.left+contentInset.right);
        let backgroundViewH = self.bounds.size.height-(contentInset.top+contentInset.bottom);
        self.backgroundView?.frame = CGRect(x: backgroundViewX, y: backgroundViewY, width: backgroundViewW, height: backgroundViewH)
        
        let dividingLineW = self.bounds.size.width;
        let dividingLineH:CGFloat = ((self.dividingLine?.isHidden)! || (self.dividingLine?.alpha)! < 0.01) ? 0 : 0.5;
        let dividingLineX:CGFloat = 0;
        let dividingLineY = self.bounds.size.height-dividingLineH;
        self.dividingLine?.frame = CGRect(x: dividingLineX, y: dividingLineY, width: dividingLineW, height: dividingLineH)
        
        
        let itemScrollViewX:CGFloat = 0;
        let itemScrollViewY:CGFloat = 0;
        let itemScrollViewW = backgroundViewW;
        let itemScrollViewH = backgroundViewH-dividingLineH;
        self.itemScrollView?.frame = CGRect(x: itemScrollViewX, y: itemScrollViewY, width: itemScrollViewW, height: itemScrollViewH)
        
        var buttonW:CGFloat = 0.0;
        var lastButtonMaxX:CGFloat = 0.0;
        
        var contentW:CGFloat = 0.0; // 文字宽
        var contentW_sum:CGFloat = 0.0; // 所有文字宽度之和
        let buttonWidths = NSMutableArray();
        // 提前计算每个按钮的宽度，目的是为了计算间距
        if self.buttons.count == 0{
            return
        }
        for i in 0...self.buttons.count - 1 {
            let button:MDItem = self.buttons[i] as! MDItem;
            
            let setupButtonW:CGFloat? = self.setupWidths?.object(forKey: "\(i)") as? CGFloat

            let title = button.titleLabel?.text == nil ? "" : button.titleLabel?.text
            
            let textW = NSString.init(string: title!).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: itemScrollViewH), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:itemTitleFont], context: nil).size.width
            
            let imageW = button.currentImage?.size.width;
            if ((button.currentTitle != nil) && !(button.currentImage != nil)) {
                contentW = textW;
            } else if((button.currentImage != nil) && !(button.currentTitle != nil)) {
                contentW = imageW!;
            } else if ((button.currentTitle != nil) && (button.currentImage != nil) && (button.imagePosition == .right || button.imagePosition == .left)) {
                contentW = textW + imageW!;
            } else if ((button.currentTitle != nil) && (button.currentImage != nil) && (button.imagePosition == .top || button.imagePosition == .bottom)) {
                contentW = max(textW, imageW!);
            }
            if ((setupButtonW) != nil) {
                contentW_sum = contentW_sum + setupButtonW!;
                buttonWidths.add(setupButtonW!)
                print(setupButtonW!)
            } else {
                contentW_sum = contentW_sum + contentW;
                buttonWidths.add(contentW)
                print(contentW)
            }
        }
        
        let diff = itemScrollViewW - contentW_sum
        
        self.buttons.enumerateObjects({ (temp, idx, stop) in
            let button = temp as!UIButton
            let setupButtonW:CGFloat? = self.setupWidths?.object(forKey: "\(idx)") as?CGFloat
            if permutationWay == .adaptContent{
                buttonW = buttonWidths[idx] as! CGFloat
                if idx == 0{
                    button.frame = CGRect(x: itemPadding*0.5+lastButtonMaxX, y: 0, width: buttonW, height: itemScrollViewH)
                }else{
                    button.frame = CGRect(x: itemPadding+lastButtonMaxX, y: 0, width: buttonW, height: itemScrollViewH)
                }
            }else if permutationWay == .notScrollEqualWidths{
                 // 求出外界设置的按钮宽度之和
                let value  = NSArray.init(array: (setupWidths?.allValues)!)
                let totalSetupButtonW:CGFloat? = value.value(forKeyPath: "sum.floatValue") as? CGFloat

                // 如果该按钮外界设置了宽，则取外界设置的，如果外界没设置，则其余按钮等宽
                if setupButtonW != nil{
                    buttonW = setupButtonW!
                }else{
                    let a = itemScrollViewW - itemPadding * CGFloat(self.buttons.count) - totalSetupButtonW!
                    let b = self.buttons.count - (self.setupWidths?.count)!
                    buttonW = a/CGFloat(b)
                    if buttonW < 0{
                        buttonW = 0
                    }
                    if idx == 0{
                        button.frame = CGRect(x: itemPadding*0.5+lastButtonMaxX, y: 0, width: buttonW, height: itemScrollViewH)
                    }else{
                        button.frame = CGRect(x: itemPadding+lastButtonMaxX, y: 0, width: buttonW, height: itemScrollViewH)
                    }
                }
            }else{
                itemPadding = diff/CGFloat(self.buttons.count)
                buttonW = buttonWidths[idx] as! CGFloat
                if idx == 0{
                    button.frame = CGRect(x: itemPadding*0.5+lastButtonMaxX, y: 0, width: buttonW, height: itemScrollViewH)
                }else{
                    button.frame = CGRect(x: itemPadding+lastButtonMaxX, y: 0, width: buttonW, height: itemScrollViewH)
                }
            }
            lastButtonMaxX = button.frame.maxX
        })
        
        if selectedButton != nil{
             self.resetSetupTrackerFrameWithSelectedButton(selectedButton: self.selectedButton!)
            if (self.translatesAutoresizingMaskIntoConstraints == false) {
                self.moveItemScrollViewWithSelectedButton(selectedButton: self.selectedButton!);
            }
        }
        
       
        
        self.itemScrollView?.contentSize = CGSize(width: lastButtonMaxX+itemPadding*0.5, height: 0)
        
        
    }
    
}
