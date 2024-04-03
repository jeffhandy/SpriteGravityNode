//
//  GameScene.swift
//  SpriteGravityNode
//
//  Created by Jeff Handy on 3/31/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var nodes: [SKShapeNode] = []
    let dt: CGFloat = 1.0/60.0 //Delta time.
    let radiusLowerBound: CGFloat = 1 //Minimum radius between nodes check.
    let strength: CGFloat = 10000 //Make gravity less weak and more fun!
    override func didMove(to view: SKView) {
        
        let screenSize = CGSize(width: 1024, height: 768) //view.frame.size
        let width = screenSize.width
        let height = screenSize.height
        
        makeNodes(screenSize)
       
        createHorizontalWall(x: 0, y: height/2, width: width, height: height) // Top
        createHorizontalWall(x: 0, y: -height/2, width: width, height: height)// Bottom
        createVerticalWall(x: -width/2, y: 0, width: width, height: height) // Left
        createVerticalWall(x: width/2, y: 0, width: width, height: height) // right
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node1 in nodes {
            for node2 in nodes {
                let m1 = node1.physicsBody!.mass*strength
                let m2 = node2.physicsBody!.mass*strength
                
                let disp = CGVector(dx: node2.position.x-node1.position.x, dy: node2.position.y-node1.position.y)
                let radius = sqrt(disp.dx*disp.dx+disp.dy*disp.dy)
                if radius < radiusLowerBound { //Radius lower-bound.
                    continue
                }
                var force = (m1*m2)/(radius*radius)
                // similiar "species" repel
                if node1.strokeColor == node2.strokeColor {
                    force *= -1 //JTH
                }
                let normal = CGVector(dx: disp.dx/radius, dy: disp.dy/radius)
                let impulse = CGVector(dx: normal.dx*force*dt, dy: normal.dy*force*dt)

                node1.physicsBody!.velocity = CGVector(dx: node1.physicsBody!.velocity.dx + impulse.dx, dy: node1.physicsBody!.velocity.dy + impulse.dy)
            }
        }
    }
    
    private func createVerticalWall(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
    
        let wall = SKSpriteNode(color: .gray, size: CGSize(width: 50, height: height))
        wall.position = CGPoint(x: x, y: y)
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.isDynamic = false // Walls should not move
        addChild(wall)
    }
    
    private func createHorizontalWall(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let wall = SKSpriteNode(color: .gray, size: CGSize(width: width, height: 50))
        wall.position = CGPoint(x: x, y: y)
        wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
        wall.physicsBody?.isDynamic = false // Walls should not move
        addChild(wall)
    }
    
    private func makeNodes(_ screenSize: CGSize) {
        
        self.physicsWorld.gravity = CGVector()
        for _ in 1 ... 200 {
            let red = makeRed()
            nodes.append(red)
            let blue = makeBlue()
            nodes.append(blue)
            let green = makeGreen()
            nodes.append(green)
        }
    }
    
    private func makeRed() -> SKShapeNode {
        
        let value = 3.0/2
        
        let screenSize = CGSize(width: 1024, height: 768) //view.frame.size
        let width = screenSize.width
        let height = screenSize.height
        
        let rndPosition = CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.size.width))) - width/2, y: CGFloat(arc4random_uniform(UInt32(self.size.height))) - height/2)
        let node = SKShapeNode(circleOfRadius: value)
        node.fillColor = NSColor.red
        node.strokeColor = NSColor.red
        node.position = rndPosition
        node.physicsBody = SKPhysicsBody(circleOfRadius: value)
        node.physicsBody?.mass = value/1000
        node.name = "red"
        self.addChild(node)
        
        return node
    }
    
    private func makeBlue() -> SKShapeNode {
        
        let value = 5.0/2
        
        let screenSize = CGSize(width: 1024, height: 768) //view.frame.size
        let width = screenSize.width
        let height = screenSize.height
        
        let rndPosition = CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.size.width))) - width/2, y: CGFloat(arc4random_uniform(UInt32(self.size.height))) - height/2)
        let node = SKShapeNode(circleOfRadius: value)
        node.fillColor = NSColor.blue
        node.strokeColor = NSColor.blue
        node.position = rndPosition
        node.physicsBody = SKPhysicsBody(circleOfRadius: value)
        node.physicsBody?.mass = value*5/1000
        node.name = "blue"
        self.addChild(node)
        
        return node
    }
    
    private func makeGreen() -> SKShapeNode {
        
        let value = 9.0/2
        
        let screenSize = CGSize(width: 1024, height: 768) //view.frame.size
        let width = screenSize.width
        let height = screenSize.height
        
        let rndPosition = CGPoint(x: CGFloat(arc4random_uniform(UInt32(self.size.width))) - width/2, y: CGFloat(arc4random_uniform(UInt32(self.size.height))) - height/2)
        let node = SKShapeNode(circleOfRadius: value)
        node.fillColor = NSColor.green
        node.strokeColor = NSColor.green
        node.position = rndPosition
        node.physicsBody = SKPhysicsBody(circleOfRadius: value)
        node.physicsBody?.mass = value*3/1000
        node.physicsBody?.restitution = 1.0
        node.name = "green"
        self.addChild(node)
        
        return node
    }
}
