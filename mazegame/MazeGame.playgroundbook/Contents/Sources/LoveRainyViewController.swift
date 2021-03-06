//
//  LoveRainyViewController.swift
//  Book_Sources
//
//  Created by orient on 2018/12/9.
//

import UIKit
import SceneKit
import PlaygroundSupport
import CoreMotion

class LoveRainyViewController: UIViewController {

    let motionManager = CMMotionManager()
    
    let sceneView = SCNView()
    var scene: SCNScene!
    var cameraNode: SCNNode!
    //particleSystem
    var particleNode: SCNNode!
    var secondParticleNode: SCNNode!
    var snowParticleSystem: SCNParticleSystem!
    var rainyParticleSystem: SCNParticleSystem!
    var leafParticleSystem: SCNParticleSystem!
    //Audio
    var audioNode: SCNNode!
    var rainySound: SCNAudioSource!
    var snowSound: SCNAudioSource!
    var sunnySound: SCNAudioSource!
    //    var sunnySound: SCNAudioSource
    let loadingQueue = OperationQueue()
    var timer: Timer!
    private func configureView() {
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(sceneView)
        sceneView.bounds = view.bounds
    }
    private func configureScene() {
        scene = SCNScene()
        // create and add a camera to the scene
        cameraNode = SCNNode()
        cameraNode.position = SCNVector3Zero
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        rainyParticleSystem = SCNParticleSystem(named: "art.scnassets/rain1.scnp", inDirectory: nil)!
        rainyParticleSystem.particleImage = UIImage(named: "art.scnassets/spark.png")!
        snowParticleSystem = SCNParticleSystem(named: "art.scnassets/snow.scnp", inDirectory: nil)!
        snowParticleSystem.particleImage = UIImage(named: "art.scnassets/snowflake.png")!
        leafParticleSystem = SCNParticleSystem(named: "art.scnassets/leaf.scnp", inDirectory: nil)!
        leafParticleSystem.particleImage = UIImage(named: "art.scnassets/leaf.png")!
        particleNode = SCNNode()
        secondParticleNode = SCNNode()
        scene.rootNode.addChildNode(secondParticleNode)
        scene.rootNode.addChildNode(particleNode)
        let cubeMap = UIImage(named: "C154FDA1-FFAF-433F-A74E-ACD59119672B-8905-00000BE7E43AD9EB_tmp.JPG")
        scene.background.contents = cubeMap
        //preload Audio
        rainySound = SCNAudioSource(named: "art.scnassets/rainy.mp3")
        rainySound.volume = 2.0
        rainySound.load()
        rainySound.loops = true
        snowSound = SCNAudioSource(named: "art.scnassets/snow.mp3")
        snowSound.volume = 2.0
        snowSound.loops = true
        snowSound.load()
        sunnySound = SCNAudioSource(named: "art.scnassets/sunny.mp3")
        sunnySound.volume = 2.0
        sunnySound.loops = true
        sunnySound.load()
        audioNode = SCNNode()
        audioNode.position = cameraNode.position
        scene.rootNode.addChildNode(audioNode)
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadingQueue.addOperation { [weak self] in
            self?.configureScene()
            DispatchQueue.main.async {
                self?.sceneView.scene = self?.scene
            }
        }
        motionManager.deviceMotionUpdateInterval = 1.0 / 120.0
        startDeviceMotion()
    }
    func startDeviceMotion() {
        if motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motionManager.showsDeviceMovementDisplay = true
            self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            // Configure a timer to fetch the motion data.
            self.timer = Timer(fire: Date(), interval: (1.0/60.0), repeats: true, block: { (timer) in
                if let data = self.motionManager.deviceMotion {
                    // Get the attitude relative to the magnetic north reference frame.
                    let dataX = data.attitude.pitch
                    let dataY = data.attitude.roll
                    let dataZ = data.attitude.yaw
                    // Use the motion data in your app.
                    self.cameraNode.eulerAngles = SCNVector3(
                        Float(dataY - .pi/2),
                        Float(dataZ),
                        -Float(dataX)
                    )
                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        motionManager.stopDeviceMotionUpdates()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneView.bounds = view.bounds
        sceneView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
    
    func loveRainy() {
        particleNode.position = SCNVector3Make(1, 5, 1)
        secondParticleNode.position = SCNVector3Make(1, 20, 1)
        particleNode.removeAllParticleSystems()
        particleNode.addParticleSystem(rainyParticleSystem)
        secondParticleNode.removeAllParticleSystems()
        secondParticleNode.addParticleSystem(rainyParticleSystem)
        audioNode.removeAllAudioPlayers()
        audioNode.runAction(SCNAction.playAudio(rainySound, waitForCompletion: false))
    }
    func loveSnow() {
        particleNode.position = SCNVector3Make(1, 5, 1)
        secondParticleNode.position = SCNVector3Make(1, 20, 1)
        particleNode.removeAllParticleSystems()
        particleNode.addParticleSystem(snowParticleSystem)
        secondParticleNode.removeAllParticleSystems()
        secondParticleNode.addParticleSystem(snowParticleSystem)
        audioNode.removeAllAudioPlayers()
        audioNode.runAction(SCNAction.playAudio(snowSound, waitForCompletion: false))
    }
    func loveSunny() {
        particleNode.position = SCNVector3Make(1, 5, 1)
        secondParticleNode.position = SCNVector3Make(1, 10, 1)
        leafParticleSystem.particleImage = UIImage(named: "art.scnassets/leaf.png")
        particleNode.removeAllParticleSystems()
        particleNode.addParticleSystem(leafParticleSystem)
        leafParticleSystem.particleImage = UIImage(named: "art.scnassets/leaf02.png")
        secondParticleNode.removeAllParticleSystems()
        secondParticleNode.addParticleSystem(leafParticleSystem)
        audioNode.removeAllAudioPlayers()
        audioNode.runAction(.playAudio(sunnySound, waitForCompletion: false))
    }

}

extension LoveRainyViewController: PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        if case let .string(text) = message {
            switch text {
            case "rainy":
                loveRainy()
            case "snow":
                loveSnow()
            case "sunny":
                loveSunny()
            default:
                break
            }
        }
    }
}
