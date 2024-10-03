import 'package:flutter/material.dart';
import 'package:zakat_hub/zakatemas.dart';
import 'package:zakat_hub/zakatuang.dart';

class MyIndex extends StatefulWidget {
  const MyIndex({super.key});

  @override
  State<MyIndex> createState() => _MyIndexState();
}

class _MyIndexState extends State<MyIndex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900], // Dark green background
      // appBar: AppBar(
      //   title: const Text('Zakat[HUB]'),
      //   backgroundColor: Colors.green[900], // Match the background color
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Zakat[HUB]',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White title
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ZakatEmas()));
              },
              style: ElevatedButton.styleFrom(
                // primary: Colors.white, // Button color
                backgroundColor: Colors.white, // Text color
              ),
              child: Text(
                'Zakat Emas',
                style: TextStyle(color: Colors.green.shade900),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ZakatUang()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Text color
              ),
              child: Text(
                'Zakat Penghasilan',
                style: TextStyle(color: Colors.green.shade900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
