//
//  ViewController.swift
//  BlindNavigator
//
//  Created by apanin on 1/30/20.
//  Copyright © 2020 Alexei Panin. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        let refernceImages = ARReferenceImage.referenceImages(inGroupNamed: "default-ar-assets", bundle: nil)!
        
        configuration.trackingImages = refernceImages
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        return node
    }
*/
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // tigger just for real anchors, retun if not an anchor
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
        
        let referenceImage = imageAnchor.referenceImage

        
        let plane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)

        plane.firstMaterial?.diffuse.contents = UIColor.blue
        let planeNode = SCNNode.init(geometry: plane)
        planeNode.opacity = 0.25
        planeNode.eulerAngles.x = -Float.pi / 2

        node.addChildNode(planeNode)
        node.addChildNode(createTextNode(string: imageAnchor.referenceImage.name!))
    }
    
    func createTextNode(string: String) -> SCNNode {
        let text = SCNText(string: string, extrusionDepth: 0.001)
        text.font = UIFont.systemFont(ofSize: 1.0)
        text.flatness = 0.04
        text.firstMaterial?.diffuse.contents = UIColor.white

        let textNode = SCNNode(geometry: text)
        textNode.rotate(by: SCNQuaternion.init(CGFloat.pi/2, 0, 0, 0), aroundTarget: SCNVector3Zero)
        textNode.position = SCNVector3Zero
        return textNode
    }
    
    var planeActions: SCNAction {
        return .sequence([.wait(duration: 2.0), .fadeOut(duration: 1.0), .removeFromParentNode()])
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}


//The rook moves any number of vacant squares forwards, backwards, left, or right in a straight line. It also takes part, along with the king, in a special move called castling.

//The bishop moves any number of vacant squares diagonally in a straight line. Consequently, a bishop stays on squares of the same color throughout a game. The two bishops each player starts with move on squares of opposite colors.

//The queen moves any number of vacant squares in any direction: forwards, backwards, left, right, or diagonally, in a straight line.

//The king moves exactly one vacant square in any direction: forwards, backwards, left, right, or diagonally; however, it cannot move to a square that is under attack by an opponent, nor can a player make a move with another piece if it will leave the king in check. It also has a special move called castling, in which the king moves two squares towards one of its own rooks and in the same move, the rook jumps over the king to land on the square on the king's other side. Castling may only be performed if the king and rook involved have never previously been moved in the game, if the king is not in check, if the king would not travel through or into check, and if there are no pieces between the rook and the king.

//The knight moves on an extended diagonal from one corner of any 2×3 rectangle of squares to the furthest opposite corner. Consequently, the knight alternates its square color each time it moves. Other than the castling move described above where the rook jumps over the king, the knight is the only piece permitted to routinely jump over any intervening piece(s) when moving.

//The pawn moves forward exactly one square, or optionally, two squares when on its starting square, toward the opponent's side of the board. When there is an enemy piece one square diagonally ahead of a pawn, either left or right, then the pawn may capture that piece. A pawn can perform a special type of capture of an enemy pawn called en passant. If the pawn reaches a square on the back rank of the opponent, it promotes to the player's choice of a queen, rook, bishop, or knight.

