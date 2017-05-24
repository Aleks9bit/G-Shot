//
// Created by alexey on 5/5/17.
// Copyright (c) 2017 GoTo Inc. All rights reserved.
//

import UIKit
import AVFoundation
import KRProgressHUD
import Photos

class RecordViewController: UIViewController {

  let surfaceConteinerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .clear

    return view
  }()

  let surfaceImage: UIImageView = {
    let image = UIImage(imageLiteralResourceName: "surface_bg")
    let imageView = UIImageView(image: image)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill

    return imageView
  }()

  let cameraVideoImage: UIImageView = {
    let image = UIImage(imageLiteralResourceName: "video_off")
    let imageView = UIImageView(image: image)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill

    return imageView
  }()

  let cameraPhotoImage: UIImageView = {
    let image = UIImage(imageLiteralResourceName: "camera_on")
    let imageView = UIImageView(image: image)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill

    return imageView
  }()

  let selectorButton: UIButton = {
    let image = UIImage(imageLiteralResourceName: "selector_photo")
    let button = UIButton(type: .system)
    button.setBackgroundImage(image, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(switchCameraType), for: .touchUpInside)

    return button
  }()

  let switchCameraButton: UIButton = {
    let image = UIImage(imageLiteralResourceName: "change_camera_back")
    let button = UIButton(type: .system)
    button.setBackgroundImage(image, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(switchCameraInput), for: .touchUpInside)

    return button
  }()

  let galleryButton: UIButton = {
    let image = UIImage(imageLiteralResourceName: "gallery_shortcut")
    let imageSelected = UIImage(imageLiteralResourceName: "gallery_pressed")
    let button = UIButton(type: .system)
    button.setBackgroundImage(image, for: .normal)
    button.setBackgroundImage(imageSelected, for: .selected)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(getMediaFromGallery), for: .touchUpInside)

    return button
  }()

  lazy var updateWatermarksButton: UIButton = {
    let image = UIImage(imageLiteralResourceName: "update_watermarks")
    let imageDisable = UIImage(imageLiteralResourceName: "watermarksuptodate")
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setBackgroundImage(image, for: .normal)
    button.setBackgroundImage(imageDisable, for: .disabled)
    button.addTarget(self, action: #selector(refreshWatermarks), for: .touchUpInside)

    return button
  }()

  let recordVideoButton: UIButton = {
    let videoOff = UIImage(imageLiteralResourceName: "videoOff")
    let videoOn = UIImage(imageLiteralResourceName: "videoActive")
    let button = UIButton(type: .custom)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.adjustsImageWhenHighlighted = false
    button.setBackgroundImage(videoOff, for: .normal)
    button.setBackgroundImage(videoOn, for: .selected)
    button.addTarget(self, action: #selector(recordVideo), for: .touchUpInside)
    button.isEnabled = false
    button.isHidden = true

    return button
  }()

  let shotPhotoButton: UIButton = {
    let cameraOff = UIImage(imageLiteralResourceName: "cameraOff")
    let cameraOn = UIImage(imageLiteralResourceName: "cameraOn")
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setBackgroundImage(cameraOff, for: .normal)
    button.setBackgroundImage(cameraOn, for: .selected)
    button.isEnabled = false
    button.addTarget(self, action: #selector(shotPhoto), for: .touchUpInside)

    return button
  }()

  let prevWatermarkButton: UIButton = {
    let image = UIImage(imageLiteralResourceName: "prev_button")
    let imageSelected = UIImage(imageLiteralResourceName: "prev_button_selected")
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setBackgroundImage(image, for: .normal)
    button.setBackgroundImage(imageSelected, for: .disabled)
    button.addTarget(self, action: #selector(changeWatermark(_:)), for: .touchUpInside)
    button.isEnabled = false

    return button
  }()

  let nextWatermarkButton: UIButton = {
    let image = UIImage(imageLiteralResourceName: "next_button")
    let imageSelected = UIImage(imageLiteralResourceName: "next_button_selected")
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setBackgroundImage(image, for: .normal)
    button.setBackgroundImage(imageSelected, for: .disabled)
    button.addTarget(self, action: #selector(changeWatermark(_:)), for: .touchUpInside)
    button.isEnabled = false

    return button
  }()

  let watermarkImage: UIImageView = {
    let imageView = UIImageView(image: nil)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .clear
    imageView.contentMode = .scaleAspectFit

    return imageView
  }()

  var captureSession: AVCaptureSession = {
    let session = AVCaptureSession()
    session.sessionPreset = AVCaptureSessionPresetHigh

    return session
  }()

  lazy var previewLayer: AVCaptureVideoPreviewLayer = {
    let preview = AVCaptureVideoPreviewLayer(session: self.captureSession)
    preview?.videoGravity = AVLayerVideoGravityResizeAspectFill
    preview?.cornerRadius = 5

    return preview!
  }()

  var assetExport: AVAssetExportSession?

  enum SessionPreset {
    case photo
    case video
  }

  var watermarkLoaded: Bool = false {
    didSet {
      var isEnable = false
      if !watermarkLoaded {
        isEnable = false
      } else if cameraReady {
        isEnable = true
      }
      DispatchQueue.main.async {
        self.updateWatermarksButton.isEnabled = isEnable
        self.recordVideoButton.isEnabled = isEnable
        self.shotPhotoButton.isEnabled = isEnable
        self.galleryButton.isEnabled = isEnable
        self.updateWatermarksButton.isEnabled = isEnable
      }
    }
  }
  var cameraReady: Bool = false {
    didSet {
      var isEnable = false
      if !cameraReady {
        isEnable = false
      } else if watermarkLoaded {
        isEnable = true
      }
      DispatchQueue.main.async {
        self.updateWatermarksButton.isEnabled = isEnable
        self.recordVideoButton.isEnabled = isEnable
        self.shotPhotoButton.isEnabled = isEnable
        self.galleryButton.isEnabled = isEnable
        self.updateWatermarksButton.isEnabled = isEnable
      }
    }
  }

  var watermarks: [URL] = []
  var watermarkCount = 0
  var cameraPosition: AVCaptureDevicePosition = .back
  var cameraType: SessionPreset = .photo {
    didSet {
      var videoImage: UIImage!
      var photoImage: UIImage!
      var selector: UIImage!
      var isVideo: Bool!
      switch cameraType {
      case .video:
        isVideo = false
        videoImage = UIImage(imageLiteralResourceName: "video_on")
        photoImage = UIImage(imageLiteralResourceName: "camera_off")
        selector = UIImage(imageLiteralResourceName: "selector_video")
        break
      case .photo:
        isVideo = true
        videoImage = UIImage(imageLiteralResourceName: "video_off")
        photoImage = UIImage(imageLiteralResourceName: "camera_on")
        selector = UIImage(imageLiteralResourceName: "selector_photo")
        break
      }
      DispatchQueue.main.async {
        self.cameraPhotoImage.image = photoImage
        self.cameraVideoImage.image = videoImage
        self.selectorButton.setBackgroundImage(selector, for: .normal)

        self.recordVideoButton.isHidden = isVideo
        self.shotPhotoButton.isHidden = !isVideo
      }
    }
  }

  let imagePiker = UIImagePickerController()

  var movieFileOutput = AVCaptureMovieFileOutput()
  var imageFileOutput: AVCaptureStillImageOutput = {
    let output = AVCaptureStillImageOutput()
    output.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]

    return output
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

      refreshWatermarks()
      setupCameraSession()
      startCameraSession()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)


    stopCameraSession()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnSwipe = false
  }


  func shotPhoto() {
    if let connection = imageFileOutput.connection(withMediaType: AVMediaTypeVideo) {
      imageFileOutput.captureStillImageAsynchronously(from: connection, completionHandler: { (buffer, error) in
        if let error = error {
          print(error.localizedDescription)
          return
        }
        let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
        if let image = UIImage(data: (imageData)!) {
          KRProgressHUD.show()
          self.save(image: image)
          self.exportImageWithWatermark(image)
        }
      })
    }
  }

  func recordVideo() {
    var isRecording: Bool!
    if movieFileOutput.isRecording {
      movieFileOutput.stopRecording()
      isRecording = false
      KRProgressHUD.show()
    } else {
      movieFileOutput.connection(withMediaType: AVMediaTypeVideo)
      movieFileOutput.startRecording(toOutputFileURL: URL(fileURLWithPath: videoFileLocation()), recordingDelegate: self)
      isRecording = true
    }
    DispatchQueue.main.async {
      self.recordVideoButton.isSelected = isRecording
      self.switchCameraButton.isEnabled = !isRecording
      self.selectorButton.isEnabled = !isRecording
    }
  }

  func exportImageWithWatermark(_ image: UIImage) {

    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

    let scale: CGFloat// = max(image.size.width, image.size.height) / UIScreen.main.bounds.width

    if image.size.width < image.size.height {
      scale = previewLayer.frame.width / image.size.width
    } else {
      scale = previewLayer.frame.width / image.size.height
    }

    let width = min(image.size.width, image.size.height)

    var imageRef = image.cgImage?.cropping(to: CGRect(x: 0, y: 0, width: width, height: width))

    let offsetX = previewLayer.frame.origin.x * scale
    let offsetY = previewLayer.frame.origin.y * scale
    let offsetWidth = width - offsetX
    let offsetHeight = width - offsetY

    let rect = CGRect(x: offsetX, y: offsetY, width: offsetWidth, height: offsetHeight)

    imageRef = image.cgImage?.cropping(to: rect)
    let img = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
    guard let watermark = watermarkImage.image else {
      return
    }

    var newImage: UIImage!

    let blockOperation = BlockOperation {
      UIGraphicsBeginImageContext(CGSize(width: offsetWidth, height: offsetHeight))
      img.draw(in: CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height))
      watermark.draw(in: CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height))

      newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
    }

    blockOperation.completionBlock = {

      self.save(image: newImage)
      DispatchQueue.main.async {
        KRProgressHUD.dismiss()
      }
    }
    OperationQueue.main.addOperation(blockOperation)
  }

  func exportVideoWithWatermark(to fileURL: URL, rotate: Bool) {
    if !KRProgressHUD.isVisible {
      KRProgressHUD.show()
    }
    let asset = AVURLAsset(url: fileURL, options: nil)
    let videoComposition = AVMutableVideoComposition()

    let clipVideoTrack = asset.tracks(withMediaType: AVMediaTypeVideo).first!

    let originalSize = clipVideoTrack.naturalSize

    var scale: CGFloat

    if originalSize.width < originalSize.height {
      scale = previewLayer.frame.size.width / originalSize.width
    } else {
      scale = previewLayer.frame.size.width / originalSize.height
    }

    let scaledSize = originalSize.width * scale
    let x = (previewLayer.frame.width * 0.5 - scaledSize * 0.5) / scale

    var rotateTransform = clipVideoTrack.preferredTransform
    rotateTransform.c = -1

    let finalTransform = rotateTransform.translatedBy(x: x, y: 0)

    let rotateLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
    rotateLayerInstruction.setTransform(finalTransform, at: kCMTimeZero)

    let cropWidth = min(originalSize.width, originalSize.height)
    let cropHeight = min(originalSize.width, originalSize.height)

    let instruction = AVMutableVideoCompositionInstruction()

    let size = CGSize(width: cropWidth, height: cropHeight)
    guard let watermark = watermarkImage.image else {
      return
    }
    let watermarkLayer = CALayer()
    watermarkLayer.contents = watermark.cgImage
    watermarkLayer.frame = CGRect(origin: .zero, size: size)
    watermarkLayer.opacity = 0.8

    let videoLayer = CALayer()
    videoLayer.frame = CGRect(origin: .zero, size: size)

    let parentLayer = CALayer()
    parentLayer.frame = CGRect(origin: .zero, size: size)
    parentLayer.addSublayer(videoLayer)
    parentLayer.addSublayer(watermarkLayer)

    videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)



    instruction.layerInstructions = [rotateLayerInstruction]
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration)

    videoComposition.renderSize = CGSize(width: cropWidth, height: cropHeight)
    videoComposition.frameDuration = CMTimeMake(1, 30)

    videoComposition.instructions = [instruction]

    let filePath = NSTemporaryDirectory() + fileName("mov")
    let movieURL = URL(fileURLWithPath: filePath)

    guard let assetExport = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else { return }
    assetExport.videoComposition = videoComposition
    assetExport.outputFileType = AVFileTypeQuickTimeMovie
    assetExport.outputURL = movieURL

    assetExport.exportAsynchronously {
      switch assetExport.status {
      case .completed:

        self.saveVideo(by: movieURL)

        DispatchQueue.main.async {
          KRProgressHUD.dismiss()
        }
        break
      default:
        DispatchQueue.main.async {
          KRProgressHUD.dismiss()
        }
        break
      }
    }
  }

  func save(image: UIImage) {
    PHPhotoLibrary.shared().performChanges({ 
      let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
      self.getAlbum { (album) in
        if let album = album, let assetPlaceholder = assetRequest.placeholderForCreatedAsset {
          let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
          let assetPlaceholders: NSArray = [assetPlaceholder]

          albumChangeRequest?.addAssets(assetPlaceholders)
        }
      }
    }, completionHandler: nil)
  }

  func saveVideo(by path: URL) {
    PHPhotoLibrary.shared().performChanges({ 
      let assetRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: path)
      self.getAlbum { (album) in
        if let album = album, let assetPlaceholder = assetRequest?.placeholderForCreatedAsset {
          let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
          let assetPlaceholders: NSArray = [assetPlaceholder]

          albumChangeRequest?.addAssets(assetPlaceholders)
        }
      }
    }, completionHandler: nil)
  }

  func getAlbum(complition: @escaping (_ album: PHAssetCollection?) -> Void) {
    let options = PHFetchOptions()
    options.predicate = NSPredicate(format: "title=%@", "Green Book")
    let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
    if let album = collection.firstObject {
      complition(album)
      return
    }
    var placeholder: PHObjectPlaceholder?
    PHPhotoLibrary.shared().performChanges({ 
      let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "Green Book")
      placeholder = request.placeholderForCreatedAssetCollection
    }) { (success, error) in
      if success, let id = placeholder?.localIdentifier {
        let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [id], options: nil)
        if let album = fetchResult.firstObject {
          complition(album)
        }
      }
    }
  }

  func fileName(_ type: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMddyyhhmmss"
    return formatter.string(from: Date()) + "." + type
  }

  func videoFileLocation() -> String {
    let fileManager = FileManager.default
    let filePath = NSTemporaryDirectory().appending("video_file.mov")
    if fileManager.fileExists(atPath: filePath) {
      try? fileManager.removeItem(atPath: filePath)
    }
    return filePath
  }

  func setupCameraSession() {

    DispatchQueue.global(qos: .background).async {
      self.captureSession.sessionPreset = self.cameraType == .video ? AVCaptureSessionPresetHigh : AVCaptureSessionPresetPhoto

      guard let videoDevice = self.device(with: self.cameraPosition), let audioDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio) else { return }
      var videoDeviceInput: AVCaptureDeviceInput!
      var audioDeviceInput: AVCaptureDeviceInput!
      do {
        videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
        audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)

      } catch {
        print(error.localizedDescription)
      }
      if self.captureSession.canAddInput(videoDeviceInput) {
        self.captureSession.addInput(videoDeviceInput)
      }
      if self.captureSession.canAddInput(audioDeviceInput) {
        self.captureSession.addInput(audioDeviceInput)
      }
      if self.captureSession.canAddOutput(self.imageFileOutput) {
        self.captureSession.addOutput(self.imageFileOutput)
      }
    }
  }

  func device(with position: AVCaptureDevicePosition) -> AVCaptureDevice? {
    let device = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
    let deviceCamera = device?.first(where: { (inputDevice) -> Bool in
      if let device = inputDevice as? AVCaptureDevice {
        return device.position == self.cameraPosition
      } else {
        return false
      }
    })

    return deviceCamera as? AVCaptureDevice
  }

  func startCameraSession() {
    let rootLayer: CALayer = surfaceConteinerView.layer
    rootLayer.masksToBounds = true

    let origin = CGPoint(x: surfaceConteinerView.bounds.origin.x + 14.3, y: surfaceConteinerView.bounds.origin.y + 14.3)
    let size = CGSize(width: watermarkImage.bounds.width + 22.7, height: watermarkImage.bounds.height + 22.7)

    previewLayer.frame = CGRect(origin: origin, size: size)
    rootLayer.addSublayer(previewLayer)

    cameraReady = true
    captureSession.startRunning()
  }

  func stopCameraSession() {
    DispatchQueue.global().async {
      self.previewLayer.removeFromSuperlayer()
      self.captureSession.stopRunning()
    }
  }

  func getMediaFromGallery() {
    getAlbum { (album) in
      if let album = album {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let library = storyboard.instantiateViewController(withIdentifier: "photo") as! LibraryCollectionViewController
        library.album = album
        DispatchQueue.main.async {
          self.navigationController?.pushViewController(library, animated: true)
        }
      }
    }
  }

  func switchCameraType() {
    KRProgressHUD.show()

    let blockOperation = BlockOperation {
      self.cameraType = self.cameraType == .video ? .photo : .video

      self.captureSession.beginConfiguration()

      self.captureSession.sessionPreset = self.cameraType == .video ? AVCaptureSessionPresetHigh : AVCaptureSessionPresetPhoto

      for connection in self.captureSession.outputs {
        let output = connection as! AVCaptureOutput
        self.captureSession.removeOutput(output)
      }
      switch self.cameraType {
      case .video:
        if self.captureSession.canAddOutput(self.movieFileOutput) {
          self.captureSession.addOutput(self.movieFileOutput)
        }
        break
      case .photo:
        if self.captureSession.canAddOutput(self.imageFileOutput) {
          self.captureSession.addOutput(self.imageFileOutput)
        }
        break
      }
      self.captureSession.commitConfiguration()
    }

    blockOperation.completionBlock = {
      DispatchQueue.main.async {
        KRProgressHUD.dismiss()
      }
    }

    OperationQueue().addOperation(blockOperation)
  }

  func switchCameraInput() {
    KRProgressHUD.show()

    var image: UIImage!
    let blockOperation = BlockOperation {
      switch self.cameraPosition {
      case .back:
        self.cameraPosition = .front
        image = UIImage(imageLiteralResourceName: "change_camera_front")
        break
      case .front:
        self.cameraPosition = .back
        image = UIImage(imageLiteralResourceName: "change_camera_back")
        break
      default: break
      }

      self.captureSession.beginConfiguration()

      var existingConnection: AVCaptureDeviceInput!

      for connection in self.captureSession.inputs {
        let input = connection as! AVCaptureDeviceInput
        if input.device.hasMediaType(AVMediaTypeVideo) {
          existingConnection = input
        }
      }

      self.captureSession.removeInput(existingConnection)

      if let newDevice = self.device(with: self.cameraPosition) {
        var deviceInput: AVCaptureDeviceInput!
        do {
          deviceInput = try AVCaptureDeviceInput(device: newDevice)
        } catch {
          print(error.localizedDescription)
        }
        if self.captureSession.canAddInput(deviceInput) {
          self.captureSession.addInput(deviceInput)
        }
      }
      self.captureSession.commitConfiguration()
    }

    blockOperation.completionBlock = {

      DispatchQueue.main.async {
        KRProgressHUD.dismiss()
        self.switchCameraButton.setBackgroundImage(image, for: .normal)
      }
    }

    OperationQueue().addOperation(blockOperation)
  }

  func refreshWatermarks() {
    watermarkCount = 0
    watermarkLoaded = false
    KRProgressHUD.show()

    let keychainWrapper = KeychainWrapper()
    if let userId = keychainWrapper.find(itemKey: "login"),
      let userSecure = keychainWrapper.find(itemKey: "pass") {
      NetworkLayer.getWatermarkURLs(user: userId, key: userSecure) { finished, watermarks in
        guard let watermarks = watermarks else { return }

        for watermark in watermarks {
          if let url = URL(string: watermark) {
            self.watermarks.append(url)
          }
        }
        if watermarks.count > 1 {
          DispatchQueue.main.async {
            self.nextWatermarkButton.isEnabled = true
          }
        }
        self.updateWatermark()
      }
    }
  }

  private func updateWatermark() {
    watermarkLoaded = true
    watermarkImage.donwnload(from: watermarks[watermarkCount])
  }

  func changeWatermark(_ sender: UIButton) {
    switch sender {
    case prevWatermarkButton:
      if watermarkCount > 0 {
        watermarkCount -= 1
      }
      if watermarkCount == 0 {
        DispatchQueue.main.async {
          self.prevWatermarkButton.isEnabled = false
        }
      } else {
        DispatchQueue.main.async {
          self.nextWatermarkButton.isEnabled = true
        }
      }
      break
    case nextWatermarkButton:
      if watermarkCount < watermarks.count - 1 {
        watermarkCount += 1
      }
      if watermarkCount == watermarks.count - 1 {
        DispatchQueue.main.async {
          self.nextWatermarkButton.isEnabled = false
        }
      } else {
        DispatchQueue.main.async {
          self.prevWatermarkButton.isEnabled = true
        }
      }
      break
    default: break
    }
    updateWatermark()
  }

  fileprivate func setupSurfaceConteinerView() {

    surfaceConteinerView.addSubview(surfaceImage)
    view.addSubview(watermarkImage)


    surfaceConteinerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
    surfaceConteinerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    surfaceConteinerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    surfaceConteinerView.heightAnchor.constraint(equalTo: surfaceConteinerView.widthAnchor).isActive = true

    surfaceImage.topAnchor.constraint(equalTo: surfaceConteinerView.topAnchor).isActive = true
    surfaceImage.bottomAnchor.constraint(equalTo: surfaceConteinerView.bottomAnchor).isActive = true
    surfaceImage.leftAnchor.constraint(equalTo: surfaceConteinerView.leftAnchor).isActive = true
    surfaceImage.rightAnchor.constraint(equalTo: surfaceConteinerView.rightAnchor).isActive = true

    watermarkImage.topAnchor.constraint(equalTo: surfaceConteinerView.topAnchor, constant: 25).isActive = true
    watermarkImage.bottomAnchor.constraint(equalTo: surfaceConteinerView.bottomAnchor, constant: -25).isActive = true
    watermarkImage.leftAnchor.constraint(equalTo: surfaceConteinerView.leftAnchor, constant: 25).isActive = true
    watermarkImage.rightAnchor.constraint(equalTo: surfaceConteinerView.rightAnchor, constant: -25).isActive = true
  }

  func setupNavBar() {
    guard let navBar = self.navigationController?.navigationBar else {
      return
    }

    navBar.isHidden = false
    navBar.setBackgroundImage(UIImage(), for: .default)
    navBar.shadowImage = UIImage()
  }

  private func setupViews() {

    setupNavBar()

    KRProgressHUD.set(style: .black)

    view.backgroundColor = mainColor

    view.addSubview(surfaceConteinerView)

    setupSurfaceConteinerView()



    view.addSubview(cameraVideoImage)
    view.addSubview(cameraPhotoImage)
    view.addSubview(selectorButton)
    view.addSubview(switchCameraButton)
    view.addSubview(galleryButton)
    view.addSubview(updateWatermarksButton)
    view.addSubview(recordVideoButton)
    view.addSubview(shotPhotoButton)
    view.addSubview(prevWatermarkButton)
    view.addSubview(nextWatermarkButton)

    cameraVideoImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
    cameraVideoImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width * 0.02).isActive = true
    cameraVideoImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
    cameraVideoImage.widthAnchor.constraint(equalToConstant: 30).isActive = true

    cameraPhotoImage.bottomAnchor.constraint(equalTo: cameraVideoImage.bottomAnchor).isActive = true
    cameraPhotoImage.leftAnchor.constraint(equalTo: cameraVideoImage.rightAnchor, constant: 10).isActive = true
    cameraPhotoImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
    cameraPhotoImage.widthAnchor.constraint(equalToConstant: 30).isActive = true

    selectorButton.bottomAnchor.constraint(equalTo: cameraVideoImage.topAnchor, constant: -5).isActive = true
    selectorButton.leftAnchor.constraint(equalTo: cameraVideoImage.leftAnchor).isActive = true
    selectorButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.24).isActive = true
    selectorButton.heightAnchor.constraint(equalToConstant: 55).isActive = true

    switchCameraButton.bottomAnchor.constraint(equalTo: selectorButton.bottomAnchor).isActive = true
    switchCameraButton.leftAnchor.constraint(equalTo: selectorButton.rightAnchor, constant: 0).isActive = true
    switchCameraButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.24).isActive = true
    switchCameraButton.heightAnchor.constraint(equalToConstant: 55).isActive = true

    galleryButton.bottomAnchor.constraint(equalTo: selectorButton.bottomAnchor).isActive = true
    galleryButton.leftAnchor.constraint(equalTo: switchCameraButton.rightAnchor).isActive = true
    galleryButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.24).isActive = true
    galleryButton.heightAnchor.constraint(equalToConstant: 55).isActive = true

    updateWatermarksButton.bottomAnchor.constraint(equalTo: selectorButton.bottomAnchor).isActive = true
    updateWatermarksButton.leftAnchor.constraint(equalTo: galleryButton.rightAnchor).isActive = true
    updateWatermarksButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.24).isActive = true
    updateWatermarksButton.heightAnchor.constraint(equalToConstant: 55).isActive = true

    recordVideoButton.topAnchor.constraint(equalTo: surfaceConteinerView.bottomAnchor).isActive = true
    recordVideoButton.bottomAnchor.constraint(equalTo: selectorButton.topAnchor).isActive = true
    recordVideoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    recordVideoButton.widthAnchor.constraint(equalTo: recordVideoButton.heightAnchor, multiplier: 1).isActive = true

    shotPhotoButton.topAnchor.constraint(equalTo: surfaceConteinerView.bottomAnchor).isActive = true
    shotPhotoButton.bottomAnchor.constraint(equalTo: selectorButton.topAnchor).isActive = true
    shotPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    shotPhotoButton.widthAnchor.constraint(equalTo: shotPhotoButton.heightAnchor, multiplier: 1).isActive = true

    prevWatermarkButton.centerYAnchor.constraint(equalTo: recordVideoButton.centerYAnchor).isActive = true
    prevWatermarkButton.rightAnchor.constraint(equalTo: recordVideoButton.leftAnchor).isActive = true
    prevWatermarkButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    prevWatermarkButton.widthAnchor.constraint(equalToConstant: 55).isActive = true

    nextWatermarkButton.centerYAnchor.constraint(equalTo: recordVideoButton.centerYAnchor).isActive = true
    nextWatermarkButton.leftAnchor.constraint(equalTo: recordVideoButton.rightAnchor).isActive = true
    nextWatermarkButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    nextWatermarkButton.widthAnchor.constraint(equalToConstant: 55).isActive = true

    previewLayer.bounds = watermarkImage.bounds
    previewLayer.position = CGPoint(x: watermarkImage.bounds.midX, y: watermarkImage.bounds.midY)

    watermarkImage.layer.addSublayer(previewLayer)
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  func share(file: URL) {
    let activityVC = UIActivityViewController(activityItems: [file], applicationActivities: [])
    self.present(activityVC, animated: true)
  }

  func handleBackHome() {
    DispatchQueue.main.async {
      self.navigationController?.popToRootViewController(animated: true)
    }
  }
}

extension RecordViewController: AVCaptureFileOutputRecordingDelegate {
  func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {

    saveVideo(by: outputFileURL)

    exportVideoWithWatermark(to: outputFileURL, rotate: true)
  }
}

extension RecordViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

    dismiss(animated: true, completion: nil)
    share(file: info[UIImagePickerControllerReferenceURL] as! URL)
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}
