//
//  UploadViewController.swift
//  CameraDemo
//
//  Created by Atinderjit Kaur on 01/06/17.
//  Copyright © 2017 Aditi. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Alamofire


class UploadViewController: UIViewController {
    
    var videoPath:String?
    var avplayeritem:AVPlayerItem!
    var avplayer = AVPlayer()
    var player = AVPlayer()
    var videoData:Data?
    var playing : Bool?
    var url = NSURLRequest()
    private var newVideoPath:String?
  public  var outputURL_new : String?
    
    
    //For only video play
    
    @IBOutlet weak var img_Back: UIImageView!
    @IBOutlet weak var btn_Back: UIButton!
    
    @IBOutlet weak var btn_Upload: UIButton!
    @IBOutlet var btn_PlayAgain: UIButton!
    @IBOutlet weak var btn_Cancel: UIButton!
    @IBOutlet weak var view_Popup: UIView!
    
    
    override var shouldAutorotate : Bool {
        // Lock autorotate
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        // Only allow Portrait
        return UIInterfaceOrientationMask.portrait
    }
    
    
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        
        // Only allow Portrait
        return UIInterfaceOrientation.portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        NSString* str = @"abcdefghi";
//        [str rangeOfString:@"c"].location; // 2
        
        
        
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
        SetButtonCustomAttributesPurple(btn_PlayAgain)
        SetButtonCustomAttributes(btn_Upload)
        SetButtonCustomAttributesPurple(btn_Cancel)
       
  
        if bool_PlayFromProfile == false {
        
             DispatchQueue.main.async {
            
            if self.videoPath != nil || self.videoPath != ""{
                self.newVideoPath = self.videoPath
                _ = try! Data(contentsOf: NSURL(fileURLWithPath: self.newVideoPath!) as URL)
            }
            
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy-HH-mm-ss"
        let dateTimePrefix: String = formatter.string(from: Date())
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        
        let  CompressedVideoPath = "\(documentsDirectory)/\(dateTimePrefix).mov"
        let CompressedURL = NSURL(fileURLWithPath: CompressedVideoPath)
        self.compressVideo(NSURL(fileURLWithPath:self.newVideoPath!) as URL, outputURL: CompressedURL as URL,handler: {
            (response) in
            
//            if response.status == AVAssetExportSessionStatus.completed {
//                
//             DispatchQueue.main.async {
//            self.videoData = NSData(contentsOf: CompressedURL as URL) as Data? // converting compressed video into data
//                
//                 self.SetButtonCustomAttributesPurple(self.btn_Upload)
//                 self.btn_Upload.isUserInteractionEnabled = true
//                 print("success in video compression")
//                
//                }
//            }
        })
            do{
                try self.playVideo()
            }
            catch {
                print("Try Again")
            }
        }
           }
        else {
            
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.tabBarController?.tabBar.isHidden = true
            self.view_Popup.isHidden = true
            
         
            playVideoFromProfile()
        }
          }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        bool_PlayFromProfile = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
    //MARK: When only play video from profile
      func playVideoFromProfile() {
        
        player = AVPlayer(url: video_url!)
        
        DispatchQueue.main.async {
            
            self.pleaseWait()
            
        }

      //  player.addObserver(self, forKeyPath: "status", options: [], context: nil)

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill

        self.view.layer.addSublayer(playerLayer)
        
        self.view.bringSubview(toFront: btn_Back)
        self.view.bringSubview(toFront: img_Back)

        
        btn_Back.isHidden = false
        img_Back.isHidden = false
        NotificationCenter.default
            .addObserver(self, selector: #selector(playerItemDidStart), name:NSNotification.Name.AVPlayerItemNewAccessLogEntry , object: nil)
        
        NotificationCenter.default
            .addObserver(self, selector: #selector(playerItemDidReachEnd), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime , object: nil)
      
       
        
        player.play()
        
        
        
      }
    
    
    //MARK: When upload video
    
       func playVideo() throws {
        
        btn_PlayAgain.setTitle("PAUSE", for: .normal)
        
        guard let path = newVideoPath // path for the video file
            else
        {
            throw AppError.invalidResource("video", "mov")
        }
        //  DispatchQueue.global(qos: .background).async {
        // DispatchQueue.main.async {
        let avasset = AVAsset(url: URL(fileURLWithPath: path))
        self.avplayeritem = AVPlayerItem.init(asset: avasset) // player item is initalised with the path of file
        self.avplayer = AVPlayer.init(playerItem: self.avplayeritem)// player is initialised with the player item`
        let avplayerlayer = AVPlayerLayer.init(player: self.avplayer)    // player layer is initialised with the player
        avplayerlayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        avplayerlayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(avplayerlayer) // sublayer is added on the view
        
      
        
        self.view.addSubview(self.view_Popup)
        self.view_Popup.addSubview(self.btn_PlayAgain)
        self.view_Popup.addSubview(self.btn_Upload)
        self.view_Popup.addSubview(self.btn_Cancel)
        
        NotificationCenter.default
            .addObserver(self, selector: #selector(playerItemDidReachEnd), name:NSNotification.Name.AVPlayerItemDidPlayToEndTime , object: nil)
        
        // self.avplayer.actionAtItemEnd = .none
        
        self.avplayer.play()
        //}
        // }
    }
    func playerItemDidReachEnd(notification: NSNotification) {
        
         if bool_PlayFromProfile == false {
        playing = true
        btn_PlayAgain.setTitle("PLAY", for: .normal)
        }
     else  {
            _ = self.navigationController?.popViewController(animated: true)
        }

    }
    
    func playerItemDidStart(notification: NSNotification) {
        
        if player.status == .readyToPlay {
            DispatchQueue.main.async {
                
                self.clearAllNotice()
                
            }
        }
    
        
    }
    
    
    enum AppError : Error{
        case invalidResource(String, String)
    }
    
    @IBAction func Action_PlayAgain(_ sender: UIButton) {
        
        if self.avplayer.rate == 1.0 {
            playing = false
            btn_PlayAgain.setTitle("PLAY", for: .normal)
            self.avplayer.pause()
        } else {
            
            if playing == true {
                
                do{
                    try self.playVideo()
                }
                catch{
                    print("Try Again")
                }
            }
            else{
                
                self.avplayer.play()
                btn_PlayAgain.setTitle("PAUSE", for: .normal)
                
            }
            
        }
        
    }
    
    
    //MARK: When upload video

    @IBAction func UploadVideo(_ sender: UIButton) {
        
        if self.checkInternetConnection(){
            DispatchQueue.main.async {
                self.pleaseWait()
            }
            
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy-HH-mm-ss"
            let dateTimePrefix: String = formatter.string(from: Date())
            
            do
            {
                
                let headers : HTTPHeaders = [
                    "Application-Token" : "IPHONE_6zJxK4AMDpahM3Yd7xARGPfRhcWbAkcY9dsfhu1sdF",
                    "Application-Type" : "IPHONE",
                    "Session-Token" :(SavedPreferences.value(forKey:"sessionToken")as? String)!,
                    "Device-Token":DeviceToken
                ]
                
                print(headers)
                
                let user_id = "\(((SavedPreferences.object(forKey: Global.macros.kUserId))!))"
                
                
                //  self.url = try URLRequest(url: "http://115.248.100.76:8013/user/api/uploadVideo", method: .post) as NSURLRequest
                self.url = try URLRequest(url: "http://115.248.100.76:8013/user/api/uploadVideo", method: .post , headers: headers) as NSURLRequest
                
                
                Alamofire.upload(multipartFormData:{
                    (multipartFormData)-> Void in
                    
                    
                    if self.videoData != nil {
                        
                        (multipartFormData.append(self.videoData!, withName: "video", fileName: "\(dateTimePrefix).mov", mimeType: "video/mov"))
                        multipartFormData.append((user_id.data(using:String.Encoding.utf8)!), withName: Global.macros.kUserId)
                    }
                    else {
                        self.clearAllNotice() //hide loader
                        self.showAlert(Message: "Unable to upload video. Please try again.", vc: self)
                        
                        
                    }
                    
                    
                }, with:url as URLRequest, encodingCompletion: {
                    (encodingResult) in
                    switch encodingResult
                    {
                    case .success(let upload, _, _):
                        upload.responseString(completionHandler:{  (response) in
                            
                            print(response)
                            //to get status code
                            if let status = response.response?.statusCode {
                                switch(status){
                                case 200:
                                    // move to newsfeed screen
                                 
                   if (SavedPreferences.value(forKey: "role") as? String) == "USER" {
                                    
                                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "UsereditView") as! UserEditProfileViewController
                                  _ = self.navigationController?.pushViewController(vc, animated: true)
                                    self.showAlert(Message: "Uploaded successfully", vc: self)
                                    self.avplayer.pause()
                    
                    
                    
                    
                   }
                   
                   else {
                    
                    let vc = Global.macros.Storyboard.instantiateViewController(withIdentifier: "editView") as! EditProfileViewController
                    _ = self.navigationController?.pushViewController(vc, animated: true)
                    self.showAlert(Message: "Uploaded successfully", vc: self)
                    self.avplayer.pause()
                    
                   }
                                    break
                                case 401:
                                    self.AlertSessionExpire()
                                    break
                                case 400:
                                    
                                    self.showAlert(Message: "Something went wrong.Please try again later.", vc: self)
      
                                    break
                                    
                                default:
                                    break
                                }
                            }
                           
                          
                           
                            
                        })
                        upload.uploadProgress(closure:
                            {
                                (progress) in
                        })
                    case .failure(let encodingError):
                        print(encodingError)
                    }
                })
            }
            catch{
                print(error)
            }
        }else{
            
            self.showAlert(Message: Global.macros.kInternetConnection, vc: self)
            
            
        }
    }
    
    @IBAction func Action_Cancel(_ sender: UIButton) {
        
        self.view_Popup.isHidden = true
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func Action_BackButton(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)

    }
    
    
    //MARK: Functions
    func compressVideo(_ inputURL: URL,outputURL:URL ,handler completion: @escaping (AVAssetExportSession) -> Void) {
        
        uploadVideo_rightOrientation(inputURL)
        
//        
//        let urlAsset = AVURLAsset.init(url: inputURL)
//        let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality)
//        
//        exportSession?.outputURL = outputURL
//        
//        
//        exportSession?.outputFileType = AVFileTypeMPEG4
//        exportSession?.shouldOptimizeForNetworkUse = true
//        
//        exportSession?.exportAsynchronously(completionHandler: {() -> Void in
//            completion(exportSession!)
//            
//          
//            
//        })
    }
    
    func uploadVideo_rightOrientation(_ videoToTrimURL: URL)
    {
        let videoAsset = AVURLAsset(url: videoToTrimURL, options: nil)
        let sourceAudioTrack: AVAssetTrack? = (videoAsset.tracks(withMediaType: AVMediaTypeAudio)[0] as? AVAssetTrack)
        let composition = AVMutableComposition()
        let compositionAudioTrack: AVMutableCompositionTrack? = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
        try? compositionAudioTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration), of: sourceAudioTrack!, at: kCMTimeZero)
        let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetMediumQuality)
        
//        let paths: [String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        outputURL_new = paths[0]
//        outputURL_new = URL(fileURLWithPath: outputURL_new!).appendingPathComponent("output.mp4").absoluteString
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let myDocumentPath = NSURL(fileURLWithPath: documentsDirectory).appendingPathComponent("video.mp4")?.absoluteString
        let url = NSURL(fileURLWithPath: myDocumentPath!)
        
        let documentsDirectory2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        
        let filePath = documentsDirectory2.appendingPathComponent("video.mp4")
        deleteFile(filePath: filePath! as NSURL)
        
        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: myDocumentPath!) {
            do {
                try FileManager.default.removeItem(atPath: myDocumentPath!)
            }
            catch let error {
                print(error)
            }
        }

        
        
      

        
        assetExport?.outputFileType = AVFileTypeMPEG4
        assetExport?.outputURL = filePath
        assetExport?.shouldOptimizeForNetworkUse = true
        assetExport?.videoComposition = getVideoComposition(videoAsset, composition: composition)
        let timeRange: CMTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
        assetExport?.timeRange = timeRange
        

        
        assetExport?.exportAsynchronously(completionHandler: {
            
            //case is always .failed
            switch assetExport!.status {
            case .completed:
                let urlString: String = filePath!.path
                self.videoData = FileManager.default.contents(atPath: urlString )
                
                DispatchQueue.main.async {
                    self.SetButtonCustomAttributesPurple(self.btn_Upload)
                    self.btn_Upload.isUserInteractionEnabled = true

                  
                }
             
            case .failed:
                print("failed")
                print(assetExport!.error!)
            default:
                print("something else")
            }
        })

//        assetExport?.exportAsynchronously(completionHandler: {(_: Void) -> Void in
//            switch assetExport?.status {
//            case .completed:
//                videoData = FileManager.default.contents(atPath: outputURL_new)
//                print("Export Complete \(Int(assetExport.status)) \(assetExport.error)")
//            case .failed:
//                print("Failed:\(assetExport?.error)")
//            case .cancelled:
//                print("Canceled:\(assetExport?.error)")
//            default:
//                break
//            }
//            
//        })

    }
    func getVideoComposition(_ asset: AVAsset, composition: AVMutableComposition) -> AVMutableVideoComposition
    {
        let isPortrait_: Bool = isVideoPortrait(asset)
        let compositionVideoTrack: AVMutableCompositionTrack? = composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
        let videoTrack: AVAssetTrack? = (asset.tracks(withMediaType: AVMediaTypeVideo)[0] as? AVAssetTrack)
        try? compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration), of: videoTrack!, at: kCMTimeZero)
        let layerInst = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack!)
        let transform: CGAffineTransform? = videoTrack?.preferredTransform
        layerInst.setTransform(transform!, at: kCMTimeZero)
        let inst: AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
       // let inst = AVMutableVideoCompositionInstruction.videoCompositionInstruction
        inst.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration)
        inst.layerInstructions = [layerInst]
        let videoComposition: AVMutableVideoComposition = AVMutableVideoComposition()

//        let videoComposition = AVMutableVideoComposition.videoComposition
        videoComposition.instructions = [inst]
        var videoSize: CGSize = videoTrack!.naturalSize
        if isPortrait_ {
            print("video is portrait ")
            videoSize = CGSize(width: CGFloat(videoSize.height), height: CGFloat(videoSize.width))
        }
        videoComposition.renderSize = videoSize
        videoComposition.frameDuration = CMTimeMake(1, 30)
        videoComposition.renderScale = 1.0
        return videoComposition

    }
    func isVideoPortrait(_ asset: AVAsset) -> Bool {
        var isPortrait: Bool = false
        let tracks: [Any] = asset.tracks(withMediaType: AVMediaTypeVideo)
        if tracks.count > 0 {
            let videoTrack: AVAssetTrack? = (tracks[0] as? AVAssetTrack)
            let t: CGAffineTransform? = videoTrack?.preferredTransform
            // Portrait
            if t?.a == 0 && t?.b == 1.0 && t?.c == -1.0 && t?.d == 0 {
                isPortrait = true
            }
            // PortraitUpsideDown
            if t?.a == 0 && t?.b == -1.0 && t?.c == 1.0 && t?.d == 0 {
                isPortrait = true
            }
            // LandscapeRight
            if t?.a == 1.0 && t?.b == 0 && t?.c == 0 && t?.d == 1.0 {
                isPortrait = false
            }
            // LandscapeLeft
            if t?.a == -1.0 && t?.b == 0 && t?.c == 0 && t?.d == -1.0 {
                isPortrait = false
            }
        }
        return isPortrait
    }
    
    func getVideoOrientation(from asset: AVAsset) -> UIImageOrientation {
        let videoTrack: AVAssetTrack? = (asset.tracks(withMediaType: AVMediaTypeVideo)[0] as? AVAssetTrack)
        let size: CGSize? = videoTrack?.naturalSize
        let txf: CGAffineTransform? = videoTrack?.preferredTransform
        if size?.width == txf?.tx && size?.height == txf?.ty {
            return .left
        }
        else if txf?.tx == 0 && txf?.ty == 0 {
            return .right
        }
        else if txf?.tx == 0 && txf?.ty == size?.width {
            return .down
        }
        else {
            return .up
        }
        
        //return UIInterfaceOrientationPortrait;
    }
    
    
    func deleteFile(filePath:NSURL) {
        guard FileManager.default.fileExists(atPath: filePath.path!) else {
            return
        }
        
        
        do {
            try FileManager.default.removeItem(atPath: filePath.path!)
        }catch{
            fatalError("Unable to delete file: \(error) : \(#function).")
        }
    }


//    func clearTmpDirectory() {
//        do {
//             let exportPath: NSString = NSTemporaryDirectory().appendingFormat("video.mp4")
//            let tmpDirectory = try FileManager.default.contentsOfDirectory(atPath: exportPath as String)
//            try tmpDirectory.forEach { file in
//                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
//                try FileManager.default.removeItem(atPath: path)
//            }
//        } catch {
//            print(error)
//        }
//    }

    
//    func removeVideo(_ filename: String)
//
//    {
//        
//        let filemanager = FileManager.default
//        _ = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
//        let exportPath: NSString = NSTemporaryDirectory().appendingFormat("video.mp4")
//        try filemanager.removeItem(atPath: exportPath as String)
//        
//        
////        if success != nil
////        {
////            
////        }
////        else {
////            print("Could not delete file ")
////        }
//
//    }
//    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

