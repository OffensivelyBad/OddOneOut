//
//  Constants.swift
//  OddOneOut
//
//  Created by Shawn Roller on 11/13/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import UIKit

struct Constants {
    
    // Names
    static let kBackgroundName = "background"
    static let kCorrectName = "correct"
    static let kWrongName = "wrong"
    static let kParticleName = "Sparks"
    static let kWrongImageName = "wrong"
    
    // Images & textures
    static let kBackgroundImage = "background-leaves"
    static let kPieceOne = "elephant"
    static let kPieceTwo = "giraffe"
    static let kPieceThree = "hippo"
    static let kPieceFour = "monkey"
    static let kPieceFive = "panda"
    static let kPieceSix = "parrot"
    static let kPieceSeven = "penguin"
    static let kPieceEight = "pig"
    static let kPieceNine = "rabbit"
    static let kPieceTen = "snake"
    static var kAllPieces: [String] {
        return [Constants.kPieceOne, Constants.kPieceTwo, Constants.kPieceThree, Constants.kPieceFour, Constants.kPieceFive, Constants.kPieceSix, Constants.kPieceSeven, Constants.kPieceEight, Constants.kPieceNine, Constants.kPieceTen]
    }
    
    // Board layout
    static let squaresHigh = 8
    static let squaresWide = 12
    static var squaresHighCGFloat: CGFloat {
        return CGFloat(Constants.squaresHigh)
    }
    static var squaresWideCGFloat: CGFloat {
        return CGFloat(Constants.squaresWide)
    }
    
    // Game rules
    static let minimumPieces = 5
    static let piecesPerLevel = 4
    
}
