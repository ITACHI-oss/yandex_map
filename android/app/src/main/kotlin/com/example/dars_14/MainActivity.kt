package com.example.dars_14

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.yandex.mapkit.MapKitFactory

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("9a9d71c3-7be1-420a-8923-c02de6b44c38")
        super.configureFlutterEngine(flutterEngine)
    }
}
