import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class FireBaseCrashlyticsCatch {
  void onErrorCatch(
      {String error = "", StackTrace? stackTrace, String reason = ""}) {
    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: reason,
    );
  }
}
