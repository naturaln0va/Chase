//
//  Created by Ryan Ackermann on 8/30/15.
//  Copyright (c) 2015 Ryan Ackermann. All rights reserved.
//

import SpriteKit


protocol SKEntity
{
    var velocity: CGFloat { get set }
    var angle: CGFloat { get set }
    var alive: Bool { get set }
    var sprite: SKSpriteNode { get set }
}