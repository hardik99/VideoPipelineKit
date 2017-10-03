//
//  RecordingViewController.swift
//  VideoPipelineKit
//
//  Created by pat2man on 09/20/2017.
//  Copyright (c) 2017 pat2man. All rights reserved.
//

import UIKit
import VideoPipelineKit
import CameraManager
import AVKit

class RecordingViewController: UIViewController {
    lazy var cameraManager: CameraManager = {
        let cameraManager = CameraManager()
        cameraManager.cameraOutputMode = .videoOnly
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.cameraDevice = .front
        cameraManager.showErrorBlock = { (erTitle: String, erMessage: String) in
            assertionFailure(erMessage)
        }
        return cameraManager
    }()

    @IBAction func startRecording(_ sender: Any) {
        cameraManager.startRecordingVideo()
    }

    @IBOutlet weak var cameraView: UIView!

    @IBAction func stopRecording(_ sender: Any) {
        cameraManager.stopVideoRecording { (url, error) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }

            if let url = url {
                let asset = AVURLAsset(url: url)
                self.performSegue(withIdentifier: "Edit Media", sender: asset)
            }
        }
    }

    @IBAction func cancelEditing(_ sender: UIStoryboardSegue) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        _ = cameraManager.addPreviewLayerToView(cameraView)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let editingViewController = segue.destination as? MediaEditingViewController {
            editingViewController.asset = sender as? AVURLAsset
        }
    }
}
