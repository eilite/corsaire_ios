//
//  Extensions.swift
//  Corsaire
//
//  Created by Elie on 14/05/2016.
//  Copyright © 2016 Elie. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}