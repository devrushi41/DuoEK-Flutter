// ignore_for_file: file_names, avoid_print

import 'package:flutter_blue/flutter_blue.dart';

class DuoEK {
  static FlutterBlue flutterBlue = FlutterBlue.instance;

  static const _serviceUuid = "14839ac4-7d7e-415c-9a42-167340cf2339";
  static const _writeUuid = "8B00ACE7-EB0B-49B0-BBE9-9AEE0A26E1A3";
  static const _notifyUuid = "0734594A-A8E7-4B1A-A6B1-CD5243059A57";

  static BluetoothDevice? _device;

  static scanForDevices() async {
    flutterBlue.startScan(
        timeout: const Duration(seconds: 5),
        withServices: [Guid(_serviceUuid)]);
    flutterBlue.scanResults.listen((List<ScanResult> results) async {
      // do something with scan results
      for (ScanResult r in results) {
        _device = r.device;
        break;
      }
    });
    flutterBlue.stopScan();

    if (_device != null) {
      await _device!.connect();
      List<BluetoothService> services = await _device!.discoverServices();
      for (BluetoothService service in services) {
        print(service.uuid.toString());
      }
      await _device!.disconnect();
    }
  }
}



// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'UniversalBleCmd.dart';

// class DuoEK {
//   static final _ble = FlutterReactiveBle();
//   static String connectedDeviceId = "";
//   static final _serviceUuid =
//       Uuid.parse("14839ac4-7d7e-415c-9a42-167340cf2339");
//   static final _writeUuid = Uuid.parse("8B00ACE7-EB0B-49B0-BBE9-9AEE0A26E1A3");
//   static final _notifyUuid = Uuid.parse("0734594A-A8E7-4B1A-A6B1-CD5243059A57");

//   static bool scanDevice() {
//     _ble.scanForDevices(withServices: [
//       _serviceUuid
//     ], scanMode: ScanMode.balanced).listen(
//         (DiscoveredDevice device) => {connectDevice(device.id)},
//         onError: (error) => {print(error.toString())});
//     return true;
//   }

//   static bool connectDevice(deviceId) {
//     _ble
//         .connectToDevice(
//       id: deviceId,
//       servicesWithCharacteristicsToDiscover: {
//         _serviceUuid: [_writeUuid, _notifyUuid]
//       },
//       connectionTimeout: const Duration(seconds: 2),
//     )
//         .listen((ConnectionStateUpdate connectionState) {
//       int count = 0;
//       switch (connectionState.connectionState) {
//         case DeviceConnectionState.connected:
//           if (count == 0) {
//             connectedDeviceId = deviceId;
//             getRTData();
//             print("Connected");
//             count++;
//           }
//           break;
//         case DeviceConnectionState.connecting:
//           print("Loading");
//           break;
//         case DeviceConnectionState.disconnected:
//           print("Disconnected");
//           break;
//         case DeviceConnectionState.disconnecting:
//           print("Disconnecting");
//           break;
//         default:
//       }
//       // Handle connection state updates
//     }, onError: (Object error) {
//       // Handle a possible error
//     });
//     return true;
//   }

//   static Future<void> getRTData() async {
//     // write to charateristic of the rtdata cmd
//     final writeCharacteristic = QualifiedCharacteristic(
//         characteristicId: _writeUuid,
//         serviceId: _serviceUuid,
//         deviceId: connectedDeviceId);

//     await _ble.writeCharacteristicWithResponse(writeCharacteristic,
//         value: UniversalBleCmd.getRtData());

//     final notifyCharacteristic = QualifiedCharacteristic(
//         characteristicId: _notifyUuid,
//         serviceId: _serviceUuid,
//         deviceId: connectedDeviceId);

//     _ble.subscribeToCharacteristic(notifyCharacteristic).listen(
//         (data) => {print(data)},
//         onError: (error) => print(error.toString()));
//   }
// }

