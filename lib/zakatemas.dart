import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'dart:convert';

class ZakatEmas extends StatefulWidget {
  const ZakatEmas({super.key});

  @override
  State<ZakatEmas> createState() => _ZakatEmasState();
}

class _ZakatEmasState extends State<ZakatEmas> {
  final TextEditingController _gramController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final formater = intl.NumberFormat('#,##0.00', 'en_US');
  double _zakatAmount = 0.0;
  // double _nisab = 0.0; 
  bool _nisabStatus = false;

  void _updateZakatAmount() {
    final double grams = double.tryParse(_gramController.text) ?? 0.0;
    final double pricePerGram = double.tryParse(_priceController.text) ?? 0.0;
    setState(() {
      _zakatAmount = grams * pricePerGram * 0.025;
    });
  }

  Future<void> _goldApi() async {
    final request = await http.get(Uri.parse('http://localhost:8040'));

    if (request.statusCode == 200) {
      final response = jsonDecode(request.body);
      setState(() {
        _priceController.text = response['harga'].toString();
        // _nisab = response['nisab'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _goldApiPost() async {
    final double pricePerGram = double.tryParse(_priceController.text) ?? 0.0;
    final double nisab = pricePerGram*85;

    final request = await http.post(Uri.parse('http://localhost:8040'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'harga': pricePerGram,
          'nisab': nisab
        }));
    if (request.statusCode == 200) {
      log('post data success');
    }else{
      log('post data failed');
    }
  }

  void _updateNisabStatus(){
    final double grams = double.tryParse(_gramController.text) ?? 0.0;
    if (grams >= 85) {
      _nisabStatus = true;
    }else{
      _nisabStatus = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _gramController.addListener(_updateZakatAmount);
    _gramController.addListener(_updateNisabStatus);
    _priceController.addListener(_updateZakatAmount);
    _priceController.addListener(_goldApiPost);
    _goldApi();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      appBar: AppBar(
        title: const Text(
          'Zakat Emas',
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
                          'Masukkan Jumlah Emas (gram)',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _gramController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Jumlah Emas',
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Masukkan Harga per Gram',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Harga per Gram',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Jumlah Zakat: Rp $_zakatAmount',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        _nisabStatus? const Text('Sudah Masuk Nisab'):const Text('Belum Masuk Nisab')
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Setiap Muslim yang memiliki harta melebihi nisab dan telah mencapai haul selama satu tahun hijriyah wajib membayar zakat mal. Nisab untuk emas adalah 85 gram dan perak adalah 595 gram. Tarif zakat yang harus dibayarkan adalah sebesar 2,5% dari emas atau perak yang dimiliki.',
                          style: TextStyle(fontSize: 16),
                        ),
                        // SizedBox(height: 20),
                        // Text(
                        //   'Perhitungan zakat emas didasarkan pada berat emas yang dimiliki dan harga emas per gram. Zakat yang harus dikeluarkan adalah sebesar 2.5% dari total nilai emas yang dimiliki.',
                        //   style: TextStyle(fontSize: 16),
                        // ),
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
