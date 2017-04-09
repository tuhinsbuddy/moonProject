//
//  DrawingCanvasViewController.swift
//  noonAcademyProject
//
//  Created by Tuhin Samui on 09/04/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit

class DrawingCanvasViewController: UIViewController {

    @IBOutlet weak var mainCanvasView: DrawingInCanvasViewClass!
    @IBOutlet weak var bottomSaveBtn: UIButton!
    @IBOutlet weak var bottomSaveBtnSuperView: UIView!
    weak var getImageFromCanvasDelegate: ImageFromCanvasSaveDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCanvasView.backgroundColor = UIColor.brown.withAlphaComponent(0.3)
        bottomSaveBtnSuperView.backgroundColor = UIColor.green
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAndbackToPreviousVieControllerAction(_ sender: UIBarButtonItem) {
        backToPreviousViewController()
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
    
    
    @IBAction func bottomSaveBtnAction(_ sender: UIButton) {
        mainCanvasView.renderToAnImageFromCanvas()
        if let finalImageFromCanvasCheck = mainCanvasView.finalImageFromCanvas{
            getImageFromCanvasDelegate?.sendDataBackToAddSubjectViewController(drawnImage: finalImageFromCanvasCheck)
        }
        backToPreviousViewController()
    }
    
    @IBAction func clearTheCanvasAction(_ sender: UIBarButtonItem) {
        mainCanvasView.clearTheCanvasAndReset()
    }
    
}

@objc protocol ImageFromCanvasSaveDelegate: class{
    func sendDataBackToAddSubjectViewController(drawnImage imageObject: UIImage)
}
