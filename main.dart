import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hifi/models/networ_details.dart';
import 'package:hifi/shared.dart';
import 'package:hifi/views/host_scanner.dart';
import 'package:hifi/views/network_card.dart';
import 'package:hifi/views/port_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_tools/network_tools.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final info = NetworkInfo();
  NetworkDetails? details;

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  getPermissions() async {
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
  }

  portScanner(String target) async {
    PortScanner.scanPortsForSingleDevice(target, startPort: 1, endPort: 1024,
        progressCallback: (progress) {
      print('Progress for port discovery : $progress');
    }).listen((event) {
      print('Found open port : $event');
    }, onDone: () {
      print('Scan completed');
    });
    //2. Single
    // bool isOpen = PortScanner.isOpen(target, 80);
    // //3. Custom
    // PortScanner.customDiscover(target, portList: const [22, 80, 139]);
  }

  @override
  Widget build(BuildContext context) {
    // final padding = MediaQuery.of(context).padding;
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              const Icon(CupertinoIcons.waveform, color: appColor),
              const SizedBox(width: 4),
              Text(
                "Net Stat",
                style: titleFont.copyWith(
                    fontSize: 20, fontWeight: FontWeight.bold, color: appColor),
              ),
            ],
          )),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            NetworkDetailsCard(),
            HostScannerWid(),
            // PortScannerWid(),
          ],
        ),
      ),
    );
  }
}
