//
//  AddMoreSubjectsViewController.swift
//  noonAcademyProject
//
//  Created by Tuhin Samui on 09/04/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit

class AddMoreSubjectsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelTheSubjectAndBackToPreviousViewControllerAction(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async (execute: {
            if let navigationControllerCheck = self.navigationController{
                navigationControllerCheck.popViewController(animated: true)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        })
    }


}
