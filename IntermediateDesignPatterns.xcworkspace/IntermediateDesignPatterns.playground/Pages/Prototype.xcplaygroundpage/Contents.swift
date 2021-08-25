/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Prototype
 - - - - - - - - - -
 ![Prototype Diagram](Prototype_Diagram.png)
 
 The prototype pattern is a creational pattern that allows an object to copy itself. It involves two types:
 
 1. A **copying** protocol declares copy methods.
 
 2. A **prototype** is a class that conforms to the copying protocol.
 
 ## Code Example
 */

public protocol Copying: class {
    init(_ prototype: Self)
}

extension Copying {
    public func copy() -> Self {
        return type(of: self).init(self)
    }
}

public class Monster: Copying {
    public var health: Int
    public var level: Int

    public init(health: Int, level: Int) {
        self.health = health
        self.level = level
    }

    public required convenience init(_ monster: Monster) {
        self.init(health: monster.health, level: monster.level)
    }
}

public class EyeBallMonster: Monster {
    public var redness = 0
    public init(health: Int, level: Int, redness: Int) {
        self.redness = redness
        super.init(health: health, level: level)
    }

//    public required convenience init(_ protot) {
//        <#code#>
//    }
    @available(*, unavailable, message: "Call copy() instead")
    public required convenience init(_ prototype: Monster){
        let eyeBallMonster = prototype as! EyeBallMonster
        self.init(health: eyeBallMonster.health,
                  level: eyeBallMonster.level,
                  redness: eyeBallMonster.redness)
    }
}


let monster = Monster(health: 1700, level: 30)
let monster2 = monster.copy()
print("This monster has level \(monster2.level)")


let eyeballMonster = EyeBallMonster(health: 1800, level: 45, redness: 99)
let eyeballMonster2 = eyeballMonster.copy()
print("ehhh A red monster \(eyeballMonster2.redness)")

let eyeballMonster3 = monster.copy()

print(eyeballMonster3.health)



