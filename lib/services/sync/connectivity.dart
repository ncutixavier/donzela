import 'package:connectivity_plus/connectivity_plus.dart';

/// True when any network interface is up. Checked before every cloud push so
/// the app never waits on the internet.
Future<bool> isDeviceOnline() async {
  final results = await Connectivity().checkConnectivity();
  return results.any((r) => r != ConnectivityResult.none);
}
