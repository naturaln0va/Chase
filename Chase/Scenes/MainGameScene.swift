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
    let iPhoneScale: CGFloat = 2.75
    let macScale: CGFloat = 4.75
    
    var gameScale: CGFloat
    var worldNode = SKNode()
    var backgroundLayerNode = SKSpriteNode()
    var cameraTarget = CGPointZero
    
    let entityAtlas = SKTextureAtlas(named: "entities")
    var player: Entity
    var enemies: [Entity]
    
    override init(size: CGSize)
    {
        #if os(iOS)
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                gameScale = iPadScale
            } else {
                gameScale = iPhoneScale
            }
            #else
            gameScale = macScale
        #endif
        
        player = Entity(position: CGPoint(x: 20, y: 100), texture: entityAtlas.textureNamed("player"))
        player.zPosition = WorldLayer.LayerPlayer.rawValue
        
        backgroundLayerNode.zPosition = WorldLayer.LayerBackground.rawValue
        backgroundLayerNode.color = SKColorWithRGB(0, 0, 0)
        backgroundLayerNode.size = size
        
        enemies = [Entity]()
        for i in 0..<25 {
            let x = CGFloat.random(min: 25, max: 250)
            let y = CGFloat.random(min: 25, max: 250)
            let enemy = Entity(position: CGPoint(x: x, y: y), texture: entityAtlas.textureNamed("enemy"))
            enemy.zPosition = WorldLayer.LayerBelowPlayer.rawValue
            enemy.zRotation = CGFloat.random(min: 0, max: CGFloat(2 * π))
            enemies.append(enemy)
        }
        
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
        
        for enemy in enemies {
            worldNode.addChild(enemy)
            enemy.runAction(
                SKAction.repeatActionForever(
                    SKAction.sequence([SKAction.waitForDuration(NSTimeInterval(CGFloat.random(min: 0.5, max: 5))),
                        SKAction.runBlock({
                            let x = CGFloat.random(min: 5, max: 250)
                            let y = CGFloat.random(min: 5, max: 250)
                            let newPoint = CGPoint(x: x, y: y)
                            enemy.moveToLocation(newPoint)
                        })
                    ])
                )
            )
        }
        
        cameraTarget = getCenterPointWithTarget(player.position)
        worldNode.position = cameraTarget
    }
    
    func createWorld()
    {
        addChild(backgroundLayerNode)

        worldNode.setScale(gameScale)
        addChild(worldNode)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    func getCenterPointWithTarget(target: CGPoint) -> CGPoint
    {
        var currentScale: CGFloat = 0.0
        
        let x = target.x//.clamped((size.width / currentScale) / 2, currentScale - (size.width / currentScale) / 2)
        let y = target.y//.clamped((size.height / currentScale) / 2, currentScale - (size.height / currentScale) / 2)
        
        return CGPoint(x: -x * currentScale, y: -y * currentScale)
    }
    
    func showTapAtLocation(point: CGPoint)
    {
        let shapeNode = SKShapeNode()
        
        shapeNode.path = CGPathCreateWithEllipseInRect(NSRect(x: -1, y: -1, width: 2, height: 2), nil)
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
    
    //MARK: - Input
#if os(iOS)
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(worldNode)
            showTapAtLocation(location)
            player.moveToLocation(location)
        }
    }
#else
    override func mouseDown(theEvent: NSEvent) {
        let location = theEvent.locationInNode(worldNode)
        showTapAtLocation(location)
        player.moveToLocation(location)
    }
#endif
    
    //MARK: - Update
    override func update(currentTime: CFTimeInterval)
    {
        cameraTarget = getCenterPointWithTarget(player.position)
        worldNode.position += (cameraTarget - worldNode.position) * (π / 10)
    }
}
