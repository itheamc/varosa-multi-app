//
//  NativeButtonViewFactory.swift
//  Runner
//
//  Created by Amit on 06/08/2025.
//

import Foundation
import Flutter

class NativeButtonFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return NativeButtonView(frame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: messenger)
    }
}
