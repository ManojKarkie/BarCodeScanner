//
//  QRCodeScannerViewController.swift
//  IMEPayWallet
//
//  Created by Manoj Karki on 6/6/16.
//  Copyright © 2017 imedigital All rights reserved.
//

import AVFoundation
import CryptoSwift

class BarCodeScannerViewController: BaseViewController, StoryboardInitializable {

    //MARK:- Overlay

    @IBOutlet weak var overlayView: OverlayView!
    
    @IBOutlet weak var flashToggleButton: UIButton!
    @IBOutlet weak var instructionLabel : UILabel!
    @IBOutlet weak var scanFromPhotoBtn: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var myQRCodeBtn: UIButton!

    //MARK:- States

    fileprivate var sessionQueue = DispatchQueue(label: "SESSION_QUEUE")

    fileprivate var captureSession: AVCaptureSession?

    fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    fileprivate var isFlash = false
    
    fileprivate let audioManager = AudioManager()
    
//    lazy var imagePicker: ImagePickerHelper =  {
//
//        let picker =  ImagePickerHelper.init(with: .photoGallery, parent: self)
//        picker.onPickerDidPickedImage = {
//            self.decodeImage(image: $0)
//        }
//        return picker
//    }()

    //MARK:- Code Types

    fileprivate lazy var supportedCodeTypes: [AVMetadataObject.ObjectType] = {
        return     [AVMetadataObject.ObjectType.upce,
                                              AVMetadataObject.ObjectType.code39,
                                              AVMetadataObject.ObjectType.code39Mod43,
                                              AVMetadataObject.ObjectType.code93,
                                              AVMetadataObject.ObjectType.code128,
                                              AVMetadataObject.ObjectType.ean8,
                                              AVMetadataObject.ObjectType.ean13,
                                              AVMetadataObject.ObjectType.aztec,
                                              AVMetadataObject.ObjectType.pdf417,
                                              AVMetadataObject.ObjectType.qr]

    }()

    var isSendMoney = false

    //MARK:- Vc Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Session setup.
        setupCaptureSession()
        closeButton.rounded()

        view.bringSubviewToFront(overlayView)

        if isSendMoney {
            closeButton.hide()
            instructionLabel.text = "Scan Receiver's QR Code"
            flashToggleButton.hide()
        }
        flashToggleButton.rounded()
        view.bringSubviewToFront(instructionLabel)
        view.bringSubviewToFront(scanFromPhotoBtn)
        view.bringSubviewToFront(closeButton)
        view.bringSubviewToFront(myQRCodeBtn)
        
      //  self.observerAppNotifs()
        
        self.myQRCodeBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: {
            
            // Show My QR Code: Should be handled by Coordinator
//            let myQRVc = MyQRViewController.initFromStoryboard(name: "MyQR")
//            let myQRNav = UINavigationController()
//            myQRNav.setViewControllers([myQRVc], animated: true)
//            self.present(myQRNav, animated: true, completion: nil)

        }).disposed(by: self.disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = !isSendMoney
        reStart()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.overlayView.startAnimation()
        print("VIEW DID APPEAR CALLED")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
        stop()
        self.overlayView.stopAnimation()
    }

    @IBAction func onCloseButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func scanFromPhoto(_ sender: Any) {
       // self.imagePicker.start()
    }
    
    @IBAction func toggleFlash(_ sender: Any) {
        isFlash = !isFlash
        let flashImage = isFlash ? UIImage.init(named: "icn-ip-flashon") : UIImage.init(named: "icn-ip-flashoff")
        flashToggleButton.setImage(flashImage, for: .normal) 
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                    device.torchMode = AVCaptureDevice.TorchMode.off
                } else {
                    do {
                        try device.setTorchModeOn(level: 1.0)
                    } catch {
                        print(error)
                    }
                }
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
        
    }
}

// MARK:- Observer notifications

extension BarCodeScannerViewController {
    
    func observerAppNotifs() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    @objc func appDidBecomeActive() {
        overlayView.startAnimation()
    }

    @objc func appDidEnterBackground() {
        overlayView.stopAnimation()
    }
}

//MARK:- Setup Session

private extension BarCodeScannerViewController {

    func setupAuthorization() {

        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .notDetermined:

            sessionQueue.suspend()

            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { authorized in
                self.sessionQueue.resume()
            })
            break
        case .restricted:
            break
        case .denied:

            let alert = UIAlertController(title: "Alert!", message: "Camera Should be turned on.", preferredStyle: UIAlertController.Style.alert)
            let settingButton = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) { (alert)  in
                DispatchQueue.main.async {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: { completed in

                        })
                    } else {
                        UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                    }
                }
            }
            alert.addAction(settingButton)
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (alert)  in
            }
            alert.addAction(cancelButton)
            UIViewController.topViewController().present(alert, animated: true, completion: nil)
            break
        case .authorized:
            break
        }
    }

    func setupCaptureSession() {
        captureSession = AVCaptureSession()
        self.setupPreviewLayer()
        setupAuthorization()

        sessionQueue.async {
            //let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaType.video)

            let captureDevice = AVCaptureDevice.default(for: .video)
            
            var input: AVCaptureDeviceInput?

            do {
                
                if let device = captureDevice {
                    
                    input = try AVCaptureDeviceInput(device: device)
                    
                }
                
                
            } catch _ { }

            // Initialize the captureSession object.

            guard let deviceInput = input, let session = self.captureSession else { return }

            if session.canAddInput(deviceInput) {
                 self.captureSession?.addInput(deviceInput)
            }else {
                
            }

            let captureMetadataOutput = AVCaptureMetadataOutput()


            if session.canAddOutput(captureMetadataOutput) {
               self.captureSession?.addOutput(captureMetadataOutput)
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = self.supportedCodeTypes

                let output = self.captureSession?.outputs[0] as? AVCaptureMetadataOutput

                var  frameOfInterest = CGRect.zero
                DispatchQueue.main.sync {
                    frameOfInterest = (self.videoPreviewLayer?.metadataOutputRectConverted(fromLayerRect: self.overlayView.transHoleView.frame))!
                }
                output?.rectOfInterest = frameOfInterest

            }else {
                
            }

        }
    }

}

//MARK:- Preview Setup

private extension BarCodeScannerViewController {

    func setupPreviewLayer() {
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
        self.videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        let videoFrame = CGRect(x: self.view.layer.bounds.origin.x, y: self.view.layer.bounds.origin.y, width:self.view.layer.bounds.width, height: self.view.layer.bounds.height)
        self.videoPreviewLayer?.frame = videoFrame
        self.view.layer.addSublayer(self.videoPreviewLayer!)
    }
}

//MARK:- Session Control

private extension BarCodeScannerViewController {

    func reStart() {
        sessionQueue.async {
            self.captureSession?.startRunning()
        }
    }

    func stop() {
        sessionQueue.async {
            self.captureSession?.stopRunning()
        }
    }
    
    func stopSessionInMainThread() {
        DispatchQueue.main.async {
            self.captureSession?.stopRunning()
        }
    }
}

//MARK:- AVCaptureMetadataOutputObjectsDelegate

extension BarCodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

            if metadataObjects.count == 0 {
                return
            }
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
            
            return
        }
        
        guard let stringValue = metadataObj.stringValue else { return }
        
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        self.showSuccessAlert(message: stringValue)
        
       // self.audioManager.playBleep()
        
        
        return
        
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr  {

                self.stopSessionInMainThread()
                DispatchQueue.main.async {

                if let qrstring = metadataObj.stringValue {
                    
                    print("RAW QR STRING \(qrstring)")
                    
                    let deString = self.decrypt(qrString: qrstring)
                    print("decrypted QR Data \(deString)")
                    
                    guard let mode = QRData(withDecodedString: deString).qrTransactionMode, deString.count > 0 else {
                        self.showAlertWithCompletion(title: "Invalid QR Data", completion: { _ in
                            self.reStart()
                        })
                        return
                    }
                    
                    self.audioManager.playBleep()
                    
                    switch mode {

                    case .sendMoney:
                        let qrData = QRData.init(withDecodedString: deString)
                        self.showAlertWithCompletion(title: "IME Pay customer: \(qrData.fullName ?? "")", completion: { _ in
                                self.reStart()
                        })
                        break
                    case .payMerchat:
                        
                        if self.isSendMoney == true {
                            self.showAlertWithCompletion(title: "Please use a valid QR Code for send money", completion: { _ in
                                self.reStart()
                            })
                            return
                        }

                        let data = QRData(withDecodedString: deString)
                        guard let _ = data.mobileNumber else {
                            self.showAlertWithCompletion(title: "Invalid QR Data", completion: { _ in
                                self.reStart()
                            })
                            return
                        }
                        //HYBRID AGENT MERCHANT ACTIONS

                       
                        break
                    case .agent:
                        
                        if self.isSendMoney == true {
                            self.showAlertWithCompletion(title: "Please use a valid QR Code for send money", completion: { _ in
                                self.reStart()
                            })
                            return
                        }
                        
                        
                        let data = QRData(withDecodedString: deString)
                        guard let _ = data.mobileNumber else {
                            self.showAlertWithCompletion(title: "Invalid QR Data", completion: { _ in
                                self.reStart()
                            })
                            return
                        }

                       
                        break
                    }
                }
            }
          }
        }
}

//MARK:- Decryption

extension BarCodeScannerViewController {

    func decrypt(qrString: String) -> String {
        do {
           let decrypted = try AES.init(key:  ENC_SECRET_KEY.bytes, blockMode: CBC.init(iv:  ENC_IV_KEY.bytes), padding: .noPadding).decrypt(Array<UInt8>(hex: qrString))
             return String(data: Data(decrypted), encoding: String.Encoding.utf8) ?? ""
            
        } catch  {
            //print("Failed to decrypt the QR Data with error \(decryptError)")
        }
        return ""
    }

}


// MARK:- Scan From Photos

private extension BarCodeScannerViewController {
    
    func decodeImage(image: UIImage?) {
        
        if let qrcodeImg = image {
            let detector:CIDetector=CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
            let ciImage:CIImage = CIImage(image:qrcodeImg)!
            var qrString = ""
    
            let features=detector.features(in: ciImage)
            for feature in features as! [CIQRCodeFeature] {
                qrString += feature.messageString ?? ""
            }
            
            if qrString.isEmpty {
    
                self.showAlertWithCompletion(title: "Error!", message: "No QR Code detected", actionTitle: "Ok") { _ in
                    self.reStart()
                }
                
            }else{
               // print("message: \(qrString)")
                
                let decryptedString = self.decrypt(qrString: qrString)
                
                print("decrypted QR Data \(decryptedString)")
                
                self.audioManager.playBleep()
                self.evaluateDecryptedString(deString: decryptedString)
            }
        }
        else{
            self.showAlertWithCompletion(title: "Something went wrong, Please try again later.", completion: { _ in
                self.reStart()
            })
        }
    }
    
    func evaluateDecryptedString(deString: String) {
        
        guard let mode = QRData(withDecodedString: deString).qrTransactionMode, deString.count > 0 else {
            self.showAlertWithCompletion(title: "Invalid QR Data", completion: { _ in
                self.reStart()
            })
            return
        }
        switch mode {
        case .sendMoney:
            
            let qrData = QRData.init(withDecodedString: deString)
            self.showAlertWithCompletion(title: "IME Pay customer: \(qrData.fullName ?? "")", completion: { _ in
                self.reStart()
            })
            
            break
        case .payMerchat:
            
            if self.isSendMoney == true {
                self.showAlertWithCompletion(title: "Please use a valid QR Code for send money", completion: { _ in
                    self.reStart()
                })
                return
            }
            
            let data = QRData(withDecodedString: deString)
            guard let _ = data.mobileNumber else {
                self.showAlertWithCompletion(title: "Invalid QR Data", completion: { _ in
                    self.reStart()
                })
                return
            }
            //HYBRID AGENT MERCHANT ACTIONS
            
           
            break
        case .agent:
            
            if self.isSendMoney == true {
                self.showAlertWithCompletion(title: "Please use a valid QR Code for send money", completion: { _ in
                    self.reStart()
                })
                return
            }
            
            
            let data = QRData(withDecodedString: deString)
            guard let _ = data.mobileNumber else {
                self.showAlertWithCompletion(title: "Invalid QR Data", completion: { _ in
                    self.reStart()
                })
                return
            }
            
            //HYBRID AGENT MERCHANT ACTIONS
           
            break
        }
        
    }

}

