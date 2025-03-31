import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> stockSymbols = ["AAPL", "GOOG", "AMZN", "NFLX", "TSLA"];
  Map<String, Map<String, dynamic>> stockData = {};
  Set<String> watchlist = {};

  Map<String, Map<String, dynamic>> mockData = {
    "AAPL": {
      "price": 145.09,
      "change": -1.23,
      "percent_change": "-0.84%",
      "volume": "72,154,890",
      "prev_close": 146.32,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "GOOG": {
      "price": 2734.75,
      "change": 15.56,
      "percent_change": "+0.57%",
      "volume": "1,287,000",
      "prev_close": 2719.19,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "AMZN": {
      "price": 3468.23,
      "change": -20.45,
      "percent_change": "-0.58%",
      "volume": "3,650,500",
      "prev_close": 3488.68,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "MSFT": {
      "price": 294.25,
      "change": 5.43,
      "percent_change": "+1.87%",
      "volume": "18,234,678",
      "prev_close": 288.82,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "TSLA": {
      "price": 678.90,
      "change": -10.22,
      "percent_change": "-1.48%",
      "volume": "25,896,500",
      "prev_close": 689.12,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "NFLX": {
      "price": 582.17,
      "change": 7.83,
      "percent_change": "+1.36%",
      "volume": "2,134,290",
      "prev_close": 574.34,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "SPY": {
      "price": 413.97,
      "change": -4.56,
      "percent_change": "-1.09%",
      "volume": "12,500,450",
      "prev_close": 418.53,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "BA": {
      "price": 211.65,
      "change": -2.48,
      "percent_change": "-1.16%",
      "volume": "4,879,540",
      "prev_close": 214.13,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "NVDA": {
      "price": 195.22,
      "change": 3.15,
      "percent_change": "+1.64%",
      "volume": "11,256,780",
      "prev_close": 192.07,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
    "DIS": {
      "price": 170.12,
      "change": -1.02,
      "percent_change": "-0.60%",
      "volume": "7,134,810",
      "prev_close": 171.14,
      "last_update": DateTime.now().toLocal().toString().substring(0, 19)
    },
  };

  @override
  void initState() {
    super.initState();
    _fetchStockData();
  }

  Future<void> _fetchStockData() async {
    try {
      print("Fetching stock data...");

      List<Future<http.Response>> requests = stockSymbols.map((stock) =>
          http.get(Uri.parse('https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$stock&apikey=DCZ1RMFPGBBG2P2J'))).toList();

      final responses = await Future.wait(requests);

      setState(() {
        stockData = {};

        for (int i = 0; i < stockSymbols.length; i++) {
          final response = responses[i];
          print("Response for ${stockSymbols[i]}: ${response.body}");

          if (response.statusCode == 200) {
            var data = jsonDecode(response.body)["Global Quote"];

            if (data != null && data.containsKey("05. price")) {
              stockData[stockSymbols[i]] = {
                "price": double.tryParse(data["05. price"]) ?? 0.0,
                "change": double.tryParse(data["09. change"]) ?? 0.0,
                "percent_change": data["10. change percent"] ?? "0%",
                "volume": data["06. volume"] ?? "0",
                "prev_close": double.tryParse(data["08. previous close"]) ?? 0.0,
                "last_update": DateTime.now().toLocal().toString().substring(0, 19),
              };
            } else {
              print("⚠️ Missing data for ${stockSymbols[i]}");
              _useMockData();
            }
          } else {
            print("❌ Error fetching ${stockSymbols[i]}: ${response.statusCode}");
            _useMockData();
          }
        }
      });

      print("✅ Stock data updated: $stockData");

    } catch (e) {
      print("🚨 Error fetching stock data: $e");
      _useMockData();
    }
  }

  void _useMockData() {
    setState(() {
      stockData = mockData;
    });
    print("Using mock data for stock information.");
  }

  void _toggleWatchlist(String stock) {
    setState(() {
      if (watchlist.contains(stock)) {
        watchlist.remove(stock);
      } else {
        watchlist.add(stock);
      }
    });
  }

  void _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void _showWatchlist(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => WatchlistWidget(watchlist.toList(), _toggleWatchlist),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back gesture
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // This removes the back button
          title: Row(
            children: [
              Icon(Icons.bar_chart, size: 28),
              SizedBox(width: 10),
              Text("Stock Dashboard", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            ],
          ),
          actions: [
            IconButton(icon: Icon(Icons.star), onPressed: () => _showWatchlist(context)),
            IconButton(icon: Icon(Icons.refresh), onPressed: _fetchStockData),
            IconButton(icon: Icon(Icons.logout), onPressed: () => _logout(context)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Stock Market Overview",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: stockData.isEmpty
                    ? Center(child: Text("📉 No stock data available. Pull to refresh!", style: TextStyle(fontSize: 16)))
                    : ListView.builder(
                        itemCount: stockData.length,
                        itemBuilder: (context, index) {
                          String stock = stockData.keys.elementAt(index);
                          var data = stockData[stock]!;

                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: ListTile(
                              leading: Icon(
                                data["change"] >= 0 ? Icons.trending_up : Icons.trending_down,
                                color: data["change"] >= 0 ? Colors.green : Colors.red,
                              ),
                              title: Text(
                                "$stock - \$${data["price"].toStringAsFixed(2)}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Change: ${data["change"] >= 0 ? "+" : ""}${data["change"].toStringAsFixed(2)} (${data["percent_change"]})",
                                    style: TextStyle(
                                      color: data["change"] >= 0 ? Colors.green : Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text("Volume: ${data["volume"]}"),
                                  Text("Prev Close: \$${data["prev_close"].toStringAsFixed(2)}"),
                                  Text("Last Update: ${data["last_update"]}", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  watchlist.contains(stock) ? Icons.star : Icons.star_border,
                                  color: watchlist.contains(stock) ? Colors.amber : Colors.grey,
                                ),
                                onPressed: () => _toggleWatchlist(stock),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WatchlistWidget extends StatelessWidget {
  final List<String> watchlist;
  final Function(String) toggleWatchlist;

  WatchlistWidget(this.watchlist, this.toggleWatchlist);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your Watchlist", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Divider(),
          Expanded(
            child: watchlist.isEmpty
                ? Center(child: Text("⭐ No stocks in watchlist"))
                : ListView.builder(
                    itemCount: watchlist.length,
                    itemBuilder: (context, index) {
                      String stock = watchlist[index];
                      return Card(
                        child: ListTile(
                          title: Text(stock, style: TextStyle(fontSize: 18)),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => toggleWatchlist(stock),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
