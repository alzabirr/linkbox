package com.example.linkbox

import android.content.ContentUris
import android.os.Build
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "linkbox/files")
            .setMethodCallHandler { call, result ->
                try {
                    when (call.method) {
                        "listBackups" -> result.success(listBackups())
                        "readText" -> {
                            val uri = android.net.Uri.parse(call.argument<String>("uri"))
                            val text = contentResolver.openInputStream(uri)
                                ?.use { it.readBytes().toString(Charsets.UTF_8) }
                            result.success(text)
                        }
                        else -> result.notImplemented()
                    }
                } catch (e: Exception) {
                    result.error("files", e.message, null)
                }
            }
    }

    /**
     * Backups in Download/Linkly (or the old Download/Linkbox) that this install of the app wrote.
     * (After a reinstall Android hides older files; the user picks them.)
     */
    private fun listBackups(): List<Map<String, Any>> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) return emptyList()
        val collection = MediaStore.Downloads.EXTERNAL_CONTENT_URI
        val projection = arrayOf(
            MediaStore.Downloads._ID,
            MediaStore.Downloads.DISPLAY_NAME,
            MediaStore.Downloads.SIZE,
            MediaStore.Downloads.DATE_MODIFIED,
        )
        // Also finds backups made before the app was renamed from Linkbox.
        val where = "(${MediaStore.Downloads.RELATIVE_PATH} LIKE ? OR " +
            "${MediaStore.Downloads.RELATIVE_PATH} LIKE ?) AND " +
            "(${MediaStore.Downloads.DISPLAY_NAME} LIKE ? OR " +
            "${MediaStore.Downloads.DISPLAY_NAME} LIKE ?)"
        val args = arrayOf(
            "Download/Linkly%", "Download/Linkbox%",
            "linkly-backup-%.json", "linkbox-backup-%.json",
        )
        val out = mutableListOf<Map<String, Any>>()
        contentResolver.query(
            collection, projection, where, args,
            "${MediaStore.Downloads.DATE_MODIFIED} DESC",
        )?.use { c ->
            while (c.moveToNext()) {
                out.add(
                    mapOf(
                        "uri" to ContentUris.withAppendedId(collection, c.getLong(0)).toString(),
                        "name" to c.getString(1),
                        "size" to c.getLong(2),
                        "modified" to c.getLong(3) * 1000,
                    )
                )
            }
        }
        return out
    }
}
