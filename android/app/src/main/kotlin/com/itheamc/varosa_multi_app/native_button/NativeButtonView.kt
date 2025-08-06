package com.itheamc.varosa_multi_app.native_button

import android.content.Context
import android.util.Log
import android.view.View
import android.widget.Button
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class NativeButtonView(
    context: Context,
    messenger: BinaryMessenger,
    id: Int,
    creationParams: Map<*, *>?
) : PlatformView {

    private val button: Button = Button(context)
    private var _channel: MethodChannel

    init {
        val text = creationParams?.get("text") as? String ?: "Click Here"
        button.text = text
        _channel = MethodChannel(messenger, "native-button-$id")

        button.setOnClickListener {
            _channel.invokeMethod("onButtonClick", null)
        }
    }

    override fun getView(): View = button
    override fun dispose() {}
}
