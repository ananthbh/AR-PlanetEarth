//
//  ViewController.swift
//  PlanetEarth
//
//  Created by Ananth Bhamidipati on 28/08/2018.
//  Copyright © 2018 YellowJersey. All rights reserved.
//

import UIKit
import ARKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration, options: .resetTracking)
        self.sceneView.autoenablesDefaultLighting = true
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let sun = SCNNode(geometry: SCNSphere(radius: 0.35))
        let earthParent = SCNNode()
        let venusParent = SCNNode()
        let moonParent = SCNNode()
        
        sun.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Sun diffuse")
        sun.position = SCNVector3(0, 0, -1)
        earthParent.position = SCNVector3(0, 0, -1)
        venusParent.position = SCNVector3(0, 0, -1)
        moonParent.position = SCNVector3(1.2,0,0)
        
        self.sceneView.scene.rootNode.addChildNode(sun)
        self.sceneView.scene.rootNode.addChildNode(earthParent)
        self.sceneView.scene.rootNode.addChildNode(venusParent)
        
        let earth = planet(geometry: SCNSphere(radius: 0.2), diffuse: UIImage(named: "Earthday")!, specular: UIImage(named: "Earth Specular")!, emission: UIImage(named: "Earth Emission")!, normal: UIImage(named: "Earth Normal")!, position: SCNVector3(1.2,0,0))
        
        let moon = planet(geometry: SCNSphere(radius: 0.05), diffuse: UIImage(named: "Moon Diffuse")!, specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,-0.3))
        
        let venus = planet(geometry: SCNSphere(radius: 0.1), diffuse: UIImage(named: "Venus Surface")!, specular: nil, emission: UIImage(named: "Venus Atmosphere"), normal: nil, position: SCNVector3(0.7,0,0))
        
        let sunForever = rotation(time: 8)
        let earthParentForever = rotation(time: 14)
        let venusParentForever = rotation(time: 10)
        let earthRotationForever = rotation(time: 8)
        let moonRotationForever = rotation(time: 4)
        let venusRotationForever = rotation(time: 8)
        
        earthParent.runAction(earthParentForever)
        venusParent.runAction(venusParentForever)
        earth.runAction(earthRotationForever)
        venus.runAction(venusRotationForever)
        moonParent.runAction(moonRotationForever)
        sun.runAction(sunForever)
        
        earthParent.addChildNode(earth)
        earthParent.addChildNode(moonParent)
        venusParent.addChildNode(venus)
        earth.addChildNode(moon)
        moonParent.addChildNode(moon)
        
    }
    
    

    func planet(geometry: SCNGeometry, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3) -> SCNNode {
        let planet = SCNNode(geometry: geometry)
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.position = position
        return planet
    }
    
    func rotation(time: TimeInterval) -> SCNAction {
        let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreeToRadians), z: 0, duration: time)
        let forever = SCNAction.repeatForever(rotation)
        return forever
    }
    
}

extension Int {
    var degreeToRadians: Double { return Double(self) * .pi / 180}
}
