import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/device_list_item_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/permission_denied_widget.dart';
import '../../core/services/bluetooth_service.dart';

class BluetoothConnectionScreen extends StatefulWidget {
  const BluetoothConnectionScreen({super.key});

  @override
  State<BluetoothConnectionScreen> createState() =>
      _BluetoothConnectionScreenState();
}

class _BluetoothConnectionScreenState extends State<BluetoothConnectionScreen>
    with SingleTickerProviderStateMixin {
  bool _isScanning = false;
  bool _permissionGranted = false;
  bool _permissionChecked = false;
  int? _connectingIndex;
  late AnimationController _scanAnimController;
  late Animation<double> _scanRotation;
  Timer? _scanTimer;

  final List<Map<String, dynamic>> _discoveredDevices = [];

  @override
  void initState() {
    super.initState();
    _scanAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scanRotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scanAnimController, curve: Curves.linear),
    );
    _checkPermissions();
  }

  @override
  void dispose() {
    _scanAnimController.dispose();
    _scanTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    final bluetoothScan = await Permission.bluetoothScan.status;
    final bluetoothConnect = await Permission.bluetoothConnect.status;
    final location = await Permission.locationWhenInUse.status;

    setState(() {
      _permissionGranted =
          (bluetoothScan.isGranted || bluetoothScan.isLimited) &&
          (bluetoothConnect.isGranted || bluetoothConnect.isLimited) &&
          (location.isGranted || location.isLimited);
      _permissionChecked = true;
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();

    final bluetoothScan = await Permission.bluetoothScan.status;
    final bluetoothConnect = await Permission.bluetoothConnect.status;
    final location = await Permission.locationWhenInUse.status;

    setState(() {
      _permissionGranted =
          (bluetoothScan.isGranted || bluetoothScan.isLimited) &&
          (bluetoothConnect.isGranted || bluetoothConnect.isLimited) &&
          (location.isGranted || location.isLimited);
    });

    if (_permissionGranted) {
      await _startScan();
    }
  }

  Future<void> _startScan() async {
    if (!_permissionGranted) {
      await _requestPermissions();
      return;
    }

    setState(() {
      _isScanning = true;
      _discoveredDevices.clear();
    });

    _scanAnimController.repeat();

    try {
      final devices = await FlutterBluetoothSerial.instance.getBondedDevices();

      setState(() {
        _discoveredDevices.addAll(
          devices
              .map(
                (d) => {
                  'name': d.name ?? "Unknown Device",
                  'address': d.address,
                  'signal': 75,
                  'isConnected': false,
                },
              )
              .toList(),
        );
      });
    } catch (e) {
      debugPrint('Bluetooth scan error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
        _scanAnimController.stop();
        _scanAnimController.reset();
      }
    }
  }

  Future<void> _connectDevice(int index) async {
    final device = _discoveredDevices[index];

    setState(() => _connectingIndex = index);

    try {
      await BluetoothService().connect(device['address']);

      setState(() {
        for (final d in _discoveredDevices) {
          d['isConnected'] = false;
        }
        _discoveredDevices[index]['isConnected'] = true;
        _connectingIndex = null;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connected to ${device['name']}'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint("Connection error: $e");
      if (mounted) {
        setState(() => _connectingIndex = null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to connect to device'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  void _disconnectDevice(int index) {
    setState(() {
      _discoveredDevices[index]['isConnected'] = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Disconnected from ${_discoveredDevices[index]['name']}'),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await _startScan();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        variant: CustomAppBarVariant.bluetooth,
        title: 'Bluetooth Devices',
        showBackButton: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [
                    Color(0xFF0F172A),
                    Color(0xFF111827),
                    Color(0xFF0B1220),
                  ]
                : const [
                    Color(0xFFF8FAFC),
                    Color(0xFFF1F5F9),
                    Color(0xFFEEF4FF),
                  ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
            child: !_permissionChecked
                ? Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  )
                : !_permissionGranted
                ? Column(
                    children: [
                      const Expanded(child: PermissionDeniedWidget()),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: SizedBox(
                          width: double.infinity,
                          height: 6.h,
                          child: ElevatedButton.icon(
                            onPressed: _requestPermissions,
                            icon: CustomIconWidget(
                              iconName: 'bluetooth_searching_rounded',
                              color: Colors.white,
                              size: 5.w,
                            ),
                            label: const Text('Grant & Scan'),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderCard(theme),
                      SizedBox(height: 2.h),
                      _buildScanButton(theme),
                      SizedBox(height: 2.h),
                      if (_discoveredDevices.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(left: 1.w, bottom: 1.h),
                          child: Text(
                            '${_discoveredDevices.length} device(s) found',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      Expanded(
                        child: _isScanning && _discoveredDevices.isEmpty
                            ? _buildScanningIndicator(theme)
                            : !_isScanning && _discoveredDevices.isEmpty
                            ? EmptyStateWidget(onScanAgain: _startScan)
                            : RefreshIndicator(
                                onRefresh: _onRefresh,
                                color: colorScheme.primary,
                                backgroundColor: theme.cardColor,
                                child: ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: _discoveredDevices.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 1.4.h),
                                      child: DeviceListItemWidget(
                                        device: _discoveredDevices[index],
                                        isConnecting: _connectingIndex == index,
                                        onConnect: () => _connectDevice(index),
                                        onDisconnect: () =>
                                            _disconnectDevice(index),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(
          theme.brightness == Brightness.dark ? 0.85 : 0.95,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              theme.brightness == Brightness.dark ? 0.18 : 0.05,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: colorScheme.secondary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.bluetooth_searching_rounded,
              color: colorScheme.secondary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bluetooth Setup',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Scan and connect with nearby paired devices',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanButton(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 6.5.h,
      child: ElevatedButton.icon(
        onPressed: _isScanning ? null : _startScan,
        icon: _isScanning
            ? RotationTransition(
                turns: _scanRotation,
                child: CustomIconWidget(
                  iconName: 'radar',
                  color: Colors.white,
                  size: 5.w,
                ),
              )
            : CustomIconWidget(
                iconName: 'bluetooth_searching_rounded',
                color: Colors.white,
                size: 5.w,
              ),
        label: Text(
          _isScanning ? 'Scanning...' : 'Scan for Devices',
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _isScanning
              ? colorScheme.secondary.withOpacity(0.7)
              : colorScheme.secondary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _buildScanningIndicator(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: _scanRotation,
            child: CustomIconWidget(
              iconName: 'radar',
              color: colorScheme.secondary,
              size: 15.w,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Scanning for devices...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
