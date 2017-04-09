//
//  ViewController.swift
//  noonAcademyProject
//
//  Created by Tuhin Samui on 04/04/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    fileprivate lazy var appDelegateObjectToLoadPage = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var googleLoginBtnViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var loginViewControllerCustomNavigationBar: UINavigationBar!
    
    fileprivate lazy var layoutManagedProperly: Bool = false
    fileprivate lazy var loginBtnAnimationPerformed: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewControllerCustomNavigationBar.isHidden = true
//        var configureError: NSError?
//        GGLContext.sharedInstance().configureWithError(&configureError)
//        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        GIDSignIn.sharedInstance().clientID = ClassForFunctions.singleTonForFunctionClass.googleSignInClientId
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        self.view.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        makeLoginButtonAnimation(isViewDidLoad: true)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if layoutManagedProperly != true{
            layoutManagedProperly = true
            googleLoginBtnViewCenterY.constant += UIScreen.main.bounds.width
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if loginBtnAnimationPerformed != true{
            loginBtnAnimationPerformed = true
            makeLoginButtonAnimation(isViewDidLoad: false) //Simple animation for little nicer look!
        }
    }
    
    fileprivate func makeLoginButtonAnimation(isViewDidLoad viewDidLoadBool: Bool){
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.googleLoginBtnViewCenterY.constant = 0
            if viewDidLoadBool != true{ //This will prevent bad layout engine update while firing this animation on first time load of viewController into memory.
                self.view.layoutIfNeeded()
            }
        }, completion: { finished in
            if viewDidLoadBool == true{ //This will perform while animation is firing on first load.
                self.view.layoutIfNeeded()
            }
            debugPrint("Here we can perform another task like Chain of another animations!")
        })
        
    }
    
    fileprivate func createAndOpenSpecificViewController(storyBoardName nameString: String, identiferName identifierString: String) {
        let mainStoryboard = UIStoryboard(name: nameString, bundle: nil)
        var destinationViewController: UIViewController? = nil
        switch identifierString {
                    case _ where identifierString == "Home":
                        destinationViewController = mainStoryboard.instantiateViewController(withIdentifier: ClassForFunctions.singleTonForFunctionClass.homePageViewControllerIdentifierString) as? HomepageViewController
        default: break
        }
        
        if let destinationViewControllerCheck = destinationViewController,
            let windowObjectCheck = appDelegateObjectToLoadPage.window{
            let frontNavigationController = UINavigationController(rootViewController: destinationViewControllerCheck)
            if let snapShotViewCheck = self.view.snapshotView(afterScreenUpdates: true){
                destinationViewControllerCheck.view.addSubview(snapShotViewCheck)
                windowObjectCheck.rootViewController = frontNavigationController
                
                DispatchQueue.main.async(execute: { //Adding A small snapshot animation while changing login state to home page state upon a successful login.
                    UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                        snapShotViewCheck.layer.opacity = 0
                        snapShotViewCheck.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
                    }, completion: {finished in
                        snapShotViewCheck.removeFromSuperview()
                        windowObjectCheck.makeKeyAndVisible()
                    })
                })
            }else{
                windowObjectCheck.rootViewController = frontNavigationController
                windowObjectCheck.makeKeyAndVisible()
            }
        }
    }
    
    
}

extension LoginViewController: GIDSignInUIDelegate{
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        debugPrint(user)
        if error == nil{
            if let userNameToCheck = user.profile.name,
                !userNameToCheck.isEmpty,
                let userEmailId = user.profile.email,
                !userEmailId.isEmpty{
                UserDefaults.standard.set(userNameToCheck, forKey: "userNameFromGoogleSignin") //Storing Data Locally. Don't trust GIDSignIn.sharedInstance().hasAuthInKeychain()
                UserDefaults.standard.set(userEmailId, forKey: "userEmailIdFromGoogleSignin")
                if UserDefaults.standard.synchronize() == true{
                    debugPrint("Data Saved locally. Looks like a successful login")
                    createAndOpenSpecificViewController(storyBoardName: ClassForFunctions.singleTonForFunctionClass.mainStoryBoardNameToLoad, identiferName: "Home")

                }else{
                    debugPrint("Data not saved properly!. We can perform some error message task here.")
                    UserDefaults.standard.set(nil, forKey: "userNameFromGoogleSignin") //Setting nil values for locally stored data to ensure no duplicate or false positive!
                    UserDefaults.standard.set(nil, forKey: "userEmailIdFromGoogleSignin")
                }
            }else{
                UserDefaults.standard.set(nil, forKey: "userNameFromGoogleSignin") //Setting nil values for locally stored data to ensure no duplicate or false positive!
                UserDefaults.standard.set(nil, forKey: "userEmailIdFromGoogleSignin")
            }
            
            
            
            
            
            //            let userId = user.userID
            //            let idToken = user.authentication.idToken
            //            let fullName = user.profile.name
            //            let givenName = user.profile.givenName
            //            let familyName = user.profile.familyName
            //            let email = user.profile.email
            //            debugPrint("\(userId)\(idToken)\(fullName)\(givenName)\(familyName)\(email)")
            
        }else{
            debugPrint("Error Logging in \(error)")
            debugPrint("Not able to login!. We can perform some error message task here.")
        }
    }
}

