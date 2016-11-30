//
//  LivePlayViewController.swift
//  糗百
//
//  Created by Youcai on 16/10/13.
//  Copyright © 2016年 mm. All rights reserved.


import UIKit
import IJKMediaFramework
class LivePlayViewController: UIViewController {
    var url:String?
    var playerVc =  IJKFFMoviePlayerController.init()
    override func viewDidLoad() {
        super.viewDidLoad()
       view.backgroundColor = WHITE_COLOR
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
      
        let playerVc = IJKFFMoviePlayerController.init(contentURL: URL.init(string: url!), with: nil)
        playerVc?.prepareToPlay()
        
        playerVc?.view.frame = view.bounds
        self.playerVc = playerVc!
        view.addSubview((playerVc?.view)!)
       // playerVc?.view.addSubview(emitterView)
       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // emitterView.emit()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.playerVc.pause()
        self.playerVc.stop()
        self.playerVc.shutdown()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private lazy var emitterView:PraiseEmitterView = {
  let view = PraiseEmitterView.init(frame: CGRect.init(x: SCREEN_WIDTH-30, y: SCREEN_HEIGHT/2.0-40, width: 30, height: SCREEN_HEIGHT/2.0))
        return view
    }()


}
class PraiseEmitterView: UIView {
    
    private var timer: Timer?
    private let emitter: CAEmitterLayer! = {
        let emitter = CAEmitterLayer()
        return emitter
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    private func setup() {
        emitter.frame = bounds
        emitter.birthRate = 0
        emitter.emitterShape = kCAEmitterLayerLine
        //CGPointMake(0,bounds.height)
        
        emitter.emitterPosition = CGPoint.init(x: 0, y: bounds.height)
        emitter.emitterSize = bounds.size
        emitter.emitterCells = [getEmitterCell(contentImage: UIImage(named: "icon_review")!.cgImage!), getEmitterCell(contentImage: UIImage(named: "im_my_contacts")!.cgImage!)]
        self.layer.addSublayer(emitter)
    }
    func timeoutSelector() {
        emitter.birthRate = 0
    }
    func emit() {
        emitter.birthRate = 2
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timeoutSelector), userInfo: nil, repeats: false)
    }
    private func getEmitterCell(contentImage: CGImage) -> CAEmitterCell {
        
        let emitterCell = CAEmitterCell()
        emitterCell.contents = contentImage
        emitterCell.lifetime = 2
        emitterCell.birthRate = 2
        
        emitterCell.yAcceleration = -70.0
        emitterCell.xAcceleration = 0
        
        emitterCell.velocity = 20.0
        emitterCell.velocityRange = 200.0
        
        emitterCell.emissionLongitude = CGFloat(0)
        emitterCell.emissionRange = CGFloat(M_PI_4)
        
        emitterCell.scale = 0.8
        emitterCell.scaleRange = 0.8
        emitterCell.scaleSpeed = -0.15
        
        emitterCell.alphaRange = 0.75
        emitterCell.alphaSpeed = -0.15
        
        return emitterCell
    }
}
