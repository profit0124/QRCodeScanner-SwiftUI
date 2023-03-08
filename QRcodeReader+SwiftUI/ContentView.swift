//
//  ContentView.swift
//  QRcodeReader+SwiftUI
//
//  Created by Sooik Kim on 2023/03/06.
//

import SwiftUI

struct ContentView: View {
    
    @GestureState var press = false
    @State var isOn = false
    
    var body: some View {
        VStack {
            // Press 상태를 고려하여 QR Scanner 영역의 변화를 준다.
            if isOn {
                QRCodeReaderViewRepresentable()
            } else {
                Spacer()
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 200, height: 200)
            }
            Spacer()
            // Button 영역
            VStack {
                Image(systemName: "camera.shutter.button.fill")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("누르고 QR")
            }
            // 지속적인 제스쳐를 인식
            .simultaneousGesture(
                // DragGesuter를 통해 누르고 있음을 감지
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        if !isOn {
                            isOn = true
                        }
                    })
                    .onEnded({ _ in
                        isOn = false
                        
                    })
            )
        }
        .padding(.bottom, 32)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
