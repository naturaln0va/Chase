//
//  Created by Ryan Ackermann on 8/27/15.
//  Copyright (c) 2015 Ryan Ackermann. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
    }

    override func shouldAutorotate() -> Bool
    {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }

    override func supportedInterfaceOrientations() -> Int
    {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
