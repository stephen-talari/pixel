//
//  TableViewController.swift
//  pixel
//
//  Created by stephen talari on 02/12/16.
//  Copyright © 2016 stephen talari. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController,UIGestureRecognizerDelegate {

    var fruits:[String] = ["Apple","Apricot","Avocado","Banana","Bilberry","Blackberry","Blackcurrant","Blueberry","Boysenberry","Currant","Cherry","Cherimoya","Cloudberry","Coconut","Cranberry","Cucumber","Custard apple","Damson","Date","Decaisnea Fargesii","Dragonfruit","Durian","Elderberry","Feijoa","Fig","Goji berry","Gooseberry","Grape","Raisin","Grapefruit","Guava","Honeyberry","Huckleberry","Jabuticaba","Jackfruit","Jambul","Jujube","Juniper berry","Kiwifruit","Kumquat","Lemon","Lime","Loquat","Longan","Lychee","Mango","Marionberry","Melon","Cantaloupe","Honeydew","Watermelon","Miracle fruit","Mulberry","Nectarine","Nance","Olive","Orange","Blood orange","Clementine","Mandarine","Tangerine","Papaya","Passionfruit","Peach","Pear","Persimmon","Physalis","Plantain","Plum","Prune (dried plum)","Pineapple","Plumcot (or Pluot)","Pomegranate","Pomelo","Purple mangosteen","Quince","Raspberry","Salmonberry","Rambutan","Redcurrant","Salal berry","Salak","Satsuma","Star fruit","Strawberry","Tamarillo","Tamarind","Tomato","Ugli fruit","Yuzu"]
    
    var longPressRecog:UILongPressGestureRecognizer!
    var selectedRowCount:Int = 0
    var selectedFruits:[String]!
    var selectedIndexes:[Int]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.allowsSelection = false
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem?.title = "Select Fruits"
        
        var toolbarItems:[UIBarButtonItem] = []
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        fixedSpace.width = 10.0
        
        toolbarItems.append( UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(toolbarHandleTrash) ))
        toolbarItems.append( fixedSpace )
        toolbarItems.append( UIBarButtonItem(barButtonSystemItem: .action , target: self, action: #selector(toolbarHandleAction) ))
        self.setToolbarItems(toolbarItems, animated: false)
        
        // Long press recognizer
        longPressRecog = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress) )
        longPressRecog.delegate = self
        
        self.tableView.addGestureRecognizer(longPressRecog)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fruits.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Configure the cell...
        cell.textLabel?.text = fruits[indexPath.row]
        
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        
        if editing {
            self.tableView.removeGestureRecognizer(longPressRecog)
            
            self.navigationItem.rightBarButtonItem?.title = "Done"
            self.navigationItem.rightBarButtonItem?.style = .done
            
            self.navigationController?.setToolbarHidden(false, animated: false)
        }
        else {
            self.tableView.addGestureRecognizer(longPressRecog)
            
            self.navigationItem.rightBarButtonItem?.title = "Select Fruits"
            self.navigationItem.rightBarButtonItem?.style = .plain
            
            self.navigationController?.setToolbarHidden(true, animated: false)
            self.navigationItem.title = nil
            
        }
        
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let itemToMove:String = fruits[fromIndexPath.row]
        fruits.remove(at: fromIndexPath.row)
        fruits.insert(itemToMove, at: to.row)
    }
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateSelectedRowsCount()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateSelectedRowsCount()
    }

    func updateSelectedRowsCount(){
        if let list = tableView.indexPathsForSelectedRows {
            selectedRowCount = list.count
            self.navigationItem.title = "\(list.count) selected"
        }else{
            selectedRowCount = 0
            self.navigationItem.title = nil
        }
    }
    
    func updateSelectedFruitNames() {
        selectedFruits = []
        selectedIndexes = []
        if let ipath = tableView.indexPathsForSelectedRows {
            for i in ipath {
                if let cell = tableView.cellForRow(at: i) {
                    selectedFruits.append((cell.textLabel?.text!)!)
                    selectedIndexes.append(i.row)
                }
            }
        }
        
        //print(selectedFruits)
        //print(selectedIndexes)
    }
    
    // MARK: - Selector Functions
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            return
        }
        
        self.setEditing(true, animated: false)
        //let  p = gestureReconizer.location(in: self.tableView)
        //let indexPath = self.tableView.indexPathForRow(at: p)
    }
    
    func toolbarHandleTrash(sender:UIBarButtonItem){
        
        if self.selectedRowCount <= 0 {
            print("Nothing to delete")
            return
        }
        
        updateSelectedFruitNames()
        
        let deleteAlert = UIAlertController(title: "Delete fruits?", message: "Deleting \(selectedFruits.joined(separator: ","))", preferredStyle: .actionSheet)
        
        // Delete action
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (UIAlertAction) in
            
            print("ok. deleting...")
            
            //begin
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: self.tableView.indexPathsForSelectedRows!, with: .right)
            self.fruits = self.fruits
                .enumerated()
                .filter { !self.selectedIndexes.contains($0.offset) }
                .map { $0.element }
            //end
            self.tableView.endUpdates()
            
            self.updateSelectedRowsCount()
            self.updateSelectedFruitNames()
            
            
            
        }))
        
        // Cancel action
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            print("cancelled")
        }))
        
        present(deleteAlert, animated: false, completion: nil)
    }
    
    func toolbarHandleAction(sender:UIBarButtonItem){
        print("About to share")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
