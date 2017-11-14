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
}

class GameLogicManager {
    
    var level = 1
    var delegate: GameLogicDelegate?
    
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
        
    }
    
    private func nodeWasCorrect(_ node: SKNode) {
        
        if let particles = SKEmitterNode(fileNamed: Constants.kParticleName) {
            node.addChild(particles)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                particles.removeFromParent()
                self.level += 1
                self.delegate?.createLevel(self.level)
            })
        }
        
    }
    
}
