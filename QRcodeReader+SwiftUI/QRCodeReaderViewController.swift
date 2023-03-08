//
//  QRCodeReaderViewController.swift
//  QRcodeReader+SwiftUI
//
//  Created by Sooik Kim on 2023/03/08.
//

import UIKit
import AVFoundation

class QRCodeReaderViewController: UIViewController {
    
    private let captureSession = AVCaptureSession()
    private let width = UIScreen.main.bounds.width - 32
    
    private var labelView : UILabel = {
        let view = UILabel(frame: .zero)
        view.backgroundColor = .black
        view.font = .systemFont(ofSize: 20)
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settting()
        settingLabel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        captureSession.stopRunning()
    }
    
    private func settting() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            fatalError("No Video")
        }
        do {
            // QR코드를 인식할 영역 값
            let rectOfInterest = CGRect(x: (UIScreen.main.bounds.width - 200) / 2 , y: (view.bounds.height - width * 1.4) / 2 + 100 , width: 200, height: 200)
            
            // cameraDevice를 설정하여 AVCaptureSEssion에 input 으로 추가
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            // Input으로 들어온 데이터를 metadata로 출력하기 위해 AVCapturMetadataOutput 을 세션에 추가
            let output = AVCaptureMetadataOutput()
            captureSession.addOutput(output)
            
            // 메타데이터를 읽을 때 동작할 델리게이트 붙여주기
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            // 메타데이터의 타입 설정, humanBody, dogBody, face 등등 다양하게 있음
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            let rectConverted = setVideoLayer(rectOfInterest: rectOfInterest)
            
            // QR코드 인식 영역 설정
            output.rectOfInterest = rectConverted
            
            // QR코드 인식 영역 프레임 그리기
            setGuideCrossLineView(rectOfInterest: rectOfInterest)
            
            // session 은 background thread 에서 동작해야 하여 GCD를 이용하여 background qod thread 에서 동작할 수 있도록....
            DispatchQueue.global(qos: .background).async {
                self.captureSession.startRunning()
            }
            
        } catch {
            print("error")
        }
        
        
    }

    
    private func setVideoLayer(rectOfInterest: CGRect) -> CGRect {
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.frame = CGRect(x: (view.bounds.width / 2) - (width / 2), y: (view.bounds.height / 2) - (width), width: width, height: width * 1.4)
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(videoLayer)
        // AVCaptureVideoPreviewLayer 에서 제공하는 metadataOutputRectConverted를 활용하여 내가 원하는 영역의 값을 리턴
        return videoLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }
    // 출처 : https://gyuios.tistory.com/79
    private func setGuideCrossLineView(rectOfInterest: CGRect) {
            // 생략된 코드는 + 모양 가이드라인 추가 코드이다.
            // ...
            
            let cornerLength: CGFloat = 20
            let cornerLineWidth: CGFloat = 5
            
            // ✅ 가이드라인의 각 모서리 point
            let upperLeftPoint = CGPoint(x: rectOfInterest.minX, y: rectOfInterest.minY)
            let upperRightPoint = CGPoint(x: rectOfInterest.maxX, y: rectOfInterest.minY)
            let lowerRightPoint = CGPoint(x: rectOfInterest.maxX, y: rectOfInterest.maxY)
            let lowerLeftPoint = CGPoint(x: rectOfInterest.minX, y: rectOfInterest.maxY)
            
            // ✅ 각 모서리를 중심으로 한 Edge를 그림.
            let upperLeftCorner = UIBezierPath()
            upperLeftCorner.lineWidth = cornerLineWidth
            upperLeftCorner.move(to: CGPoint(x: upperLeftPoint.x + cornerLength, y: upperLeftPoint.y))
            upperLeftCorner.addLine(to: CGPoint(x: upperLeftPoint.x, y: upperLeftPoint.y))
            upperLeftCorner.addLine(to: CGPoint(x: upperLeftPoint.x, y: upperLeftPoint.y + cornerLength))
            
            let upperRightCorner = UIBezierPath()
            upperRightCorner.lineWidth = cornerLineWidth
            upperRightCorner.move(to: CGPoint(x: upperRightPoint.x - cornerLength, y: upperRightPoint.y))
            upperRightCorner.addLine(to: CGPoint(x: upperRightPoint.x, y: upperRightPoint.y))
            upperRightCorner.addLine(to: CGPoint(x: upperRightPoint.x, y: upperRightPoint.y + cornerLength))
            
            let lowerRightCorner = UIBezierPath()
            lowerRightCorner.lineWidth = cornerLineWidth
            lowerRightCorner.move(to: CGPoint(x: lowerRightPoint.x, y: lowerRightPoint.y - cornerLength))
            lowerRightCorner.addLine(to: CGPoint(x: lowerRightPoint.x, y: lowerRightPoint.y))
            lowerRightCorner.addLine(to: CGPoint(x: lowerRightPoint.x - cornerLength, y: lowerRightPoint.y))
            
            let lowerLeftCorner = UIBezierPath()
            lowerLeftCorner.lineWidth = cornerLineWidth
            lowerLeftCorner.move(to: CGPoint(x: lowerLeftPoint.x + cornerLength, y: lowerLeftPoint.y))
            lowerLeftCorner.addLine(to: CGPoint(x: lowerLeftPoint.x, y: lowerLeftPoint.y))
            lowerLeftCorner.addLine(to: CGPoint(x: lowerLeftPoint.x, y: lowerLeftPoint.y - cornerLength))
            
            upperLeftCorner.stroke()
            upperRightCorner.stroke()
            lowerRightCorner.stroke()
            lowerLeftCorner.stroke()
            
            // ✅ layer 에 추가
            
            let upperLeftCornerLayer = CAShapeLayer()
            upperLeftCornerLayer.path = upperLeftCorner.cgPath
            upperLeftCornerLayer.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
            upperLeftCornerLayer.fillColor = UIColor.clear.cgColor
            upperLeftCornerLayer.lineWidth = cornerLineWidth
            
            let upperRightCornerLayer = CAShapeLayer()
            upperRightCornerLayer.path = upperRightCorner.cgPath
            upperRightCornerLayer.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
            upperRightCornerLayer.fillColor = UIColor.clear.cgColor
            upperRightCornerLayer.lineWidth = cornerLineWidth
            
            let lowerRightCornerLayer = CAShapeLayer()
            lowerRightCornerLayer.path = lowerRightCorner.cgPath
            lowerRightCornerLayer.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
            lowerRightCornerLayer.fillColor = UIColor.clear.cgColor
            lowerRightCornerLayer.lineWidth = cornerLineWidth
     
            let lowerLeftCornerLayer = CAShapeLayer()
            lowerLeftCornerLayer.path = lowerLeftCorner.cgPath
            lowerLeftCornerLayer.strokeColor = UIColor.black.withAlphaComponent(0.5).cgColor
            lowerLeftCornerLayer.fillColor = UIColor.clear.cgColor
            lowerLeftCornerLayer.lineWidth = cornerLineWidth
            
            view.layer.addSublayer(upperLeftCornerLayer)
            view.layer.addSublayer(upperRightCornerLayer)
            view.layer.addSublayer(lowerRightCornerLayer)
            view.layer.addSublayer(lowerLeftCornerLayer)
        }
    
    
    private func settingLabel() {
        view.addSubview(labelView)
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: view.topAnchor),
            labelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            labelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            labelView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        labelView.text = "아직 스캔 시작 전"
    }

}

extension QRCodeReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else {
                return
            }
            // URL 주소의 QR 코드 값이 읽힐 때만 Label 변경
            if stringValue.hasPrefix("http://") || stringValue.hasPrefix("https://")  {
                labelView.text = stringValue
            }
        }
    }
}
