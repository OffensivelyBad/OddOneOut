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
        guard let node = nodes.first, (node.name == Constants.kCorrectName || node.name == Constants.kWrongName), !node.isHidden else { return }
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                particles.removeFromParent()
                self.level += 1
                self.delegate?.createLevel(self.level)
            }
        }
        
        self.score += 1
        
        let originalScale = node.xScale
        let originalPosition = node.position
        
        // Zoom the node into the screen
        let scale = SKAction.scale(by: 3, duration: 0.25)
        let pan = SKAction.move(to: CGPoint.zero, duration: 0.25)
        let shakeRight = SKAction.rotate(byAngle: CGFloat.pi / 4, duration: 0.1)
        let shakeLeft = SKAction.rotate(byAngle: -(CGFloat.pi / 4), duration: 0.1)
        let shake = SKAction.repeat(SKAction.sequence([shakeRight, shakeLeft]), count: 5)
        let bringNodeToTop = SKAction.run {
            node.zPosition += 1
        }
        // Time the animations group takes: 1
        let group = SKAction.group([bringNodeToTop, scale, pan, shake])
        
        // Zoom the node back out and into it's original position
        let scaleDown = SKAction.scale(to: originalScale, duration: 0.25)
        let panBack = SKAction.move(to: originalPosition, duration: 0.25)
        let sendNodeToBottom = SKAction.run {
            node.zPosition -= 1
        }
        // Time the animations group takes: 0.5
        let afterGroup = SKAction.group([sendNodeToBottom, scaleDown, panBack])
        
        // Run the animations on the node
        node.run(SKAction.sequence([group, afterGroup]))

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
