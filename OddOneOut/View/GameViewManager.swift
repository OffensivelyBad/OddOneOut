//
//  GameViewManager.swift
//  OddOneOut
//
//  Created by Shawn Roller on 11/13/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import Foundation
import SpriteKit

struct GameViewManager {
    
    // Properties
    
    let scene: SKScene
    
    
    // Computed convenience properties
    
    private var sceneHeight: CGFloat {
        return self.scene.size.height
    }
    private var sceneWidth: CGFloat {
        return self.scene.size.width
    }
    private var squareHeight: CGFloat {
        // The size of each square constrained by the height of the screen
        return self.sceneHeight / Constants.squaresHighCGFloat
    }
    private var horizontalPadding: CGFloat {
        // Get the padding for each side of the board
        return (self.sceneWidth - (self.squareHeight * Constants.squaresWideCGFloat)) / 2
    }
    private var pieceHeight: CGFloat {
        // The scale that should be applied to the pieces if they are not the appropriate size for the screen
        let padding: CGFloat = 10
        return self.squareHeight - padding
    }
    
}

// MARK: - Scene setup
extension GameViewManager {
    
    public func setupInitialScene() {
        
        // Create the background sprite
        createBackground()
        
        // Create the grid of sprites
        createGrid()
        
    }
    
    private func createBackground() {
        
        let background = SKSpriteNode(imageNamed: Constants.kBackgroundImage)
        background.name = Constants.kBackgroundName
        background.zPosition = -1
        self.scene.addChild(background)
        
    }
    
    private func createGrid() {
        
        let xOffset = -(self.sceneWidth / 2) + (self.squareHeight / 2) + self.horizontalPadding
        let yOffset = -(self.sceneHeight / 2) + (self.squareHeight / 2)
        
        for row in 0..<Constants.squaresHigh {
            for col in 0..<Constants.squaresWide {
                
                let item = SKSpriteNode(imageNamed: Constants.kPieceOne)
                item.scale(to: CGSize(width: self.pieceHeight, height: self.pieceHeight))
                item.position = CGPoint(x: xOffset + (CGFloat(col) * self.squareHeight), y: yOffset + (CGFloat(row) * self.squareHeight))
                self.scene.addChild(item)
                
            }
        }
        
    }
    
    public func createLevel(_ level: Int) {
        
        // Get all the piece nodes
        let items = self.scene.children.filter { $0.name != Constants.kBackgroundName }
        
        // Randomize the pieces
        let shuffled = (items as NSArray).shuffled() as! [SKSpriteNode]
        
        for item in shuffled {
            // Hide the pieces
            item.alpha = 0
        }
        
        // Shuffle the available pieces
        var shuffledPieces = (Constants.kAllPieces as NSArray).shuffled() as! [String]
        
        // Remove and store the correct piece
        let correctPiece = shuffledPieces.removeLast()
        
        // Get the wrong pieces
        let wrongPieces = getWrongPiecesFrom(shuffledPieces, for: level)
        
        for (index, piece) in wrongPieces.enumerated() {
            // Pull the matching item
            let item = shuffled[index]
            
            // Assign the correct texture
            item.texture = SKTexture(imageNamed: piece)
            
            // Show the piece
            item.alpha = 1
            
            // Mark it as the wrong piece
            item.name = Constants.kWrongName
        }
        
        // Add a single correct piece
        shuffled.last?.texture = SKTexture(imageNamed: correctPiece)
        shuffled.last?.alpha = 1
        shuffled.last?.name = Constants.kCorrectName
        
    }
    
    private func getWrongPiecesFrom(_ pieces: [String], for level: Int) -> [String] {
        
        let itemsToShow = Constants.minimumPieces + (level * Constants.piecesPerLevel)
        
        var showPieces = [String]()
        var placingPiece = 0
        var numUsed = 0
        
        for _ in 1..<itemsToShow {
            
            // Mark that this piece is used
            numUsed += 1
            
            // Add the piece to the pieces to show
            showPieces.append(pieces[placingPiece])
            
            // If the piece was used twice go to the next piece
            if numUsed == 2 {
                numUsed = 0
                placingPiece += 1
            }
            
            // If all pieces have been used, start back at the first piece
            if placingPiece == pieces.count {
                placingPiece = 0
            }
            
        }
        
        return showPieces
        
    }
    
}