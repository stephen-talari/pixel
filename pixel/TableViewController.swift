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
        toolbarItems.append( UIBarButtonItem(barButtonSystemItem: .action , target: self, action: #selector(toolbarHandleShare) ))
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Delete Action
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.handleDeleteRow(indexPath: indexPath)
        }
        
        // Share Action
        let shareAction = UITableViewRowAction(style: .normal, title: "Share") { (action, IndexPath) in
            self.handleshareRow(indexPath: indexPath)
        }

        return [deleteAction, shareAction]
    }
    
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateNavigationTitle()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateNavigationTitle()
    }

    func updateNavigationTitle(){
        if let list = tableView.indexPathsForSelectedRows {
            self.navigationItem.title = "\(list.count) selected"
        }else{
            self.navigationItem.title = nil
        }
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
    
    
    func getSelectedNames() -> [String] {
        var names:[String] = []
        if let ipath = tableView.indexPathsForSelectedRows {
            for i in ipath {
                names.append(fruits[i.row])
            }
        }
        
        return names
    }
    
    func getSelectedIndexes() -> [Int]{
        var indexes:[Int] = []
        if let ipath = tableView.indexPathsForSelectedRows {
            for i in ipath {
                indexes.append(i.row)
            }
        }
        
        return indexes
    }
    
    // MARK: - Handle functions for ROW ACTION
    
    /**
     When delete button from toolbar is selected
     */
    func handleDeleteRow(indexPath:IndexPath){
        let name = self.fruits[indexPath.row]
        let deleteAlert = UIAlertController(title: "Delete fruit '\(name)'", message: nil, preferredStyle: .actionSheet)
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (UIAlertAction) in
            print("Deleting row")
            self.fruits.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.right )
            self.tableView.setEditing(false, animated: true)
        }))
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            print("cancelled deleting row")
            self.tableView.setEditing(false, animated: true)
        }))
        present(deleteAlert, animated: true, completion: nil)
    }
    
    /**
     When share button from row is selected
     */
    func handleshareRow(indexPath:IndexPath){
        let name = self.fruits[indexPath.row]
        let activityView:UIActivityViewController = UIActivityViewController(activityItems: [ name ], applicationActivities: nil)
        print("sharing \(name)")
        self.tableView.setEditing(false, animated: true)
        
        present(activityView, animated: true, completion: nil)
    }
    
    // MARK: - Handle functions for TOOLBAR ACTIONS
    
    /**
     When trash button from toolbar is selected
     */
    func toolbarHandleTrash(sender:UIBarButtonItem){
        
        if nil == self.tableView.indexPathsForSelectedRows?.count || 0 == self.tableView.indexPathsForSelectedRows?.count {
            print("Nothing to delete")
            return
        }
        
        let names = self.getSelectedNames()
        let deleteAlert = UIAlertController(title: "Delete \(names.count) fruits?", message: "Deleting \(names.joined(separator: ","))", preferredStyle: .actionSheet)
        
        // Delete action
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (UIAlertAction) in
            print("ok. deleting selected...")
            let indexes = self.getSelectedIndexes()
            //begin
            self.tableView.beginUpdates()
            
            self.tableView.deleteRows(at: self.tableView.indexPathsForSelectedRows!, with: .right)
            self.fruits = self.fruits
                .enumerated()
                .filter { !indexes.contains($0.offset) }
                .map { $0.element }
            //end
            self.tableView.endUpdates()
            
            self.updateNavigationTitle()
            
        }))
        
        // Cancel action
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            //use this block to handle cancel
        }))
        
        present(deleteAlert, animated: false, completion: nil)
    }
    
    /**
     When share button from toolbar is selected
    */
    func toolbarHandleShare(sender:UIBarButtonItem){
        
        if nil == self.tableView.indexPathsForSelectedRows?.count || 0 == self.tableView.indexPathsForSelectedRows?.count {
            print("Nothing to share")
            return
        }
        let names = self.getSelectedNames()
        let activityView:UIActivityViewController = UIActivityViewController(activityItems: [ names.joined(separator: ",") ], applicationActivities: nil)
        
        activityView.completionWithItemsHandler = {
            (activityType, completed, returnedItems, activityError) in

            //print("Completed: \(completed) Items: \(returnedItems) Error: \(activityError)")
            
            if completed {
                self.tableView.setEditing(false, animated: true)
            }
            self.updateNavigationTitle()
        }
        
        present(activityView, animated: true, completion: nil)
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
