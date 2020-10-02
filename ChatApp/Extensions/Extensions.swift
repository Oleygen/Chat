//
//  Extensions.swift
//  ChatApp
//
//  Created by Den on 2020-09-30.
//  Copyright © 2020 Den. All rights reserved.
//

import UIKit
import NaturalLanguage

extension UIView {
    func setBorder() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemBlue.cgColor
    }
}

extension UITableView {
    func scrollToBottomRow() {
        DispatchQueue.main.async {
            guard self.numberOfSections > 0 else { return }
            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)
            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)
                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }
            guard self.indexPathIsValid(indexPath) else { return }
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
    }
}

extension String {
    var isCyrillic: Bool {
        let regex = try! NSRegularExpression(pattern: "[^А-Яа-я]")
        let range = NSRange(location: 0, length: self.utf16.count)
        return regex.firstMatch(in: self, options: [], range: range) == nil
    }
}
