//
//  SelfSizingTableView.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 22/12/2021.
//

import UIKit

class SelfSizingTableView: UITableView {
    
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height * 0.7
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(self.contentSize.height, self.maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}
