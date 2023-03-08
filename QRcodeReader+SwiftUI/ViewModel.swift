//
//  DateModel.swift
//  QRcodeReader+SwiftUI
//
//  Created by Sooik Kim on 2023/03/08.
//

import Foundation


class Model: ObservableObject {
    @Published private var title: String = ""
    
    func settingValue(title: String) {
        self.title = title
    }
}
