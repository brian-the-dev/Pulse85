import 'package:flutter/material.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:usb_serial/transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:typed_data';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulse85',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Pulse85'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<FlSpot> sensorData = [];
  String bpm = "0";

  void _getData() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isNotEmpty) {
      for (UsbDevice device in devices) {
        if (device.vid == 5840 && device.pid == 2174) {
          print("Found Pulse85 HW");
          UsbPort? port = await device.create();
          bool? openResult = await port?.open();
          if (openResult != null && openResult && port != null) {
            print("Port opened");
            await port.setDTR(true);
            await port.setRTS(true);
            port.setPortParameters(115200, UsbPort.DATABITS_8,
                UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);
            await port.write(Uint8List.fromList([0x10, 0x00]));
            Transaction<String> transaction = Transaction.stringTerminated(
                port.inputStream as Stream<Uint8List>,
                Uint8List.fromList([13, 10]));
            transaction.stream.listen((String analog) {
              if (sensorData.length < 200) {
                DateTime time = DateTime.now();
                FlSpot data = FlSpot(time.millisecondsSinceEpoch.toDouble(),
                    double.parse(analog));
                setState(() {
                  sensorData.add(data);
                });
              } else {
                sensorData.removeAt(0);
                DateTime time = DateTime.now();
                FlSpot data = FlSpot(time.millisecondsSinceEpoch.toDouble(),
                    double.parse(analog));
                setState(() {
                  sensorData.add(data);
                });
              }
              setState(() {
                bpm = getBPM(sensorData).round().toString();
              });
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(children: [
          const Spacer(),
          Text("Your heart rate is:", style: Theme.of(context).textTheme.headline5),
          Text(bpm, style: Theme.of(context).textTheme.headline1),
          const Spacer(),
          Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 150,
              child: LineChart(LineChartData(
                minY: 500,
                maxY: 520,
                clipData: FlClipData.vertical(),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: sensorData,
                    isCurved: true,
                    dotData: FlDotData(show: false),
                  )
                ],
                titlesData: FlTitlesData(
                  show: false,
                ),
              )))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getData,
        tooltip: 'Increment',
        child: const Icon(Icons.addchart),
      ),
    );
  }
}

double getBPM(List<FlSpot> data) {
  double threshold = 515;
  List<double> timeBeats = [];
  for (int i = 0; i < data.length; i++) {
    if (i > 0) {
      if (data[i - 1].y <= threshold && data[i].y > threshold) {
        timeBeats.add(data[i].x);
      }
    }
  }

  if (data.length > 30) {
    List<double> dataBeats = [];
    data.reversed.take(30).forEach((element) {
      dataBeats.add(element.y);
    });
    dataBeats.sort();
    print("H: " + dataBeats.last.toString());
    if (dataBeats.last < threshold) {
      return 0;
    }
  }

  if (timeBeats.length > 1) {
    List<double> deltaTime = [];
    for (int i = 1; i < timeBeats.length; i++) {
      deltaTime.add(timeBeats[i] - timeBeats[i - 1]);
    }
    return (60 /
        ((deltaTime.reduce((a, b) => a + b) / deltaTime.length) / 1000));
  }

  return 0;
}
