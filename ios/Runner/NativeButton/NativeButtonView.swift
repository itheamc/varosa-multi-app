//
//  NativeButtonView.swift
//  Runner
//
//  Created by Amit on 06/08/2025.
//

import Foundation
import UIKit
import Flutter

class NativeButtonView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private let channel: FlutterMethodChannel
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        _view = UIView(frame: frame)
        channel = FlutterMethodChannel(name: "native-button-\(viewId)", binaryMessenger: messenger)
        super.init()
        
        let button = UIButton(type: .system)
        let params = args as? [String: Any]
        let text = params?["text"] as? String ?? "Click Here"
        
        button.setTitle(text, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        _view.addSubview(button)
    }
    
    @objc func buttonPressed() {
        channel.invokeMethod("onButtonClick", arguments: nil)
    }
    
    func view() -> UIView {
        return _view
    }
}
