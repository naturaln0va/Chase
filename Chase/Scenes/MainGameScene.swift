//
//  Created by Ryan Ackermann on 8/27/15.
//  Copyright (c) 2015 Ryan Ackermann. All rights reserved.
//

import SpriteKit


enum WorldLayer: CGFloat {
    case LayerBackground,
         LayerBelowPlayer,
         LayerPlayer,
         LayerAbovePlayer,
         LayerTop,
         LayerGUI
}

class MainGameScene: SKScene
{
    let iPadScale: CGFloat = 4.0
    let iPhoneScale: CGFloat = 2.0
    
    var worldNode = SKNode()
    var backgroundLayerNode = SKSpriteNode()
    var cameraTarget = CGPointZero
    
    let entityAtlas = SKTextureAtlas(named: "entities")
    var player: Player
    
    override init(size: CGSize)
    {
        player = Player(position: CGPoint(x: 20, y: 100), texture: entityAtlas.textureNamed("player"))
        player.zPosition = WorldLayer.LayerPlayer.rawValue
        
        backgroundLayerNode.zPosition = WorldLayer.LayerBackground.rawValue
        backgroundLayerNode.color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        backgroundLayerNode.size = size
        
        super.init(size: size)
        
        backgroundColor = SKColorWithRGB(22, 22, 22)
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView)
    {
        createWorld()
        
        worldNode.addChild(player)
        
        cameraTarget = getCenterPointWithTarget(player.position)
        worldNode.position = cameraTarget
    }
    
    func createWorld()
    {
        addChild(backgroundLayerNode)

        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            worldNode.setScale(iPadScale)
        } else {
            worldNode.setScale(iPhoneScale)
        }
        addChild(worldNode)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    func getCenterPointWithTarget(target: CGPoint) -> CGPoint
    {
        var currentScale: CGFloat = 0.0
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            currentScale = iPadScale
        } else {
            currentScale = iPhoneScale
        }
        
        let x = target.x//.clamped((size.width / currentScale) / 2, currentScale - (size.width / currentScale) / 2)
        let y = target.y//.clamped((size.height / currentScale) / 2, currentScale - (size.height / currentScale) / 2)
        
        return CGPoint(x: -x * currentScale, y: -y * currentScale)
    }
    
    func showTapAtLocation(point: CGPoint)
    {
        let path = UIBezierPath(ovalInRect:
            CGRect(x: -1, y: -1, width: 2, height: 2))
        
        let shapeNode = SKShapeNode()
        shapeNode.path = path.CGPath
        shapeNode.position = point
        shapeNode.strokeColor = SKColorWithRGBA(255, 255, 255, 196)
        shapeNode.lineWidth = 0.4
        shapeNode.antialiased = false
        shapeNode.zPosition = WorldLayer.LayerTop.rawValue
        worldNode.addChild(shapeNode)
        
        let duration = 0.6
        let scaleAction = SKAction.scaleTo(6.0, duration: duration)
        scaleAction.timingMode = .EaseOut
        shapeNode.runAction(SKAction.sequence(
            [scaleAction, SKAction.removeFromParent()]))
        
        let fadeAction = SKAction.fadeOutWithDuration(duration)
        fadeAction.timingMode = .EaseOut
        shapeNode.runAction(fadeAction)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(worldNode)
            showTapAtLocation(location)
            player.moveToLocation(location)
        }
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        cameraTarget = getCenterPointWithTarget(player.position)
        worldNode.position += (cameraTarget - worldNode.position) * 0.05
    }
}
