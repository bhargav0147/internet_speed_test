import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';

class SpeedTestPage extends StatefulWidget {
  const SpeedTestPage({super.key});

  @override
  State<SpeedTestPage> createState() => _SpeedTestPageState();
}

class _SpeedTestPageState extends State<SpeedTestPage> {
    final speedTest = FlutterInternetSpeedTest();

  double downloadRate = 0.0;
  double uploadRate = 0.0;
  double displayRate = 0.0;
  bool isTesting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0A0C1B),
      appBar: AppBar(
        backgroundColor: Color(0xff0A0C1B),
        title: const Text(
          'Speed Test',
          style: TextStyle(
              letterSpacing: 1,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xff32E3CF)),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              SfRadialGauge(
                enableLoadingAnimation: true,
                animationDuration: 5000,
                axes: [
                  RadialAxis(
                    
                    showLastLabel: true,
                    useRangeColorForAxis: true,
                    minimum: 0,
                    maximum: 100,
                    axisLabelStyle: const GaugeTextStyle(color: Color(0xff32E3CF)),
                    ranges: [
                      GaugeRange(
                        startValue: 0,
                        endValue: displayRate,
                        color: Color(0xff32E3CF),
                        
                        startWidth: 5,
                        endWidth: 10,
                      )
                    ],
                    pointers: [
                      NeedlePointer(
                        value: displayRate,
                        needleColor: Color(0xff32E3CF),
                        enableAnimation: true,
                        knobStyle: KnobStyle(color: Color(0xff32E3CF)),
                      ),
                    ],
                    annotations: [
                      GaugeAnnotation(
                        widget: SizedBox(
                          height: 70,
                          child: Center(
                            child: Text(
                              displayRate.toStringAsFixed(2),
                              style: const TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 50,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff32E3CF)),
                            ),
                          ),
                        ),
                        angle: 90,
                        positionFactor: 1.2,
                      ),
                    ],
                  )
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Download',
                          style: TextStyle(
                              letterSpacing: 1,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        Text(
                          downloadRate.toStringAsFixed(2),
                          style: const TextStyle(
                              letterSpacing: 1,
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        const Text(
                          'Mbps',
                          style: TextStyle(
                              letterSpacing: 1,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Upload',
                          style: TextStyle(
                              letterSpacing: 1,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        Text(
                          uploadRate.toStringAsFixed(2),
                          style: const TextStyle(
                              letterSpacing: 1,
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        const Text(
                          'Mbps',
                          style: TextStyle(
                              letterSpacing: 1,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  testSpeedFunction();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff32E3CF),
                    fixedSize: const Size(double.infinity, 55)),
                child: const Center(
                  child: Text(
                    'Test',
                    style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  testSpeedFunction() {
    resetSpeedFunction();
    speedTest.startTesting(
      onStarted: () {
        setState(() {
          isTesting = true;
        });
      },
      onCompleted: (TestResult download, TestResult upload) {
        setState(() {
          downloadRate = download.transferRate;
          displayRate = downloadRate;
        });
        setState(() {
          uploadRate = upload.transferRate;
          displayRate = uploadRate;
          isTesting = false;
        });
        setState(() {
          displayRate = 0.0;
        });
      },
      onProgress: (double percent, TestResult data) {
        setState(() {
          if (data.type == TestType.download) {
            downloadRate = data.transferRate;
            displayRate = downloadRate;
          } else {
            uploadRate = data.transferRate;
            displayRate = uploadRate;
          }
        });
      },
      onError: (String errorMessage, String speedTestError) {
        print("Error Message : $errorMessage");
        print("Speed Test Error : $speedTestError");
      },
      onDefaultServerSelectionInProgress: () {},
      onDefaultServerSelectionDone: (Client? client) {},
      onDownloadComplete: (TestResult data) {
        setState(() {
          downloadRate = data.transferRate;
          displayRate = downloadRate;
        });
      },
      onUploadComplete: (TestResult data) {
        setState(() {
          uploadRate = data.transferRate;
          displayRate = uploadRate;
        });
      },
      onCancel: () {},
    );
  }

  resetSpeedFunction() {
    downloadRate = 0.0;
    uploadRate = 0.0;
    displayRate = 0.0;
    isTesting = false;
  }
}
