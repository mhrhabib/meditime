# flutter_local_notifications: keep Gson TypeToken generic signatures.
# Without these rules, R8 strips type parameters and rescheduling notifications
# on boot crashes with "Missing type parameter".
-keep class com.dexterous.** { *; }
-keep class com.google.gson.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# alarm package: plugin resolves its receiver/service classes reflectively
# and the BroadcastReceiver must survive R8. Keep the whole package plus
# the media session infra it relies on.
-keep class com.gdelataillade.alarm.** { *; }
-keep class androidx.media.** { *; }
