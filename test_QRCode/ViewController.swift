//
//  ViewController.swift
//  test_QRCode
//
//  Created by Gravman on 24.12.2019.
//  Copyright © 2019 Alexandr_P. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class ViewController: UIViewController {

    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideos()
        
    }
    
    func update(history: History){
         let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "historyVC") as! HistoryTableViewController
         vc.update(history: history)
    }
    
    func setupVideos () {
        let session = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {return}
        
        do {
           let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
    }
    
    func startShow () {
        view.layer.addSublayer(video)
        session.startRunning()
    }
    
    @IBAction func showInfo(_ sender: Any) {
        
        startShow()
        
    }
    func saveData (result: String) {
        
        let context = CoreDataManager.shared.persistenContainer.viewContext
        let history = NSEntityDescription.insertNewObject(forEntityName: "History", into: context)
        history.setValue(result, forKey: "result")
        history.setValue(Date(), forKey: "date")
        
        do {
            try context.save()
            if let history = history as? History {
                self.update(history: history)
            }
            print ("Saved")
        } catch {
            print("Error")
        }
        
    }
    func fetch(fetch: History){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "historyVC") as! HistoryTableViewController
        vc.fetchData()
    }
    

}
extension ViewController: AVCaptureMetadataOutputObjectsDelegate{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count > 0 else {return}
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if object.type == AVMetadataObject.ObjectType.qr {
                 
                let alert = UIAlertController(title: "QRCode", message: object.stringValue, preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Run", style: .default, handler: { _ in
                    print(object.stringValue)
                }))
                alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { _ in
                    UIPasteboard.general.string = object.stringValue
                    self.view.layer.sublayers?.removeLast()
                    self.session.stopRunning()
                print(object.stringValue)
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
}

