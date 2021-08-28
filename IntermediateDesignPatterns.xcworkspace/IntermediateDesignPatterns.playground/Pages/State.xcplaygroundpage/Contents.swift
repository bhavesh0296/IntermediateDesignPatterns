/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # State
 - - - - - - - - - -
 ![State Diagram](State_Diagram.png)
 
 The state pattern is a behavioral pattern that allows an object to change its behavior at runtime. It does so by changing an internal state. This pattern involves three types:
 
 1. The **context** is the object whose behavior changes and has an internal state.
 
 2. The **state protocol** defines a set of methods and properties required by concrete states. If you need stored properties, you can substitute a **base state class** instead of a protocol.
 
 3. The **concrete states** conform to the state protocol, or if a base class is used instead, they subclass the base. They implement required methods and properties to perform whatever behavior is desired when the context is in its state.
 
 ## Code Example
 */

import UIKit
import PlaygroundSupport

public class TrafficLight: UIView {

    public private(set) var canisterLayers: [CAShapeLayer] = []

    public private(set) var currentState: TrafficLightState
    public private(set) var states: [TrafficLightState]

    @available(*, unavailable, message: "Use init(canisterCount: frame:) instead")
    public required init?(coder: NSCoder) {
        fatalError("init(coder: NCoder) is not supported")
    }

    public init(canisterCount: Int = 3,
                frame: CGRect = CGRect(x: 0, y: 0, width: 160, height: 420),
                states: [TrafficLightState]){

        self.states = states
        self.currentState = states.first!
        super.init(frame: frame)
        backgroundColor = UIColor.black
        createCanisterLayers(count: canisterCount)
        transition(to: currentState)
    }

    public func createCanisterLayers(count: Int){
        let paddingPercentage: CGFloat = 0.2
        let yTotalPadding = paddingPercentage * bounds.height
        let yPadding = yTotalPadding / CGFloat(count + 1)

        let canisterHeight = (bounds.height - yTotalPadding) / CGFloat(count)

        let xPadding = (bounds.width - canisterHeight) / 2.0

        var canisterFrame = CGRect(x: xPadding, y: yPadding, width: canisterHeight, height: canisterHeight)

        for _ in 0..<count {
            let canisterShape = CAShapeLayer()
            canisterShape.path = UIBezierPath(ovalIn: canisterFrame).cgPath
            canisterShape.fillColor = UIColor.lightGray.cgColor

            layer.addSublayer(canisterShape)
            canisterLayers.append(canisterShape)

            canisterFrame.origin.y += (canisterFrame.height + yPadding)
        }

    }

    public func transition(to state: TrafficLightState) {
        removeCanisterSublayers()
        currentState = state
        currentState.apply(to: self)
        nextState.apply(to: self, after: currentState.delay)
    }

    public func removeCanisterSublayers() {
        canisterLayers.forEach { layer in
            layer.sublayers?.forEach({ (subLayer) in
                subLayer.removeFromSuperlayer()
            })
        }
    }

    public var nextState: TrafficLightState {
        guard let index = states.firstIndex(where: { $0 === currentState }),
            index + 1 < states.count else {
                return states.first!
        }
        return states[index + 1]
    }
}

//let trafficLight = TrafficLight()
//PlaygroundPage.current.liveView = trafficLight


public protocol TrafficLightState: class {
    var delay: TimeInterval { get }

    func apply(to context: TrafficLight)
}

extension TrafficLightState {
    public func apply(to context: TrafficLight, after dealy: TimeInterval) {
        let queue = DispatchQueue.main
        let dispatchTime = DispatchTime.now() + delay
        queue.asyncAfter(deadline: dispatchTime) { [weak self, weak context] in
            guard let self = self, let context = context else { return }
            context.transition(to: self)
        }
    }
}


public class SolidTrafficLightState {

    public let canisterIndex: Int
    public let color: UIColor
    public let delay: TimeInterval

    public init(canisterIndex: Int, color: UIColor, delay: TimeInterval){
        self.canisterIndex = canisterIndex
        self.color = color
        self.delay = delay
    }
}


extension SolidTrafficLightState: TrafficLightState {

    public func apply(to context: TrafficLight) {
        let canisterLayer = context.canisterLayers[canisterIndex]
        let circleShape = CAShapeLayer()
        circleShape.path = canisterLayer.path!
        circleShape.fillColor = color.cgColor
        circleShape.strokeColor = color.cgColor
        canisterLayer.addSublayer(circleShape)
    }
}


extension SolidTrafficLightState {

    public class func greenLight(color: UIColor = UIColor.green,
                                 canisterIndex: Int = 2,
                                 delay: TimeInterval = 1.0) -> SolidTrafficLightState {

        return SolidTrafficLightState(canisterIndex: canisterIndex,
                                      color: color,
                                      delay: delay)
    }


    public class func yellowLight(color: UIColor = UIColor.yellow,
                                  canisterIndex: Int = 1,
                                  delay: TimeInterval = 1.0) -> SolidTrafficLightState {

        return SolidTrafficLightState(canisterIndex: canisterIndex,
                                      color: color,
                                      delay: delay)
    }

    public class func redLight(color: UIColor = UIColor.red,
                               canisterIndex: Int = 0,
                               delay: TimeInterval = 1.0) -> SolidTrafficLightState {

        return SolidTrafficLightState(canisterIndex: canisterIndex,
                                      color: color,
                                      delay: delay)
    }

}

//let greenYellowRed: [SolidTrafficLightState] = [.greenLight(), .yellowLight(), .redLight()]

let greenYellowRed: [SolidTrafficLightState] = [.redLight(), .yellowLight(), .greenLight()]

let trafficLight = TrafficLight(states: greenYellowRed)

PlaygroundPage.current.liveView = trafficLight
