/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Adapter
 - - - - - - - - - -
 ![Adapter Diagram](Adapter_Diagram.png)
 
 The adapter pattern allows incompatible types to work together. It involves four components:
 
 1. An **object using an adapter** is the object that depends on the new protocol.
 
 2. The **new protocol** that is desired to be used.
 
 3. A **legacy object** that existed before the protocol was made and cannot be modified directly to conform to it.
 
 4. An **adapter** that's created to conform to the protocol and passes calls onto the legacy object.
 
 ## Code Example
 */
import UIKit

public class GoogleAuthenticator {
    public func login(email: String, password: String, completion: @escaping (Result<GoogleUser, Error>) -> Void) {
        let token = "Token-Value"
        let user = GoogleUser(email: email, password: password, token: token)
        completion(.success(user))
    }
}

public struct GoogleUser {
    public let email: String
    public let password: String
    public let token: String
}

public protocol AuthenticationService {
    func login(email: String, password: String, completion: @escaping (Result<(User, Token), Error>) -> Void)
}

public struct User {
    public let email: String
    public let password: String
}

public struct Token {
    public let value: String
}

public class GoogleAuthenticatorAdapter: AuthenticationService {

    private var authenticator = GoogleAuthenticator()

    public func login(email: String, password: String, completion: @escaping (Result<(User, Token), Error>) -> Void) {
        authenticator.login(email: email, password: password) { (result) in
            switch result {
            case .success(let googleUser):
                let user = User(email: googleUser.email, password: googleUser.password)
                let token =  Token(value: googleUser.token)
                completion(.success((user,token)))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}


public class LoginViewController: UIViewController {

    public var authService: AuthenticationService!

    var emailTextField: UITextField = UITextField()
    var passwordTextField: UITextField = UITextField()

    public class func instance(with authService: AuthenticationService) -> LoginViewController {
        let viewController = LoginViewController()
        viewController.authService = authService
        return viewController
    }

    public func login() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        authService.login(email: email, password: password) { (result) in
            switch result{
            case .success(let (user, token)):
                print("Success: \(user.email) \(token.value)")
            case .failure(let error):
                print(error)
            }
        }
    }
}

let viewController = LoginViewController.instance(with: GoogleAuthenticatorAdapter())
viewController.emailTextField.text = "bhavesh@gmail.com"
viewController.passwordTextField.text = "12341324"
viewController.login()
