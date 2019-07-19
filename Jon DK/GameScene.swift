//
//  GameScene.swift
//  Jon DK
//
//  Created by SanDisk on 2019/7/19.
//  Copyright © 2019 SanDisk. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    //Nodes
    var player : SKNode?
    var yaogan : SKNode?
    var yaoganKnock : SKNode?
    
    var yaoganAction = false
    
    //Measure
    var knobRadius : CGFloat = 50.0
    
    //didmovw
    override func didMove(to view: SKView) {
        player = childNode(withName: "player")
        yaogan = childNode(withName: "yaogan")
        yaoganKnock = yaogan!.childNode(withName: "yao")
    }
    
}

//MARK: Touches
extension GameScene {
    //Touch Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let yaoganKnock = yaoganKnock {
                let location = touch.location(in: yaogan!)
                yaoganAction = yaoganKnock.frame.contains(location)
                
                print("首次点击")
            }else {
                print("执行")
            }
        }
    }
    
    // Touch Moved
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let yaogan = yaogan else { return }
        guard let yaoganKnock = yaoganKnock else { return }
        
        if !yaoganAction {return}
        
        //距离
        for touch in touches {
            let position = touch.location(in: yaogan)
            
            let length = sqrt(pow(position.y, 2) + pow(position.x, 2))
            let angle = atan2(position.y,position.x)
            if knobRadius > length {
                yaoganKnock.position = position
            }else {
                yaoganKnock.position = CGPoint(x: cos(angle) * knobRadius, y: sin(angle) * knobRadius)
            }
        }
    }
    
    //Touch End
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let xYaoganCoordinate = touch.location(in: yaogan!).x
            let xLimit:CGFloat = 150.0
            if xYaoganCoordinate > -xLimit && xYaoganCoordinate < xLimit {
                resetKnobPosition()
            }
        }
        
    }
}

extension GameScene {
    func resetKnobPosition() {
        let initialPoint = CGPoint(x: 0, y: 0)
        let moveBack = SKAction.move(to: initialPoint, duration: 1)
        moveBack.timingMode = .linear
        yaoganKnock!.run(moveBack)
        yaoganAction = false
    }
}
