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
}

class GameLogicManager {
    
    var delegate: GameLogicDelegate?
    var level = 1
    var score = 0 {
        didSet {
            self.delegate?.setScore(to: score)
        }
    }
    
}

// MARK: - Game logic

extension GameLogicManager {
    
    func checkForCorrectNodeFrom(_ nodes: [SKNode]) {
        
        var correctNode = false
        guard let node = nodes.first else { return }
        correctNode = node.name == Constants.kCorrectName
        if correctNode {
            nodeWasCorrect(node)
        }
        else {
            nodeWasWrong(node)
        }
        
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
        
    }
    
}
