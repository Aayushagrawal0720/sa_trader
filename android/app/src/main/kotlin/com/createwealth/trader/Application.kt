package com.createwealth.trader

import android.os.Bundle
import io.flutter.app.FlutterApplication
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin
import java.net.NetworkInterface
import java.util.*


import android.os.Environment
import androidx.annotation.NonNull;
import com.google.firebase.messaging.Constants
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File
import java.lang.reflect.Method
import java.util.*
import kotlin.collections.ArrayList

import com.google.firebase.messaging.Constants.MessageNotificationKeys.CHANNEL

class Application() : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {

     override fun registerWith(registry: PluginRegistry?) {
        val key: String? = FlutterFirebaseMessagingPlugin::class.java.canonicalName
        if (!registry?.hasPlugin(key)!!) {
            FlutterFirebaseMessagingPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin"));
        }

    }

}