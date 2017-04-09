//
//  AddMoreSubjectsViewController.swift
//  noonAcademyProject
//
//  Created by Tuhin Samui on 09/04/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit

class AddMoreSubjectsViewController: UIViewController {

    @IBOutlet weak var subjectAddErrorLbl: UILabel!
    @IBOutlet weak var addNewSubjectCustomNavBar: UINavigationBar!
    @IBOutlet weak var addNewSubjectSelectNewImageSuperView: UIView!
    
    @IBOutlet weak var addNewSubjectSelectNewImageViewSuperView: UIView!
    @IBOutlet weak var addNewSubjectSelectNewImageView: UIImageView!
    @IBOutlet weak var addNewSubjectSelectNewImageBtn: UIButton!
    
    @IBOutlet weak var addNewSubjectTitleSuperView: UIView!
    @IBOutlet weak var addNewSubjectTitleTxtLbl: UILabel!
    @IBOutlet weak var addNewSubjectTitleTxtField: UITextField!
    
    @IBOutlet weak var addNewSubjectDescriptionSuperView: UIView!
    @IBOutlet weak var addNewSubjectDescriptionTxtLbl: UILabel!
    @IBOutlet weak var addNewSubjectDescriptionTxtField: UITextField!
    
    @IBOutlet weak var addNewSubjectBottomSaveBtnSuperView: UIView!
    @IBOutlet weak var addNewSubjectBottomSaveBtn: UIButton!
    
    fileprivate lazy var imagePickerForSubject = UIImagePickerController()
    fileprivate lazy var layoutManagedProperly: Bool = false

    fileprivate lazy var subjectTitleName: String = ""
    fileprivate lazy var subjectDescription: String = ""
    fileprivate lazy var imageObjectToShow: UIImage = UIImage()
    fileprivate lazy var subjectDataToSave: [String: Any] = [:]
    
    weak var subjectDataSaveDelegate: NewSubjectDataSaveDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectAddErrorLbl.text = nil
        imagePickerForSubject.delegate = self
        addNewSubjectTitleTxtField.delegate = self
        addNewSubjectDescriptionTxtField.delegate = self
        addNewSubjectSelectNewImageViewSuperView.backgroundColor = UIColor.green.withAlphaComponent(0.6)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if layoutManagedProperly != true{
            layoutManagedProperly = true
            addNewSubjectSelectNewImageViewSuperView.layer.cornerRadius = 50
            addNewSubjectSelectNewImageViewSuperView.clipsToBounds = true
        }
    }
    
    @IBAction func addNewSubjectSelectNewImageBtnAction(_ sender: UIButton) {
        imagePickerForSubject.allowsEditing = false
        imagePickerForSubject.sourceType = .photoLibrary //Can check here for the availability of camera like front facing or rear.
        DispatchQueue.main.async (execute: {
            self.present(self.imagePickerForSubject, animated: true, completion: nil)
        })

    }
    
    @IBAction func addNewSubjectBottomSaveBtnAction(_ sender: UIButton) {
    
        if !subjectTitleName.isEmpty && !subjectDescription.isEmpty{
            subjectDataToSave = ["subjectTitle": subjectTitleName, "subjectDescription": subjectDescription, "subjectImage": imageObjectToShow]
            subjectDataSaveDelegate?.sendDataBackHomePageViewController(dataToSave: subjectDataToSave, isReloadTable: true)
            backToPreviousViewController()
        }else if subjectTitleName.isEmpty{
            subjectAddErrorLbl.text = "Subject Title Can not be empty"
        }else if subjectDescription.isEmpty{
            subjectAddErrorLbl.text = "Subject Description Can not be empty"
        }
    
    }
    
    fileprivate func backToPreviousViewController(){
        DispatchQueue.main.async (execute: {
            if let navigationControllerCheck = self.navigationController{
                navigationControllerCheck.popViewController(animated: true)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    
    @IBAction func cancelTheSubjectAndBackToPreviousViewControllerAction(_ sender: UIBarButtonItem) {
        backToPreviousViewController()
    }
    
}


extension AddMoreSubjectsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: { void in
            debugPrint("Perform Error task that user has nt choosed any image")
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageThatChoosed = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addNewSubjectSelectNewImageView.contentMode = .scaleToFill
            addNewSubjectSelectNewImageView.image = imageThatChoosed
            imageObjectToShow = imageThatChoosed
            debugPrint("Image selected. Can perform some upload task from here in async. mode!")
        }
        dismiss(animated: true, completion: {Void in
            debugPrint("Image successfully choosed. Can perform some user notification task!")
        })
    }
}

extension AddMoreSubjectsViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        switch textField{
//        case _ where textField == addNewSubjectTitleTxtField:
//            if let enteredSubjectTitleCheck = textField.text,
//                !enteredSubjectTitleCheck.isEmpty{
//                subjectTitleName = enteredSubjectTitleCheck
//                subjectAddErrorLbl.text = nil
//            }else{
//                debugPrint("Subject Title is empty!")
//                subjectTitleName.removeAll()
//            }
//            
//            
//        case _ where textField == addNewSubjectDescriptionTxtField:
//            if let enteredSubjectDescriptionCheck = textField.text,
//                !enteredSubjectDescriptionCheck.isEmpty{
//                subjectDescription = enteredSubjectDescriptionCheck
//                subjectAddErrorLbl.text = nil
//            }else{
//                debugPrint("Subject Description is empty!")
//                subjectDescription.removeAll()
//            }
//        default :
//            break
//            
//        }
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField{
        case _ where textField == addNewSubjectTitleTxtField:
            if let enteredSubjectTitleCheck = textField.text,
                !enteredSubjectTitleCheck.isEmpty{
                subjectTitleName = enteredSubjectTitleCheck
                subjectAddErrorLbl.text = nil
            }else{
                debugPrint("Subject Title is empty!")
                subjectTitleName.removeAll()
            }
            
            
        case _ where textField == addNewSubjectDescriptionTxtField:
            if let enteredSubjectDescriptionCheck = textField.text,
                !enteredSubjectDescriptionCheck.isEmpty{
                subjectDescription = enteredSubjectDescriptionCheck
                subjectAddErrorLbl.text = nil
            }else{
                debugPrint("Subject Description is empty!")
                subjectDescription.removeAll()
            }
        default :
            break
            
        }
        
        return true
    }
    
}



@objc protocol NewSubjectDataSaveDelegate: class{
    func sendDataBackHomePageViewController(dataToSave dataObject: [String: Any], isReloadTable reloadTableView: Bool)
}
