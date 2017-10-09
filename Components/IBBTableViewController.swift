//
//  IBBTableViewController.swift
//  IBBoost
//
//  Created by Jorge Pereira on 27/09/2017.
//

import Foundation
import UIKit

class IBBTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!

    var tableData: IBBTableViewModel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "IBBTableViewCell")
        
        self.loadData()
    }
    
    func loadData()
    {
        
    }
    
//MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return tableData.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableData.sectionForIndex(section).childrenCount()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let frame = tableView.frame
        let view = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 35))
        
        let title = UILabel(frame: CGRect(x: 15, y: 0, width: frame.size.width, height: 35))
        title.font = UIFont(name: "Lato-Regular", size: 13)
        title.textColor = UIColor(hexString: "#91a2bd")
        title.text = tableData.sectionForIndex(section).name.uppercased()
        view.addSubview(title)
        
        let sectionData = tableData.sections[section]
        
        if let headerView = sectionData.headerView
        {
            view.addSubview(headerView)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let sectionData = tableData.sections[section]
        
        guard let footer = sectionData.footer else {
            return nil
        }
        
        let text    = footer.text
        let height  = footer.height
        
        let footerView          = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: CGFloat(height)))
        
        let labelX : CGFloat    = 14
        let label               = UILabel(frame: CGRect(x: labelX, y: 0.0, width: footerView.frame.size.width - labelX * 2, height: footerView.frame.size.height))
        label.text              = text
        label.textColor         = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        label.numberOfLines     = 0
        
        if let font = UIFont(name: "Lato-Light", size: 13)
        {
            label.font  = font
        }
        
        footerView.addSubview(label)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        let sectionData = tableData.sections[section]

        guard let footer = sectionData.footer else {
            return 0.01
        }
        
        return CGFloat(footer.height)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if  let row = tableData.rowForIndexPath(indexPath),
            let cell = tableView.dequeueReusableCell(withIdentifier: "LYTableCell")
        {
            //Reset since we are reusing cells
            cell.accessoryType      = .none
            cell.accessoryView      = nil
            cell.textLabel?.text    = row.name
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            
            if let limage = row.leftImage
            {
                var frame = limage.frame
                cell.separatorInset = UIEdgeInsetsMake(0, frame.width + 26, 0, 0)
                frame.origin.x = 15
                frame.origin.y = (tableView.rowHeight - frame.height) * 0.5
                limage.frame = frame
                cell.addSubview(limage)
            }
            
            if let font = UIFont(name: "Lato-Light", size: row.textSize)
            {
                cell.textLabel?.font = font
            }
            
            if let backgroundColor = row.backgroundColor
            {
                cell.backgroundColor = backgroundColor
            }
            
            switch row.type
            {
                case .selector:
                    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                
                case .segue:
                    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                
                case .switch:
                    let rowSwitch           = row as! IBBTableViewRowSwitch
                    let uiswitch            = UISwitch()
                    uiswitch.addTarget(self, action: #selector(internalSwitchPressed(_:)), for:.valueChanged)
                    uiswitch.onTintColor    = rowSwitch.tintColor
                    uiswitch.isOn           = rowSwitch.isOn
                    cell.accessoryView      = uiswitch
                
                case .selection:
                    let rowSelection    = row as! IBBTableViewRowSelection
                    let imageName       = (rowSelection.isSelected) ? "knob-selection-full" : "knob-selection-empty"
                    let image           = UIImageView(image: UIImage(named: imageName))
                    cell.accessoryView  = image
                
                case .label:
                    let rowLabel    = row as! IBBTableViewRowLabel
                    let margin      = self.tableView.layoutMargins.left + self.tableView.layoutMargins.right
                    let font        = UIFont(name: "Lato-Light", size: 20)!
                    let size        = cell.textLabel!.text!.boundingRect(with: cell.frame.size,
                                                                                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                                attributes:[NSAttributedStringKey.font: font],
                                                                                context:nil).size

                    let viewWidth       = (self.view.frame.width - margin) - size.width
                    let viewHeight      = cell.frame.height
                    let view            = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
                    cell.accessoryView  = view
                    
                    if let labelText = rowLabel.value
                    {
                        let label               = UILabel(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
                        label.text              = labelText
                        label.textAlignment     = .right
                        label.font              = font
                        view.addSubview(label)
                    }
                    else {
                        let indicator = UIActivityIndicatorView(frame: CGRect(x: viewWidth - 20, y: 0, width: 20, height: viewHeight))
                        indicator.activityIndicatorViewStyle = .gray
                        indicator.startAnimating()
                        view.addSubview(indicator)
                    }
                
                case .accessory:
                    let rowAccessory    = row as! IBBTableViewRowAccessory
                    cell.accessoryView  = rowAccessory.view
                
                case .expandable:
                    //TODO:
                    break
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let row = tableData.rowForIndexPath(indexPath)
        {
            self.didSelectRow(row)
            
            switch row.type
            {
                case .selection:

                    if let cell = tableView.cellForRow(at: indexPath),
                       let parent = row.parent
                    {
                        for i in 0 ..< parent.children.count
                        {
                            if let child = parent.children[i] as? IBBTableViewRowSelection,
                               let childIndexPath = tableData.indexPathForRow(child),
                               let childCell = tableView.cellForRow(at: childIndexPath)
                            {
                                child.isSelected = false
                                childCell.accessoryView  = UIImageView(image: UIImage(named: "knob-selection-empty"))
                            }
                        }
                            
                        let aux = row as! IBBTableViewRowSelection
                        aux.isSelected = true
                        cell.accessoryView  = UIImageView(image: UIImage(named: "knob-selection-full"))
                        self.didChangeRowState(row)
                    }
                
                case .segue:
                    let aux = row as! IBBTableViewRowSegue
                    
                    if let segue = aux.segue
                    {
                        self.performSegue(withIdentifier: segue, sender: aux.userData)
                    }
            
                case .selector:
                    let aux = row as! IBBTableViewRowSelector
                    
                    if let selector = aux.selector
                    {
                        self.perform(Selector(selector))
                    }
                
            
                case .expandable:
                    self.expandRow(!row.isExpanded(), row: row, indexPath: indexPath)
            
                default:
                    break
            }
        }
    }

    //// Auxiliary method to expand row
    //
    fileprivate func expandRow(_ expand: Bool, row: IBBTableViewRow, indexPath: IndexPath)
    {
        if (row.children.count <= 0) || (expand == row.isExpanded())
        {
            return
        }
        
        tableView.beginUpdates()
        
        var array = [IndexPath]()
        
        if expand {
            
            row.setIsExpanded(true)
            
            for i in 1 ... row.childrenCount()
            {
                let index = IndexPath(row: indexPath.row + i, section: indexPath.section)
                array.append(index)
            }
            
            tableView.insertRows(at: array, with: UITableViewRowAnimation.top)
        }
        else {
            
            for i in 1 ... row.childrenCount()
            {
                let index = IndexPath(row: indexPath.row + i, section: indexPath.section)
                array.append(index)
            }
            
            row.setIsExpanded(false)
            
            tableView.deleteRows(at: array, with: UITableViewRowAnimation.top)
        }
        
//        let _ = tableView.cellForRowAtIndexPath(indexPath)
        
        tableView.endUpdates()
    }
    
    // Segue method
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        guard let aux_sender = sender as? Dictionary<String, Any> else {
            return
        }
        
        let selector    = Selector(aux_sender["selector"] as! String)
        let data        = aux_sender["data"]
        
        let svc = segue.destination
        svc.perform(selector, with: data)
    }
    
    // Called when a switch is pressed
    //
    @objc func internalSwitchPressed(_ sender: AnyObject!)
    {
        let uiswitch = sender as! UISwitch
        
        if let indexPath = self.tableView.indexPath(for: uiswitch.superview as! UITableViewCell),
           let row = tableData.rowForIndexPath(indexPath) as? IBBTableViewRowSwitch
        {
            row.isOn = uiswitch.isOn
            self.expandRow(row.isOn, row: row, indexPath: indexPath)
            self.didChangeRowState(row)
        }
    }

    // Override this if needed
    //
    func didChangeRowState(_ row: IBBTableViewRow)
    {

    }
    
    // Override this if needed
    //
    func didSelectRow(_ row: IBBTableViewRow)
    {
        
    }
}
