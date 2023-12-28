// ignore_for_file: override_on_non_overriding_member, unused_local_variable, prefer_final_fields, avoid_print

import 'package:device_info_plus/device_info_plus.dart';
import 'package:groovix/db_funtion/functions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class GetAudio {
  OnAudioQuery _audioQuery = OnAudioQuery();
  late Future<List<SongModel>> s;

  @override
  void requestPermision() async {
    print('hellow');
    bool perm = false;

    int version = await checkAndroidVersion();
    if (version >= 32) {
      perm = await checkPermission13();
    } else {
      perm = await checkPermission12();
    }
    print("13per $perm");
    if (perm == true) {
      s = getaudio();
    }

    print('hi $s');
  }

  checkPermission12() async {
    var p = await Permission.storage.request();
    if (p.isGranted) {
      return true;
    }
    return false;
  }

  checkPermission13() async {
    final per = await [Permission.audio, Permission.photos].request();
   

    if (per.values.every((status) =>
        status == PermissionStatus.granted )) {
      return true;
    } else {
      print('hellow per');
      return false;
    }
  }

  Future<int> checkAndroidVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    int androidVersion = androidInfo.version.sdkInt;
    print('Android Version: $androidVersion');
    return androidVersion;
  }

  Future<List<SongModel>> getaudio() async {
    List<SongModel> s = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true);
    for (SongModel a in s) {
      print(a.title);
    }
    s = s;
    addSong(s: s);
    return s;
  }
}
