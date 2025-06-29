import 'dart:io';

Future<bool> connectionInfo() async {
  try {
    final result = await InternetAddress.lookup("youtube.com");
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  } catch (e) {
    return false;
  }
}