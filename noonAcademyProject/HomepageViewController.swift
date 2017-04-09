//
//  HomepageViewController.swift
//  noonAcademyProject
//
//  Created by Tuhin Samui on 04/04/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit

class HomepageViewController: UIViewController {

    @IBOutlet weak var subjectDetailsMainTableView: UITableView!
    @IBOutlet weak var homePageCustomNavigationBar: UINavigationBar!
    
    fileprivate lazy var subjectTableViewData: [[String: Any]] = [[:]]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        self.navigationController?.isNavigationBarHidden = true
        subjectDetailsMainTableView.register(UINib(nibName: "CommonTableCell", bundle: nil), forCellReuseIdentifier: "CellForAllTableView")
        subjectDetailsMainTableView.delegate = self
        subjectDetailsMainTableView.dataSource = self
        subjectDetailsMainTableView.tableFooterView = UIView(frame: CGRect.zero)
        subjectTableViewData.removeAll()
        for _ in 0...9{
            let dataForTableView: [String: Any] = ["subjectTitle": "English", "subjectDescription": "English Language", "subjectImage": UIImage()]
            subjectTableViewData.append(dataForTableView)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addMoreSubjectsToTheListButtonAction(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async (execute: {
            self.performSegue(withIdentifier: "gotoAddMoreSubjectFromHome", sender: sender)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case _ where segue.identifier == "gotoAddMoreSubjectFromHome":
            if let addMoreSubjectViewControllerObj = (segue.destination as? AddMoreSubjectsViewController){
                addMoreSubjectViewControllerObj.subjectDataSaveDelegate = self
            }
        default:
            break
        }
    }

}


extension HomepageViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.isSelected == true{
            cell.isSelected = true
            cell.contentView.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
        }else{
            cell.isSelected = false
            cell.contentView.backgroundColor = UIColor.white
        }
        
        if(tableView.responds(to: #selector(setter: UITableViewCell.separatorInset))) {
            tableView.separatorInset = UIEdgeInsets.zero
        }
        
        if(tableView.responds(to: #selector(setter: UIView.layoutMargins))) {
            tableView.layoutMargins = UIEdgeInsets.zero
        }
        
        if(cell.responds(to: #selector(setter: UIView.layoutMargins))) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let cell = tableView.cellForRow(at: indexPath){
                if cell.isSelected == true{
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.contentView.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
                    })
                }
            }
       
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            if let cell = tableView.cellForRow(at: indexPath){
                if cell.isSelected == false{
                    UIView.animate(withDuration: 0.2, animations: {
                        cell.contentView.backgroundColor = UIColor.white
                    })
                }
            }
    }
}



extension HomepageViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectTableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellForAllTableView", for: indexPath) as? CommonTableCell{
                cell.backgroundColor = UIColor.clear
                if let subjectTitleStringCheck = subjectTableViewData[indexPath.row]["subjectTitle"] as? String,
                    !subjectTitleStringCheck.isEmpty{
                    cell.titleForTheCell.text = subjectTitleStringCheck

                }else{
                    cell.titleForTheCell.text = "Subject Title Not Found!"
                }
                
                if let subjectDescriptionStringCheck = subjectTableViewData[indexPath.row]["subjectDescription"] as? String,
                    !subjectDescriptionStringCheck.isEmpty{
                    cell.subjectDescriptionLbl.text = subjectDescriptionStringCheck
                    
                }else{
                    cell.subjectDescriptionLbl.text = "Subject Description Not Found!"
                }
                
                
                if let subjectImageCheck = subjectTableViewData[indexPath.row]["subjectImage"] as? UIImage{
                        debugPrint("Image url found for this cell. Cen perform some lazy loading task on asynchronus process to load images. Which gives a dramatic speed of performance improvement!")
                        cell.imageForTheCell.image = subjectImageCheck
                    }else{
                        cell.imageForTheCell.image = nil
                        debugPrint("Image Url not found for this cell. Can load some placeholder image for this cell.")
                }
                
                cell.selectionStyle = .none
                return cell
            }else{
                
                
                
                return UITableViewCell()
            }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            tableView.beginUpdates()
            subjectTableViewData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            tableView.endUpdates()
            debugPrint("Cell deleted.")
            debugPrint("Can perform some nice animation stuff to reload the data!")
        }
    }
    
    
}

extension HomepageViewController: NewSubjectDataSaveDelegate{
    func sendDataBackHomePageViewController(dataToSave dataObject: [String : Any], isReloadTable reloadTableView: Bool) {
        if !dataObject.isEmpty{
            subjectTableViewData.insert(dataObject, at: 0)
            if reloadTableView == true{
                subjectDetailsMainTableView.reloadData()
            }
        }
    }
}
