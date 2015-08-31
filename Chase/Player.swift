//
//  Created by Ryan Ackermann on 8/30/15.
//  Copyright (c) 2015 Ryan Ackermann. All rights reserved.
//

import SpriteKit


class Player: SKNode, SKEntity
{
    var velocity: CGFloat = 0
    var angle: CGFloat = 0
    var alive = true
    var sprite: SKSpriteNode
    
    init(position: CGPoint, texture: SKTexture)
    {
        let spriteTexure = texture
        spriteTexure.filteringMode = .Nearest
        sprite = SKSpriteNode(texture: spriteTexure)
        
        super.init()
        
        self.position = position
        zRotation = 0
        angle = zRotation
        
        addChild(sprite)
        name = "player"
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveToLocation(point: CGPoint)
    {
        let newAngle = (atan2(point.y - position.y, point.x - position.x) * 180 / π) - 90.0
        let duration = 0.35
        let moveEffect = SKTMoveEffect(node: self, duration: duration, startPosition: position, endPosition: point)
        
        let actionChain = SKAction.sequence([SKAction.rotateToAngle(newAngle.degreesToRadians(), duration: duration), SKAction.actionWithEffect(moveEffect)])
        runAction(actionChain)
    }
}
