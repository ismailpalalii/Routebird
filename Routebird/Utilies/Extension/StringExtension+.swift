//
//  StringExtension+.swift
//  Routebird
//
//  Created by İsmail Palalı on 14.06.2025.
//

import Foundation

extension String {
    /// `NSLocalizedString` example: `"start".localized`
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    /// example: `"start".localizedFormat("Start")`
    func localizedFormat(_ arguments: CVarArg...) -> String {
        String(format: self.localized, arguments: arguments)
    }
}
