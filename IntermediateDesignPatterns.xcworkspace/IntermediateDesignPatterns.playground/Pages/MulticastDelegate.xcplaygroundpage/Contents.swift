/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Multicast Delegate
 - - - - - - - - - -
 ![Multicast Delegate Diagram](MulticastDelegate_Diagram.png)
 
 The multicast delegate pattern is a behavioral pattern and a variation on the delegate pattern. Instead of a one-to-one delegate relationship, the multicast delegate allows you to create one-to-many delegate relationships. It involes three types:
 
 1. The **delegate protocol** defines the methods a delegate may or should implement.
 2. The **delegate** is an object that implements the delegate protocol.
 3. The **Multicast Delegate** is a helper class that holds onto delegates and allows you to invoke _all_ of the delegates whenever a delegate-worthy event happens.
 
 ## Code Example
 */
import UIKit

public class MulticastDelegate<ProtocolType> {

    private class DelegateWrapper {
        weak var delegate: AnyObject?

        init(_ delegate: AnyObject) {
            self.delegate = delegate
        }
    }

    private var delegateWrappers: [DelegateWrapper]

    public var delegates: [ProtocolType] {
        delegateWrappers = delegateWrappers.filter { $0.delegate != nil }
        return delegateWrappers.map { $0.delegate } as! [ProtocolType]
    }

    public init(_ delegates: [ProtocolType] = []){
        delegateWrappers = delegates.map { DelegateWrapper($0 as AnyObject)}
    }

    public func addDelegate(_ delegate: ProtocolType) {
        delegateWrappers.append(DelegateWrapper(delegate as AnyObject))
    }

    public func removeDelegate(_ delegate: ProtocolType){
        guard let index = delegateWrappers.firstIndex(where: { $0.delegate === (delegate as AnyObject)}) else {
            return
        }
        delegateWrappers.remove(at: index)
    }

    public func invokeDelegates(_ closure: (ProtocolType) -> Void) {
        delegates.forEach {closure($0)}
    }
}


public protocol EmergencyResponding {
    func notifyFire(at location: String)
    func notifyCarCrash(at location: String)
}

public class FireStation: EmergencyResponding {
    public func notifyFire(at location: String) {
        print("FireFighters are notify fire at \(location)")
    }

    public func notifyCarCrash(at location: String) {
        print("FireFighters are notify about car crash at \(location)")
    }
}

public class PoliceStation: EmergencyResponding {

    public func notifyFire(at location: String) {
        print("Police notify about the Fire at \(location)")
    }

    public func notifyCarCrash(at location: String) {
        print("Police notify about the car carsh at \(location)")
    }
}


public class DispatchSystem {
    let muticastDelegate = MulticastDelegate<EmergencyResponding>()
}

let dispatchSystem = DispatchSystem()
var policeStation: PoliceStation! = PoliceStation()
var fireStation: FireStation! = FireStation()

dispatchSystem.muticastDelegate.addDelegate(policeStation)
dispatchSystem.muticastDelegate.addDelegate(fireStation)

dispatchSystem.muticastDelegate.invokeDelegates { delegate in
    delegate.notifyFire(at: "Main Market!")
}


fireStation = nil

dispatchSystem.muticastDelegate.invokeDelegates { (delegate) in
    delegate.notifyCarCrash(at: "Highway Road!")
}
