//
//  Created by Ryan Ackermann on 9/4/15.
//  Copyright (c) 2015 Ryan Ackermann. All rights reserved.
//

import Cocoa
import SpriteKit


@NSApplicationMain
class WindowController: NSObject, NSApplicationDelegate
{
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    func applicationDidFinishLaunching(notification: NSNotification)
    {
        let scene = MainGameScene(size: CGSize(width: 1920, height: 1080))
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool
    {
        return true
    }
}
