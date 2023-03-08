## QRCodeScanner-SwiftUI

> AVFoundation 과 UIKit, SwiftUI 를 활용한 QRCode Scanner 입니다.
> 기본적으로 Info.plist 를 통한 camera 접근권한 설정은 필수 입니다.


1. ViewController 를 활용하여 AVCapturSession 을 만들고 cameraPreview 와 Label (QRCode 에서 인식한 URL 표시용) 을 설정
2. UIViewController 를 Switf View로 만들어 줄 수 있는 UIViewControllerRepresentable protocol 을 사용하는 SwiftUI 파일 생성
3. 생성된 SwiftUI 을 ContentView에 선언
4. 생선된 SwiftUI 는 이미지를 Long Press 를 유지할 때만 노출되도록 설정(개인 취향)

<pre>
<code>
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
        
</code>
</pre>

<pre>
<code>
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
</code>
</pre>


<pre>
<code>
struct QRCodeReaderViewRepresentable: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = QRCodeReaderViewController
    
    func makeUIViewController(context: Context) -> QRCodeReaderViewController {
        let qr = QRCodeReaderViewController()
        return qr
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
</code>
</pre>
