//
//  GameLogicManager.swift
//  OddOneOut
//
//  Created by Shawn Roller on 11/13/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import Foundation
import SpriteKit

protocol GameLogicDelegate {
    func createLevel(_ level: Int)
    func setScore(to score: Int)
    func playSound(_ name: String)
    func updateTime(_ time: Int)
    func showGameOver()
    func restartScene()
}

class GameLogicManager {
    
    var delegate: GameLogicDelegate?
    var level = 1
    var score = 0 {
        didSet {
            self.delegate?.setScore(to: score)
        }
    }
    var isGameRunning = true
    var startTime = 0.0
    
}

// MARK: - Game logic

extension GameLogicManager {
    
    func checkForTimeRemaining(_ currentTime: TimeInterval) {
        
        guard self.isGameRunning else { return }
        
        // The level is starting
        if self.startTime == 0 {
            self.startTime = currentTime
        }
        // Get the time that has elapsed
        let timePassed = currentTime - self.startTime
        let timeRemaining = Int(ceil(Constants.timePerLevel - timePassed))
        self.delegate?.updateTime(timeRemaining)
        if timeRemaining <= 0 {
            self.isGameRunning = false
            self.delegate?.showGameOver()
        }
        
    }
    
    func checkForCorrectNodeFrom(_ nodes: [SKNode]) {
        
        // Ensure the game is not over
        guard self.isGameRunning else {
            // Present the scene again
            self.delegate?.restartScene()
            return
        }
        
        var correctNode = false
        guard let node = nodes.first, node.alpha != 0 else { return }
        correctNode = node.name == Constants.kCorrectName
        if correctNode {
            nodeWasCorrect(node)
        }
        else {
            nodeWasWrong(node)
        }
        
        // User tapped on a visible node; stop the timer
        self.isGameRunning = false
        
    }
    
    private func nodeWasCorrect(_ node: SKNode) {
        
        if let particles = SKEmitterNode(fileNamed: Constants.kParticleName) {
            node.addChild(particles)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                particles.removeFromParent()
                self.level += 1
                self.delegate?.createLevel(self.level)
            }
        }
        
        self.score += 1
        
        // Play a sound effect
        self.delegate?.playSound(Constants.kCorrectSound)
        
    }
    
    private func nodeWasWrong(_ node: SKNode) {
        
        let wrongNode = SKSpriteNode(imageNamed: Constants.kWrongImageName)
        node.addChild(wrongNode)
        wrongNode.zPosition = 9
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            wrongNode.removeFromParent()
            self.level = self.level - 1 == 0 ? 1 : self.level - 1
            self.delegate?.createLevel(self.level)
        }
        
        self.score -= 1
        
        // Play a sound effect
        self.delegate?.playSound(Constants.kWrongSound)
        
    }
    
}
