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
        self.logicManager?.delegate = self
        
        // Create the viewManager to manage the sprites
        self.viewManager = GameViewManager(scene: self)
        self.viewManager?.setupInitialScene()
        createLevel(self.logicManager?.level ?? 1)

    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        // Destroy the managers
        self.viewManager = nil
        self.logicManager = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = self.nodes(at: location)
        self.logicManager?.checkForCorrectNodeFrom(nodes)
        
    }    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        self.logicManager?.checkForTimeRemaining(currentTime)
    }
}

extension GameScene: GameLogicDelegate {
    
    func createLevel(_ level: Int) {
        // Ensure users can now tap on nodes
        self.isUserInteractionEnabled = true
        self.viewManager?.createLevel(level)
        
        // Reset the time for the level and start the timer
        self.logicManager?.startTime = 0
        self.logicManager?.isGameRunning = true
    }
    
    func setScore(to score: Int) {
        self.viewManager?.setScore(to: score)
    }
    
    func playSound(_ name: String) {
        // Prevent multiple guesses
        self.isUserInteractionEnabled = false
        self.viewManager?.playSound(name)
    }
    
    func updateTime(_ time: Int) {
        self.viewManager?.updateTime(time)
    }
    
    func showGameOver() {
        self.viewManager?.showGameOver()
    }
    
    func restartScene() {
        guard let scene = SKScene(fileNamed: "GameScene") else { return }
        scene.scaleMode = .aspectFit
        self.view?.presentScene(scene)
    }
    
}
