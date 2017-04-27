//
//  LiveViewController.swift
//  ZW-DouYu-Swift3.0
//
//  Created by xuxichen on 2017/2/24.
//  Copyright © 2017年 xxc. All rights reserved.
//

import UIKit
import AVFoundation

class LiveViewController: UIViewController {

    fileprivate lazy var videoQueue = DispatchQueue.global()
    fileprivate lazy var audioQueue = DispatchQueue.global()
    
    fileprivate lazy var session: AVCaptureSession = AVCaptureSession()
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    
    fileprivate var vedioInput: AVCaptureDeviceInput?
    fileprivate var videoOutput: AVCaptureVideoDataOutput?
    fileprivate var movieOutput: AVCaptureMovieFileOutput?
}

extension LiveViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        //        //依然保持手势
        //        navigationController?.interactivePopGestureRecognizer?.delegate = self
        //        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func starCapture() {
        //1.设置视频的输入输出
        setupVideo()
        
        //2.设置音频的输入输出
        setupAudio()
        
        //3.添加写入文件的output
        let movieOutput = AVCaptureMovieFileOutput()
        session.addOutput(movieOutput)
        self.movieOutput = movieOutput
        //3.1设置写入的稳定性
        let connection = movieOutput.connection(withMediaType: AVMediaTypeVideo)
        connection?.preferredVideoStabilizationMode = .auto
        
        //4.给用户看到一个预览图层（）
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
        
        //5.开始采集
        session.startRunning()
        
        //6.开始将采集的画面写入到文件中
        let path = NSHomeDirectory() + "/Documents/123.mp4"
        let url = URL(fileURLWithPath: path)
        movieOutput.startRecording(toOutputFileURL: url, recordingDelegate: self)
    }
    
    @IBAction func stopCapture() {
        
        movieOutput?.stopRecording()
        
        session.stopRunning()
        previewLayer.removeFromSuperlayer()
    }
    
    
    @IBAction func switchScene() {
        //1.获取当前的摄像头
        guard var position = vedioInput?.device.position else { return }
        print(position)
        //2.获取当前显示的镜头
        position = position == .front ? .back : .front
        
        //3.根据当前镜头创建新的Device
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice] else {
            print("当前摄像头不可用")
            return
        }
        guard let device = devices.filter({ $0.position == position}).first else { return }
        
        //4.根据新的device创建新的input
        guard let vedioInput = try? AVCaptureDeviceInput(device: device) else { return }
        
        //5.在session中切换Input
        session.beginConfiguration()
        session.removeInput(self.vedioInput)
        session.addInput(vedioInput)
        session.commitConfiguration()
        self.vedioInput = vedioInput
        
    }
}
extension LiveViewController {
    fileprivate func setupVideo() {
        //1.创建捕捉会话
        
        //2.给捕捉会话设置输入源（摄像头）
        //2.1获取摄像头设备
        guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice] else {
            print("当前摄像头不可用")
            return
        }
        //第一种取到摄像头的方法
        /*
         var device: AVCaptureDevice!
         for devicetype in devices {
         if devicetype.position == .front {
         device = devicetype
         break
         }
         }
         */
        
        //第二种取到摄像头的方法
        /*
         let device = devices.filter { (device: AVCaptureDevice) -> Bool in
         return device.position == .front
         }.first
         */
        //第三种获取摄像头的方法
        guard let device = devices.filter({ $0.position == .back}).first else { return }
        
        //2.2通过device创建AVCaptureInput对象
        guard let vedioInput = try? AVCaptureDeviceInput(device: device) else { return }
        self.vedioInput = vedioInput
        //2.3将input添加到会话中
        session.addInput(vedioInput)
        
        //3.给捕捉会话设置输出源
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        session.addOutput(videoOutput)
        
        //3.获取Video对应的Output
        self.videoOutput = videoOutput
        
    }
    
    fileprivate func setupAudio() {
        //1 设置音频的输入（话筒）
        //1.1获取话筒设备
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio) else { return }
        
        //1.2根据device创建AVCaptureInput
        guard let audioInput = try? AVCaptureDeviceInput(device: device) else { return }
        
        //1.3将input添加到会话中
        session.addInput(audioInput)
        
        //2.给会话设置音频输出源
        let audioOutput = AVCaptureAudioDataOutput()
        audioOutput.setSampleBufferDelegate(self, queue: audioQueue)
        session.addOutput(audioOutput)
    }
}
//MARK: 获取数据
extension LiveViewController: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if connection == self.videoOutput?.connection(withMediaType: AVMediaTypeVideo) {
            print("采集到视频数据")
        } else {
            print("采集到音频数据")
        }
    }
}

extension LiveViewController: AVCaptureFileOutputRecordingDelegate {
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        print("开始写入文件")
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print("结束写入文件")
    }
}
