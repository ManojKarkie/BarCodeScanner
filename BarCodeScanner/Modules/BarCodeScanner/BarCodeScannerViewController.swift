//
//  QRCodeScannerViewController.swift
//
//  Created by Manoj Karki on 6/6/16.
//

import AVFoundation
import CryptoSwift

class BarCodeScannerViewController: BaseViewController, StoryboardInitializable {

    //MARK:- IBOutlets

    @IBOutlet weak var overlayView: OverlayView!
    @IBOutlet weak var flashToggleButton: UIButton!
    @IBOutlet weak var instructionLabel : UILabel!
    @IBOutlet weak var closeButton: UIButton!

    //MARK:- States

    fileprivate var sessionQueue = DispatchQueue(label: "SESSION_QUEUE")

    fileprivate var captureSession: AVCaptureSession?

    fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    fileprivate var isFlash = false
    
    fileprivate let audioManager = AudioManager()
    
    fileprivate let viewModel = ScannerViewModel()
    
    var coordinator: ScannerCoordinator?

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

    //MARK:- Vc Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Session setup.

        setupCaptureSession()
        closeButton.rounded()

        view.bringSubviewToFront(overlayView)

        flashToggleButton.rounded()
        view.bringSubviewToFront(instructionLabel)
        
        view.bringSubviewToFront(closeButton)
        
        self.bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reStart()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.stop()
    }

    @IBAction func onCloseButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension BarCodeScannerViewController {

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
            
            self.showAlertWithCompletion(title: "Invalid BarCode", completion: { _ in
                self.reStart()
            })
            return
        }
        
        self.stopSessionInMainThread()
        
        guard let stringValue = metadataObj.stringValue else {
            
            self.showAlertWithCompletion(title: "Empty BarCode Data", completion: { _ in
                self.reStart()
            })

            return
            
        }
        
        // AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
      //  self.showSuccessAlert(message: stringValue)
        
        self.showAlertWithCompletion(title: stringValue, completion: { _ in
            
            self.viewModel.sendBarCodeInfo()
    
            //self.reStart()
        })

        // self.audioManager.playBleep()
    }

}

extension BarCodeScannerViewController {
    
    func bindViewModel() {
        
      //   Rx binding viewModel -> controller

        self.viewModel.isLoadingDriver.drive(onNext: { [weak self] isLoading in
            self?.showHud(show: isLoading)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.successDriver.filter { return $0 == true }.drive(onNext: { [weak self] _ in
         //   self?.showSuccessAlert(message: "Login success!")
            
            self?.coordinator?.showResponseInfoScreen()
            

        }).disposed(by: self.disposeBag)
        
        self.viewModel.errorDriver.filter { return $0 != nil }.drive(onNext: { [weak self] errorMessage in
            self?.reStart()
            self?.showErrorAlert(message: errorMessage)
        }).disposed(by: self.disposeBag)

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
              //  self.evaluateDecryptedString(deString: decryptedString)
            }
        }
        else{
            self.showAlertWithCompletion(title: "Something went wrong, Please try again later.", completion: { _ in
                self.reStart()
            })
        }
    }

}

