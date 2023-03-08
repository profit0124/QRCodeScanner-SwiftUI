//
//  QRCodeReaderViewRepresentable.swift
//  QRcodeReader+SwiftUI
//
//  Created by Sooik Kim on 2023/03/08.
//

import SwiftUI

struct QRCodeReaderViewRepresentable: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = QRCodeReaderViewController
    
    func makeUIViewController(context: Context) -> QRCodeReaderViewController {
        let qr = QRCodeReaderViewController()
        return qr
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct QRCodeReaderViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeReaderViewRepresentable()
    }
}
