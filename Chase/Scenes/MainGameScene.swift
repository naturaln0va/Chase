//
//  Created by Ryan Ackermann on 8/27/15.
//  Copyright (c) 2015 Ryan Ackermann. All rights reserved.
//

import SpriteKit

class MainGameScene: SKScene
{
    override func didMoveToView(view: SKView)
    {
        let atlas = SKTextureAtlas(named: "player")
        
        var textures: Array<SKTexture> = Array<SKTexture>()
        for i in 0..<3 {
            let texture: SKTexture = atlas.textureNamed("player_ship_\(i)")
            texture.filteringMode = .Nearest
            textures.append(texture)
        }
        
        let ship = SKSpriteNode(texture: textures[0])
        ship.position = CGPoint(x: 125, y: 200)
        
        ship.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(textures, timePerFrame: 0.05)))
        
        addChild(ship)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
        }
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
    }
}
