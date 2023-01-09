import 'dart:convert';
import 'package:flutter/material.dart';


class DetailsPage extends StatelessWidget {
  final Map rates;

  const DetailsPage({required this.rates});

  @override
  Widget build(BuildContext context) {
    List _currencies = rates.keys.toList();
    List _exchangeRates = rates.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("RATES"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(50),
          child: ListView.builder(
            itemCount: _currencies.length,
            itemBuilder: (_context, _index) {
              String _currency = _currencies[_index].toString().toUpperCase();
              String _rate = _exchangeRates[_index].toString();
              return Padding(
                padding: const EdgeInsets.all(4),
                child: ListTile(
                  title: Text(
                    "$_currency : $_rate",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
