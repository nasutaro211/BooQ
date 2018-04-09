
import UIKit
import AVFoundation
import Alamofire

class BarCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    //道具用意
    @IBOutlet var logLable: PaddingLabel!
    let captureSession:AVCaptureSession? = AVCaptureSession();
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var barCodeFrameView:UIView?
    var book:VolumeInfo!
    var guardnerStr = ""
    // 読み取り範囲（0 ~ 1.0の範囲で指定）
    let x: CGFloat = 10
    let y: CGFloat = 100
    let width: CGFloat = 300
    let height: CGFloat = 120
    //いつもの
    override func viewDidLoad() {
        super.viewDidLoad()
        //logLableを隠す
        logLable.isHidden = true
        logLable.alpha  = 0
        // カメラがあるか確認し，取得する
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)//(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        do {
            // 取得したDeviceObjectを元にAVCaptureDeviceInputのインスタンスを作成
            let input = try AVCaptureDeviceInput(device: captureDevice)
            // AVCaptureDeviceInputのインスタンスをcaptureSessionのInputDeviceに設定
            captureSession?.addInput(input)
            // AVCaptureMetadataOutputのインスタンスを作成して、captureSessionのOutputDeviceに設定
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            //OutputDeviceのdelegateをセットしてcallbackを実行するためにDispatchQueue.mainを使う
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13]//ここ metadataObjectTypesがnilであるのが問題?
            // VideoPreviewLayerのインスタンスを作って、サブレイヤーとしてviewに追加する
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.insertSublayer(videoPreviewLayer!, below: nil)
            // ビデオキャプチャ開始
            captureSession?.startRunning()
            // バーコードの読み取り枠を作成(読み込んだ時のdelegate methodで表示させる準備)
            barCodeFrameView = UIView()
            if let barCodeFrameView = barCodeFrameView { //右辺のbarCodeFrameViewはBarCodeViewControllerのメンバー変数
                barCodeFrameView.layer.borderColor = UIColor.green.cgColor
                barCodeFrameView.layer.borderWidth = 2
                view.addSubview(barCodeFrameView)
                view.bringSubview(toFront:barCodeFrameView)
            }
        } catch {
            // エラーが起こったらエラーをprint
            print(error)
            return
        }
    }
    
    // 映像からmetadataを取得した場合に呼び出されるデリゲートメソッド
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        DispatchQueue.main.async{
            // Check if the metadataObjects array is not nil and it contains at least one object.
            if metadataObjects.count == 0 {
                //緑の枠を消す
                self.barCodeFrameView?.frame = CGRect.zero
                return
            }
            // Get the metadata object.
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            //ean13だったら
            if metadataObj.type == AVMetadataObject.ObjectType.ean13 {
                let barCodeObject = self.videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                self.barCodeFrameView?.frame = barCodeObject!.bounds
                //うまく読めたら
                if metadataObj.stringValue != nil {
                    if metadataObj.stringValue != self.guardnerStr && Int(metadataObj.stringValue!)!>9784000000000{
                        self.guardnerStr = metadataObj.stringValue!
                        let url = "https://www.googleapis.com/books/v1/volumes?q=isbn:" + metadataObj.stringValue!
                        Alamofire.request(url).response { response in
                            if let data = response.data, let responseData:ResponseData = try? JSONDecoder().decode(ResponseData.self, from: data){
                                self.book = responseData.items.first?.volumeInfo
                                self.book.isbn = metadataObj.stringValue!
                                self.segueAddBookView()
                            }else{
                                //ここでないよラベル表示
                                print("ないよ")
                                self.logStr()
                                self.guardnerStr = metadataObj.stringValue!
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                    self.performSegue(withIdentifier: "toSelfRgstBookView", sender: metadataObj.stringValue)
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    func logStr(){
        //        self.logLable.alpha = 0
        logLable.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            self.logLable.alpha = 1
        }, completion:nil)
        
    }
    
    
    
    func segueAddBookView(){
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toAddBookView", sender: self.book)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toAddBookView"://読み取り成功(GoogleBooksに本ありの時)
            let destination = segue.destination as! RgstPopUpViewController
            destination.theBook = sender as! VolumeInfo
            destination.from = "BarCodeReader"
            break
        case "toSelfRgstBookView":
            let destination = segue.destination as! SelfRgstBookViewController
            destination.isbn = sender as! String
        default:
            break
        }
    }
    
}


