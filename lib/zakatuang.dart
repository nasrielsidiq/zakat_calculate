// import 'dart:developer';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart' as intl;
import 'dart:convert';

class ZakatUang extends StatefulWidget {
  const ZakatUang({super.key});

  @override
  State<ZakatUang> createState() => _ZakatUangState();
}

class _ZakatUangState extends State<ZakatUang> {
  final TextEditingController _uangController = TextEditingController();
  int _nisab = 0;
  double _zakatAmount = 0.0;
  bool _nisabStatus = false;

  void _updateZakatAmount() {
    final double uang = double.tryParse(_uangController.text) ?? 0.0;
    setState(() {
      _zakatAmount = uang * 0.025;
      if (_nisab <= uang) {
        _nisabStatus = true;
      }else{
        _nisabStatus = false;
      }
    });
  }
   Future<void> _goldApi() async {
    final request = await http.get(Uri.parse('http://localhost:8040'));

    if (request.statusCode == 200) {
      final response = jsonDecode(request.body);
      setState(() {
        _nisab = response['nisab'];
        // _nisab = response['nisab'];
      });
    } else {
      log('cannot connect to API');
    }
  }

  @override
  void initState() {
    super.initState();
    _uangController.addListener(_updateZakatAmount);
    _goldApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      appBar: AppBar(
        title: const Text(
          'Zakat Uang',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: 800,
            height: 500,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          'Masukkan Jumlah Uang (IDR)',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _uangController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Jumlah Uang',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Jumlah Zakat: Rp $_zakatAmount',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        _nisabStatus? const Text('Sudah masuk nisab'):const Text('Belum masuk nisab')
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Deskripsi',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        // SizedBox(height: 20),
                        // Text(
                        //   'Zakat uang adalah zakat yang wajib dikeluarkan oleh seorang muslim yang memiliki uang dengan jumlah tertentu. Zakat ini bertujuan untuk membersihkan harta dan membantu mereka yang membutuhkan.',
                        //   style: TextStyle(fontSize: 16),
                        // ),
                        SizedBox(height: 20),
                        Text(
                          'Zakat penghasilan adalah bagian dari zakat mal yang wajib dikeluarkan atas harta yang berasal dari pendapatan * 2.5%. Nishab zakat penghasilan sebesar 85 gram emas per tahun.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
