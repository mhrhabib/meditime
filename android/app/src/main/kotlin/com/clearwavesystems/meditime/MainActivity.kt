package com.clearwavesystems.meditime

import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Mirror AndroidManifest showWhenLocked/turnScreenOn for devices
        // that honor the runtime API over the manifest attributes. Without
        // this, alarm full-screen intents can't wake the device when the
        // screen is off with the keyguard up.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        }
    }
}
