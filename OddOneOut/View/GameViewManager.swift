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
    var scoreLabel = SKLabelNode(fontNamed: Constants.kFontName)
    var timeLabel = SKLabelNode(fontNamed: Constants.kFontName)
    let background = SKSpriteNode(imageNamed: Constants.kBackgroundImage)
    
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
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
}

// MARK: - Scene setup
extension GameViewManager {
    
    public func setupInitialScene() {
        
        // Create the background sprite
        createBackground()
        
        // Create the grid of sprites
        createGrid()
        
        // Create score label
        createScoreLabel()
        
        // Create timer label
        createTimerLabel()
        
        // Start music
        createMusic()
        
    }
    
    private func createBackground() {
        
        self.background.name = Constants.kBackgroundName
        self.background.zPosition = -1
        self.scene.addChild(self.background)
        
    }
    
    private func createScoreLabel() {
        
        // Add the score label
        let xPosition = -(self.sceneWidth / 2) + (self.horizontalPadding / 2)
        let yPosition = (self.sceneHeight / 2) - (self.horizontalPadding / 2)
        self.scoreLabel.position = CGPoint(x: xPosition, y: yPosition)
        self.scoreLabel.zPosition = 1
        self.background.addChild(self.scoreLabel)
        
        // Set the initial score to 0
        setScore(to: 0)
        
    }
    
    private func createTimerLabel() {
        
        // Add the timer label
        let xPosition = (self.sceneWidth / 2) - self.horizontalPadding
        let yPosition = (self.sceneHeight / 2) - (self.horizontalPadding / 2)
        self.timeLabel.position = CGPoint(x: xPosition, y: yPosition)
        self.timeLabel.zPosition = 1
        self.background.addChild(self.timeLabel)
        
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
    
    private func createMusic() {
    
        let music = SKAudioNode(fileNamed: Constants.kMusicName)
        self.background.addChild(music)
    
    }
    
    public func createLevel(_ level: Int) {
        
        // Get all the piece nodes
        let items = self.scene.children.filter { $0.name != Constants.kBackgroundName }
        
        // Randomize the pieces
        let shuffled = (items as NSArray).shuffled() as! [SKSpriteNode]
        
        for item in shuffled {
            // Hide the pieces
            let fadeOut = SKAction.fadeOut(withDuration: 0.1)
            item.run(fadeOut)
            item.isHidden = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(10)) {
            // Create an action to fade the pieces in
            let fadeIn = SKAction.fadeIn(withDuration: 0.1)
            
            // Shuffle the available pieces
            var shuffledPieces = (Constants.kAllPieces as NSArray).shuffled() as! [String]
            
            // Remove and store the correct piece
            let correctPiece = shuffledPieces.removeLast()
            
            // Get the wrong pieces
            let wrongPieces = self.getWrongPiecesFrom(shuffledPieces, for: level)
            
            for (index, piece) in wrongPieces.enumerated() {
                // Pull the matching item
                let item = shuffled[index]
                
                // Assign the correct texture
                item.texture = SKTexture(imageNamed: piece)
                
                // Show the piece
                item.run(fadeIn)
                item.isHidden = false
                
                // Mark it as the wrong piece
                item.name = Constants.kWrongName
            }
            
            // Add a single correct piece
            shuffled.last?.texture = SKTexture(imageNamed: correctPiece)
            shuffled.last?.run(fadeIn)
            shuffled.last?.isHidden = false
            shuffled.last?.name = Constants.kCorrectName
        }
        
    }
    
    private func getWrongPiecesFrom(_ pieces: [String], for level: Int) -> [String] {
        
        var itemsToShow = Constants.minimumPieces + (level * Constants.piecesPerLevel)
        // Limit the number of pieces to the grid that was created
        itemsToShow = min(itemsToShow, Constants.squaresHigh * Constants.squaresWide)
        
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
    
    func setScore(to score: Int) {
        self.scoreLabel.text = "S: \(score)"
    }
    
    func playSound(_ name: String) {
        
        let soundAction = SKAction.playSoundFileNamed(name, waitForCompletion: false)
        self.scene.run(soundAction)
        
    }
    
    func showGameOver() {
        // Animations to run on the game over sprite
        let scaleDown = SKAction.scale(to: 0.001, duration: 0)
        let fadeIn = SKAction.fadeIn(withDuration: 0.25)
        let scaleUp = SKAction.scale(to: 1, duration: 0.25)
        let afterGroup = SKAction.group([fadeIn, scaleUp])
        let sequence = SKAction.sequence([scaleDown, afterGroup])
        
        let gameOver = SKSpriteNode(imageNamed: Constants.kGameOverName)
        gameOver.zPosition = 100
        self.scene.addChild(gameOver)
        gameOver.run(sequence)
    }
    
    func updateTime(_ time: Int) {
        self.timeLabel.text = "T: \(time)"
    }
    
}
