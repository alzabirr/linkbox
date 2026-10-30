package com.example.linkbox

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Opened from the Android share sheet. Runs `shareMain()` in
 * lib/share_main.dart on a see-through window, so the "Saved!" card
 * shows on top of the app the user shared from.
 */
class ShareActivity : FlutterActivity() {
    override fun getDartEntrypointFunctionName() = "shareMain"

    override fun getDartEntrypointLibraryUri() = "package:linkbox/share_main.dart"

    override fun getBackgroundMode() = BackgroundMode.transparent

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "linkbox/share")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getShared" -> result.success(
                        mapOf(
                            "text" to intent?.getStringExtra(Intent.EXTRA_TEXT),
                            "subject" to intent?.getStringExtra(Intent.EXTRA_SUBJECT),
                        )
                    )
                    "openInApp" -> {
                        val id = call.argument<Int>("id")
                        startActivity(
                            Intent(this, MainActivity::class.java).apply {
                                action = Intent.ACTION_VIEW
                                data = Uri.parse("linkbox://open/link/$id")
                                addFlags(
                                    Intent.FLAG_ACTIVITY_NEW_TASK or
                                        Intent.FLAG_ACTIVITY_SINGLE_TOP or
                                        Intent.FLAG_ACTIVITY_CLEAR_TOP
                                )
                            }
                        )
                        result.success(null)
                        finish()
                    }
                    "close" -> {
                        result.success(null)
                        finish()
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
