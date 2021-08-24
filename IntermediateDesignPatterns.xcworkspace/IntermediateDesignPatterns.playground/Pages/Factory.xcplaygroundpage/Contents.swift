/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Factory
 - - - - - - - - - -
 ![Factory Diagram](Factory_Diagram.png)
 
 The factory pattern provides a way to create objects without exposing creation logic. It involves two types:
 
 1. The **factory** creates objects.
 2. The **products** are the objects that are created.
 
 ## Code Example
 */

import Foundation

public struct JobApplicant {
    public let name: String
    public let email: String
    public var status: Status

    public enum Status {
        case new
        case interview
        case hired
        case rejected
    }
}

public struct Email{
    public let subject: String
    public let senderEmail: String
    public let recipientEmail: String
    public let messageBody: String
}

public struct EmailFactory {
    public let senderEmail: String

    public func createEmail(to recipient: JobApplicant) -> Email {
        let subject: String
        let messageBody: String

        switch recipient.status {
        case .new:
            subject = "We received your Application"
            messageBody = "Thanks for applying Job here"
        case .interview:
            subject = "We want to take your interview"
            messageBody = "Congratulations \(recipient.name), we impressed by your Resume, and wanna schedule your interview"
        case .hired:
            subject = "We want to hire you"
            messageBody = "Congratulations \(recipient.name), we like to work with you"
        case .rejected:
            subject = "Thanks for your application"
            messageBody = "Sorry to say that, you didn't get seleced, you can apply again after 6 months, best of luck next time"
        }

        return Email(subject: subject, senderEmail: senderEmail, recipientEmail: recipient.email, messageBody: messageBody)
    }
}

var bhavesh = JobApplicant(name: "Bhavesh Gupta", email: "bhaveshgutpa296@gmail.com", status: .new)

let emailFactory = EmailFactory(senderEmail: "hr@careers.com")

print(emailFactory.createEmail(to: bhavesh))

bhavesh.status = .interview

print(emailFactory.createEmail(to: bhavesh))

bhavesh.status = .hired
print(emailFactory.createEmail(to: bhavesh))
