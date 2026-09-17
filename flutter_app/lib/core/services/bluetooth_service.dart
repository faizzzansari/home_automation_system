import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothService {
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;

  BluetoothService._internal();

  BluetoothConnection? _connection;

  bool get isConnected => _connection != null && _connection!.isConnected;

  Future<List<BluetoothDevice>> getPairedDevices() async {
    return await FlutterBluetoothSerial.instance.getBondedDevices();
  }

  Future<void> connect(String address) async {
    _connection = await BluetoothConnection.toAddress(address);
  }

  void sendCommand(String command) {
    if (isConnected) {
      _connection!.output.add(Uint8List.fromList(command.codeUnits));
    }
  }

  void disconnect() {
    _connection?.dispose();
    _connection = null;
  }
}
