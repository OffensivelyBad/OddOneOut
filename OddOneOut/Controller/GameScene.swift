//
//  GameScene.swift
//  OddOneOut
//
//  Created by Shawn Roller on 11/13/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var viewManager: GameViewManager?
    var logicManager: GameLogicManager?
    
    override func didMove(to view: SKView) {
        
        // Create the logicManager to keep game state and rules
        self.logicManager = GameLogicManager()
        
        // Create the viewManager to manage the sprites
        self.viewManager = GameViewManager(scene: self)
        self.viewManager?.setupInitialScene()
        self.viewManager?.createLevel(self.logicManager?.level ?? 1)

    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        // Destroy the managers
        self.viewManager = nil
        self.logicManager = nil
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
