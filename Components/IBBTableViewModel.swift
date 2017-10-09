//
//  IBBTableViewModel.swift
//  IBBoost
//
//  Created by Jorge Pereira on 27/09/2017.
//

import UIKit

enum IBBTableViewRowType
{
    case selection		//- Selects a single row only
    case `switch`         //- has UISwitch on right side
    case segue			//- calls a segue when pressing a row
    case selector       //- calls a selector when pressing a row
    case expandable     //-
    case label          //- has a UILabel on right side
    case accessory      //- allows to customize accessory view
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class IBBTableViewRowAccessory : IBBTableViewRow
{
    var view: UIView?
    
    init(id: Int, name: String, view: UIView? = nil)
    {
        self.view = view
        
        super.init(id: id, name: name, type: .accessory)
    }
}

class IBBTableViewRowLabel : IBBTableViewRow
{
    var value : String?
    
    init(id: Int, name: String, value: String? = nil)
    {
        self.value = value
        
        super.init(id: id, name: name, type: .label)
    }
}

class IBBTableViewRowSelection : IBBTableViewRow
{
    var isSelected: Bool
    
    init(id: Int, name: String, isSelected: Bool = false)
    {
        self.isSelected = isSelected
        
        super.init(id: id, name: name, type: .selection)
    }
}

class IBBTableViewRowSwitch : IBBTableViewRow
{
    var isOn: Bool
    var tintColor: UIColor?
    
    init(id: Int, name: String, isOn: Bool = true, tintColor: UIColor? = nil)
    {
        self.isOn = isOn
        self.tintColor = tintColor
        
        super.init(id: id, name: name, type: .switch)
        
        self.hasChildren = isOn
    }
}

class IBBTableViewRowSegue : IBBTableViewRow
{
    var segue: String?
    var userData: AnyObject?
    
    init(id: Int, name: String, segue: String? = nil, userData: AnyObject? = nil)
    {
        self.segue      = segue
        self.userData   = userData
        
        super.init(id: id, name: name, type: .segue)
    }
}

class IBBTableViewRowSelector : IBBTableViewRow
{
    var selector: String?
    
    init(id: Int, name: String, selector: String! = nil)
    {
        self.selector = selector
        
        super.init(id: id, name: name, type: .selector)
    }
}

class IBBTableViewRowExpandable : IBBTableViewRow
{
    init(id: Int, name: String)
    {
        super.init(id: id, name: name, type: .expandable)
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class IBBTableViewSectionFooter
{
    var text: String
    var height: Int
    
    init(text: String, height: Int)
    {
        self.text   = text
        self.height = height
    }
}

class IBBTableViewRow: IBBTableViewItem
{
    var name: String
    var type: IBBTableViewRowType
    
    // optionals
    var backgroundColor: UIColor?
    var textSize: CGFloat = 20
    var leftImage: UIImageView?
    
    init(id: Int, name: String, type: IBBTableViewRowType)
    {
        self.name       = name
        self.type       = type
        super.init(id: id)
    }
    
    func addRow(_ row: IBBTableViewRow)
    {
        self.addChild(row)
    }
    
    func isExpanded() -> Bool
    {
        return self.hasChildren
    }
    
    func setIsExpanded(_ value: Bool)
    {
        self.hasChildren = value
    }
}

class IBBTableViewSection : IBBTableViewItem
{
    var name: String
    var footer: IBBTableViewSectionFooter?
    var headerView: UIView?
    
    init(id: Int, name: String = "")
    {
        self.name = name
        
        super.init(id: id)
        
        self.hasChildren = true
    }
    
    func addRow(_ row: IBBTableViewRow)
    {
        self.addChild(row)
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class IBBTableViewItem
{
    var children: [IBBTableViewItem]  = []
    var parent: IBBTableViewItem?
    
    var id: Int
    fileprivate var _hasChildren : Bool = false
    fileprivate var hasChildren : Bool {
        get {
            return _hasChildren && (children.count > 0)
        }
        set {
            _hasChildren = newValue
        }
    }

    init(id: Int)
    {
        self.id = id
    }
    
    fileprivate func addChild(_ item: IBBTableViewItem)
    {
        item.parent = self
        children.append(item)
    }

    func childForIndex(_ index: Int) -> IBBTableViewItem?
    {
//        Log.print("id: \(self.id) index: [\(index)]")
        
        let hasParent = (parent != nil)
        
        if hasParent && index == 0
        {
            return self
        }
        
        if self.hasChildren
        {
            var previousCount = 0
            
            for i in 0 ..< self.children.count
            {
                let offset = hasParent ? 1 : 0
                
                if let child = children[i].childForIndex(index - i - offset - previousCount)
                {
                    return child
                }
            
                previousCount += children[i].childrenCount()
            }
        }
        
        return nil
    }
    
    func childForId(_ id: Int) -> IBBTableViewItem?
    {
        for child in self.children
        {
            if child.id == id
            {
                return child
            }
            
            if let child = child.childForId(id)
            {
                return child
            }
        }
        
        return nil
    }
    
    func childrenCount() -> Int
    {
        var count = 0
        
        if self.hasChildren
        {
            for child in self.children
            {
                count += 1 + child.childrenCount()
            }
        }
        
        return count
    }
}

class IBBTableViewModel
{
    var sections: [IBBTableViewSection] = []
    var name: String!
    
    init(name: String)
    {
        self.name   = name
    }
    
    func addSection(_ section: IBBTableViewSection)
    {
        self.sections.append(section)
    }
    
    func removeSectionForId(_ id: Int)
    {
        var indexToRemove: Int?
        
        for i in 0 ..< sections.count
        {
            if sections[i].id == id
            {
                indexToRemove = i
            }
        }
        
        if let index = indexToRemove
        {
            self.sections.remove(at: index)
        }
    }
    
    func sectionForIndex(_ index: Int) -> IBBTableViewSection
    {
        return sections[index]
    }
    
    func rowForIndexPath(_ indexPath: IndexPath) -> IBBTableViewRow?
    {
        if let row = self.sectionForIndex(indexPath.section).childForIndex(indexPath.row) as? IBBTableViewRow
        {
            return row
        }
        
        return nil
    }
    
    func indexPathForRow(_ row: IBBTableViewRow) -> IndexPath?
    {
        for i in 0 ..< sections.count
        {
            for j in 0 ..< sections[i].childrenCount()
            {
                if let child = sections[i].childForIndex(j), child.id == row.id
                {
                    return IndexPath(row: j, section: i)
                }
            }
        }
        
        return nil
    }
    
    func rowForId(_ id: Int) -> IBBTableViewRow?
    {
        for section in sections
        {
            if let row = section.childForId(id) as? IBBTableViewRow
            {
                return row
            }
        }
        
        return nil
    }
}
