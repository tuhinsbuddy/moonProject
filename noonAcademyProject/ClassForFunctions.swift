//
//  ClassForFunctions.swift
//  noonAcademyProject
//
//  Created by Tuhin Samui on 04/04/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit

class ClassForFunctions: NSObject {

    static let singleTonForFunctionClass = ClassForFunctions() //Making Sure only one instance would be loaded into the memory.

    let mainStoryBoardNameToLoad: String = "NoonAcademy"
    let loginViewControllerIdentifierString: String = "loginViewController"
    let homePageViewControllerIdentifierString: String = "homePageViewController"
    
    let googleSignInClientId: String = "263604908138-2159oeoqs23fl4f48cnr41vv5edesi2o.apps.googleusercontent.com"

}
