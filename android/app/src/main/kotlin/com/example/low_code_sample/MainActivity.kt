package com.example.low_code_sample

import android.app.PictureInPictureParams
import android.os.Build
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import android.content.res.Configuration
import android.os.Bundle
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.pip"
    private var flutterEngine: FlutterEngine? = null
    private var isWebViewDestroyed = false
    private var isInPictureInPictureMode = false
    private var isConnected=false
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        this.flutterEngine = flutterEngine

        flutterEngine.dartExecutor.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
                when (call.method) {
                    "enterPiPMode" -> {
                        enterPiPMode()
                        result.success(null)
                    } "isConnected"->{
                        isConnected=true

                    }

                    else -> result.notImplemented()
                }
            }
        }
    }


    private fun enterPiPMode() {
        val aspectRatio = Rational(9, 16)
        val pipBuilder = PictureInPictureParams.Builder()
            .setAspectRatio(aspectRatio)
        enterPictureInPictureMode(pipBuilder.build())
    }

    override fun onUserLeaveHint() {
         if(isConnected) {
             if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                 enterPiPMode()
             }
         }
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        this.isInPictureInPictureMode = isInPictureInPictureMode

        try {
            if (isWebViewDestroyed) {
                sendPipEvent("onPipClosed")
                return

            }
            if (isInPictureInPictureMode) {

                sendPipEvent("onPipEntered")
            } else {
                sendPipEvent("onPipExpanded")
            }
        } catch (e: IllegalStateException) {
            // Handle case where Flutter engine is not available
            //  Log.e("MainActivity", "Flutter engine not available", e)
        }

    }

    private fun sendPipEvent(event: String) {
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            runOnUiThread {
                try {
                    MethodChannel(messenger, CHANNEL).invokeMethod(event, null)
                } catch (e: Exception) {
                    //  Log.e("PIP", "Error sending $event", e)
                }
            }
        }

    }

    override fun onStop() {
        super.onStop()
        if (isInPictureInPictureMode) {
            isWebViewDestroyed = true


        }
    }


        override fun onDestroy() {
            // Clean up references
            flutterEngine = null
            isWebViewDestroyed = true
            super.onDestroy()
        }
    }

