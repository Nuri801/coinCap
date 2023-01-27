import 'dart:convert';
// import 'dart:html';
import 'package:coincap/pages/details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/http_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _deviceWidth;
  HTTPService? _http;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  final List<String> _coins = [
    "bitcoin",
    "ethereum",
    "tether",
    "cardano",
    "ripple"
  ];
  String? pickedCoin = "bitcoin";

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              _selectedCoinDropdown(),
              _dataWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedCoinDropdown() {
    List<DropdownMenuItem<String>> _items = _coins
        .map(
          (e) => DropdownMenuItem(
            alignment: Alignment.center,
            value: e,
            child: Text(
              e,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .toList();
    return DropdownButton(
      value: pickedCoin,
      items: _items,
      onChanged: (_value) {
        setState(() {
          pickedCoin = _value;
        });
      },
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _dataWidgets() {
    return FutureBuilder(
      future: _http!.get("/coins/$pickedCoin"),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          Map _data = jsonDecode(
            _snapshot.data.toString(),
          );
          num _usdPrice = _data["market_data"]["current_price"]["usd"];
          num _change24h = _data["market_data"]["price_change_percentage_24h"];
          String _imageURL = _data["image"]["large"];
          String _coinDescription = _data["description"]["en"];
          Map exchangeRates = _data["market_data"]["current_price"];


          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(height: 80),
              GestureDetector(
                onDoubleTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext _context) {
                        return DetailsPage(rates: exchangeRates);
                      },
                    ),
                  );
                },
                child: _coinImageWidget(_imageURL),
              ),
              SizedBox(height: 10),
              _currentPriceWidget(_usdPrice),
              const SizedBox(height: 20),
              _percentageChangeWidget(_change24h),
              SizedBox(height: 20),
              _descriptionCardWidget(_coinDescription),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget _coinImageWidget(String _imgURL) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.02),
      height: _deviceHeight * 0.15,
      width: _deviceWidth * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_imgURL),
        ),
      ),
    );
  }

  Widget _currentPriceWidget(num _rate) {
    return Text(
      "${_rate.toStringAsFixed(2)} USD",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _percentageChangeWidget(num _change) {
    return Text(
      "${_change.toStringAsFixed(2)} %",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _descriptionCardWidget(String _description) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Color.fromRGBO(
          100,
          88,
          197,
          1.0,
        ),
      ),
      height: _deviceHeight * 0.45,
      width: _deviceWidth * 0.90,
      // margin: EdgeInsets.symmetric(
      //   vertical: _deviceHeight * 0.05,
      // ),
      padding: EdgeInsets.all(_deviceHeight * 0.03),
      child: SingleChildScrollView(
        child: Text(
          textAlign: TextAlign.center,
          _description,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
